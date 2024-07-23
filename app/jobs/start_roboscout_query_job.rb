class StartRoboscoutQueryJob < ApplicationJob
  queue_as :default

  def perform(roboscout_query_id)
    roboscout_query = RoboscoutQuery.find(roboscout_query_id)
    roboscout_query.update(status: :in_progress)
    
    search_query = roboscout_query.query
    authors_count = 0

    begin
      # Step 1: Search for works on OpenAlex
      works = search_works(search_query)

      works.each do |work|
        break if authors_count >= 8

        # Step 2: Extract authors and create Person models
        work['authorships'].each do |authorship|
          break if authors_count >= 8

          author = authorship['author']
          person = Person.find_or_create_by(openalex_id: author['id']) do |p|
            p.name = author['display_name']
            p.affiliation = authorship['institutions'].map { |inst| inst['display_name'] }.join(', ')
          end

          # Count the number of publications for the author, limited to 25
          person.update(publications_count: count_publications_for_author(author['id']))

          # Associate person with roboscout_query
          roboscout_query.people << person unless roboscout_query.people.include?(person)
          authors_count += 1

          # Step 3: Add recent publications for each person (limited to the first 25)
          recent_works = get_recent_works_for_author(author['id'])
          recent_works.each_with_index do |author_work, index|
            break if index >= 25  # Ensure only the first 25 publications are processed

            publication = Publication.find_or_create_by(openalex_id: author_work['id']) do |pub|
              pub.title = author_work['title']
              pub.abstract = author_work['abstract_inverted_index']&.keys&.join(' ')
              pub.publication_date = author_work['publication_date']
              pub.position = index + 1  # Set the position of the publication
            end
            person.publications << publication unless person.publications.include?(publication)
          end
        end
      end
    ensure
      # Update the query status to finished after processing
      roboscout_query.update(status: :finished)
    end
  end

  private

  def search_works(query)
    response = HTTParty.get("https://api.openalex.org/works", {
      query: {
        search: query,
        per_page: 25
      }
    })

    if response.success?
      JSON.parse(response.body)['results']
    else
      Rails.logger.error("Failed to fetch works: #{response.body}")
      []
    end
  end

  def count_publications_for_author(author_id)
    response = HTTParty.get("https://api.openalex.org/works", {
      query: {
        filter: "authorships.author.id:#{author_id}",
        per_page: 25
      }
    })
  
    if response.success?
      JSON.parse(response.body)['results'].size
    else
      Rails.logger.error("Failed to count publications for author #{author_id}: #{response.body}")
      0
    end
  end
  
  def get_recent_works_for_author(author_id)
    response = HTTParty.get("https://api.openalex.org/works", {
      query: {
        filter: "authorships.author.id:#{author_id}",
        per_page: 25
      }
    })

    if response.success?
      JSON.parse(response.body)['results']
    else
      Rails.logger.error("Failed to fetch recent works for author #{author_id}: #{response.body}")
      []
    end
  end
end


# class StartRoboscoutQueryJob < ApplicationJob
#   queue_as :default

#   def perform(roboscout_query_id)
#     roboscout_query = RoboscoutQuery.find(roboscout_query_id)
#     search_query = roboscout_query.query

#     # Step 1: Search for works on OpenAlex
#     works = search_works(search_query)

#     authors_count = 0

#     works.each do |work|
#       break if authors_count >= 8

#       # Step 2: Extract authors and create Person models
#       work['authorships'].each do |authorship|
#         break if authors_count >= 8

#         author = authorship['author']
#         person = Person.find_or_create_by(openalex_id: author['id']) do |p|
#           p.name = author['display_name']
#           p.affiliation = authorship['institutions'].map { |inst| inst['display_name'] }.join(', ')
#         end

#         # Count the number of publications for the author, limited to 25
#         person.update(publications_count: count_publications_for_author(author['id']))

#         # Associate person with roboscout_query
#         roboscout_query.people << person unless roboscout_query.people.include?(person)
#         authors_count += 1

#         # Step 3: Add recent publications for each person (limited to the first 25)
#         recent_works = get_recent_works_for_author(author['id'])
#         recent_works.each_with_index do |author_work, index|
#           break if index >= 25  # Ensure only the first 25 publications are processed

#           publication = Publication.find_or_create_by(openalex_id: author_work['id']) do |pub|
#             pub.title = author_work['title']
#             pub.abstract = author_work['abstract_inverted_index']&.keys&.join(' ')
#             pub.publication_date = author_work['publication_date']
#             pub.position = index + 1  # Set the position of the publication
#           end
#           person.publications << publication unless person.publications.include?(publication)
#         end
#       end
#     end
#   end

#   private

#   def search_works(query)
#     response = HTTParty.get("https://api.openalex.org/works", {
#       query: {
#         search: query,
#         per_page: 25
#       }
#     })

#     if response.success?
#       JSON.parse(response.body)['results']
#     else
#       Rails.logger.error("Failed to fetch works: #{response.body}")
#       []
#     end
#   end

#   def count_publications_for_author(author_id)
#     response = HTTParty.get("https://api.openalex.org/works", {
#       query: {
#         filter: "authorships.author.id:#{author_id}",
#         per_page: 25
#       }
#     })
  
#     if response.success?
#       JSON.parse(response.body)['results'].size
#     else
#       Rails.logger.error("Failed to count publications for author #{author_id}: #{response.body}")
#       0
#     end
#   end
  

#   def get_recent_works_for_author(author_id)
#     response = HTTParty.get("https://api.openalex.org/works", {
#       query: {
#         filter: "authorships.author.id:#{author_id}",
#         per_page: 25
#       }
#     })

#     if response.success?
#       JSON.parse(response.body)['results']
#     else
#       Rails.logger.error("Failed to fetch recent works for author #{author_id}: #{response.body}")
#       []
#     end
#   end
# end
