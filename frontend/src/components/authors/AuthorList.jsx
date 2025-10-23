import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import apiClient from '../../api';

const AuthorList = () => {
  const [authors, setAuthors] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchAuthors = async () => {
      try {
        const response = await apiClient.get('/people');
        setAuthors(response.data.data);
      } catch (err) {
        setError('Could not fetch authors.');
      } finally {
        setLoading(false);
      }
    };

    fetchAuthors();
  }, []);

  if (loading) {
    return <div className="text-center">Loading authors...</div>;
  }

  if (error) {
    return <div className="text-center text-red-500">{error}</div>;
  }

  return (
    <div className="w-full max-w-6xl mx-auto">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-4xl font-bold text-gray-800">Authors</h1>
        <Link
          to="/authors/new"
          className="px-4 py-2 font-bold text-white bg-indigo-600 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
        >
          + Add Author
        </Link>
      </div>
      
      <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
        {authors.length > 0 ? (
          authors.map((author) => (
            <div key={author.id} className="p-6 bg-white rounded-xl shadow-md">
              <h2 className="text-xl font-semibold text-gray-900">{author.attributes.name}</h2>
              <p className="mt-2 text-gray-600">
                Born: {new Date(author.attributes.date_of_birth).toLocaleDateString()}
              </p>
              <p className="mt-1 text-sm text-gray-500">ID: {author.id}</p>
            </div>
          ))
        ) : (
          <p className="col-span-full text-center text-gray-500">No authors found.</p>
        )}
      </div>
    </div>
  );
};

export default AuthorList;
