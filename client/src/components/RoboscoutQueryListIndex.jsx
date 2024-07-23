import React, { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Link } from "react-router-dom";

function RoboscoutQueryListIndex() {
  const queryClient = useQueryClient();
  const [searchTerm, setSearchTerm] = useState("");
  const [error, setError] = useState("");
  const [peopleCounts, setPeopleCounts] = useState({});

  const fetchQueries = () => {
    return fetch(`http://localhost:3000/roboscout_queries`, {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      });
  };

  const { data: queries, status, refetch } = useQuery(
    ["roboscoutQueries"],
    fetchQueries,
    {
      refetchInterval: 60000, // Poll every 60 seconds
      onError: (error) => setError(error.message),
    }
  );

  const createQuery = (newQuery) => {
    return fetch(`http://localhost:3000/roboscout_queries`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ query: newQuery }),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      });
  };

  const mutation = useMutation(createQuery, {
    onSuccess: (data) => {
      queryClient.invalidateQueries("roboscoutQueries");
      setPeopleCounts((prev) => ({ ...prev, [data.id]: 0 }));
    },
    onError: (error) => {
      setError(error.message);
    },
  });

  const handleSearch = (e) => {
    e.preventDefault();
    if (searchTerm.trim() === "") {
      setError("Search term cannot be empty");
      return;
    }
    setError("");
    mutation.mutate(searchTerm);
    setSearchTerm("");
  };

  useEffect(() => {
    const interval = setInterval(() => {
      refetch();
    }, 60000); // Poll every 60 seconds to check for updates

    return () => clearInterval(interval); // Cleanup interval on component unmount
  }, [refetch]);

  useEffect(() => {
    if (status === "success" && queries) {
      console.log("Fetched queries:", queries); // Log the entire queries object
      const newCounts = {};
      queries.forEach((query) => {
        console.log(`Query ID: ${query.id}, People:`, query.people); // Log each query's people
        const peopleCount = query.people ? query.people.length : 0;
        newCounts[query.id] = peopleCount;
        console.log(`Query ID: ${query.id}, People Count: ${peopleCount}`);
      });
      setPeopleCounts(newCounts);
      console.log("Updated peopleCounts: ", newCounts); // Log the updated peopleCounts
    }
  }, [status, queries]);

  return (
    <div>
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
            <h1 style={{ fontWeight: "bold", fontSize: "24px" }}>Roboscout Queries</h1>
            <form onSubmit={handleSearch} style={{ marginBottom: "10px" }}>
              <input
                type="text"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                placeholder="Search Query"
                style={{
                  padding: "8px",
                  border: "1px solid #ccc",
                  borderRadius: "4px",
                }}
              />
              <button
                type="submit"
                style={{
                  padding: "8px 12px",
                  marginLeft: "10px",
                  backgroundColor: "#007BFF",
                  color: "white",
                  fontWeight: "bold",
                  border: "none",
                  borderRadius: "4px",
                  cursor: "pointer",
                }}
              >
                Search
              </button>
            </form>
            {error && <div style={{ color: "red" }}>{error}</div>}
            {status === "loading" && <div>Loading...</div>}
            {status === "error" && <div>Error loading queries</div>}
            {status === "success" && (
              <table style={{ width: "100%", borderCollapse: "collapse" }}>
                <thead>
                  <tr>
                    <th style={{ border: "1px solid #ddd", padding: "8px" }}>ID</th>
                    <th style={{ border: "1px solid #ddd", padding: "8px" }}>Query</th>
                    <th style={{ border: "1px solid #ddd", padding: "8px" }}>Progress</th>
                    <th style={{ border: "1px solid #ddd", padding: "8px" }}>Results</th>
                  </tr>
                </thead>
                <tbody>
                  {queries.map((query) => (
                    <tr key={query.id}>
                      <td style={{ border: "1px solid #ddd", padding: "8px" }}>{query.id}</td>
                      <td style={{ border: "1px solid #ddd", padding: "8px" }}>
                        <Link
                          to={`/roboscout_queries/${query.id}`}
                          style={{ color: "#007BFF", textDecoration: "none" }}
                        >
                          {query.query}
                        </Link>
                      </td>
                      <td style={{ border: "1px solid #ddd", padding: "8px" }}>
                        {query.status}
                      </td>
                      <td style={{ border: "1px solid #ddd", padding: "8px" }}>
                        {peopleCounts[query.id] || 0}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default RoboscoutQueryListIndex;
