// src/components/RoboscoutQueryDetails.jsx
import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

function RoboscoutQueryDetail() {
  const { id } = useParams();
  const [queryDetails, setQueryDetails] = useState(null);
  const [people, setPeople] = useState([]);
  const [error, setError] = useState("");

  useEffect(() => {
    // Fetch query details
    fetch(`/roboscout_queries/${id}`)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        console.log("Query Details:", data);
        setQueryDetails(data);
      })
      .catch((error) => setError(error.message));

    // Fetch related people
    fetch(`/roboscout_queries/${id}/people`)
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data) => {
        console.log("People Data:", data);
        const peopleWithLikeState = data.map((person) => {
          const [first_name, ...last_name_parts] = person.name.split(" ");
          const last_name = last_name_parts.join(" ");
          return {
            id: person.id,
            first_name,
            last_name,
            publications: person.publications_count || 0,
            relevance_score: person.relevance_score || 0,
            liked: false,
          };
        });
        setPeople(peopleWithLikeState);
      })
      .catch((error) => setError(error.message));
  }, [id]);

  const toggleLike = (personId) => {
    setPeople((prevPeople) =>
      prevPeople.map((person) =>
        person.id === personId ? { ...person, liked: !person.liked } : person
      )
    );
  };

  if (error) return <div style={{ color: "red" }}>Error: {error}</div>;
  if (!queryDetails) return <div>Loading...</div>;

  // Sort people by ID
  const sortedPeople = [...people].sort((a, b) => a.id - b.id);

  return (
    <div
      style={{
        padding: "20px",
        marginBottom: "20px",
        backgroundColor: "#f0f0f0",
        border: "1px solid #ccc",
        borderRadius: "8px",
        boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      }}
    >
      <div
        style={{
          display: "flex",
          justifyContent: "space-between",
          padding: "10px",
        }}
      >
        <div style={{ padding: "10px" }}>
          <h1 style={{ fontWeight: "bold", fontSize: "24px" }}>{queryDetails.name}</h1>
          <h2>Status: {queryDetails.status}</h2>
          <h3>People Found:</h3>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <thead>
              <tr>
                <th style={{ border: "1px solid #ddd", padding: "8px" }}>ID</th>
                <th style={{ border: "1px solid #ddd", padding: "8px" }}>First Name</th>
                <th style={{ border: "1px solid #ddd", padding: "8px" }}>Last Name</th>
                <th style={{ border: "1px solid #ddd", padding: "8px" }}>Publications</th>
                <th style={{ border: "1px solid #ddd", padding: "8px" }}>Relevance</th>
                <th style={{ border: "1px solid #ddd", padding: "8px" }}>Liked?</th>
              </tr>
            </thead>
            <tbody>
              {sortedPeople.map((person) => (
                <tr key={person.id}>
                  <td style={{ border: "1px solid #ddd", padding: "8px" }}>{person.id}</td>
                  <td style={{ border: "1px solid #ddd", padding: "8px" }}>{person.first_name}</td>
                  <td style={{ border: "1px solid #ddd", padding: "8px" }}>{person.last_name}</td>
                  <td style={{ border: "1px solid #ddd", padding: "8px" }}>{person.publications}</td>
                  <td style={{ border: "1px solid #ddd", padding: "8px" }}>{person.relevance_score}</td>
                  <td style={{ border: "1px solid #ddd", padding: "8px" }}>
                    <button
                      onClick={() => toggleLike(person.id)}
                      style={{
                        backgroundColor: person.liked ? "green" : "grey",
                        color: "white",
                        border: "none",
                        padding: "5px 10px",
                        borderRadius: "4px",
                        cursor: "pointer",
                      }}
                    >
                      {person.liked ? "Unlike" : "Like"}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default RoboscoutQueryDetail;
