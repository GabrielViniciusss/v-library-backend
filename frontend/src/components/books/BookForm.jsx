import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import apiClient from '../../api';

const BookForm = () => {
  const [title, setTitle] = useState('');
  const [isbn, setIsbn] = useState('');
  const [authorId, setAuthorId] = useState(''); // Assuming you have a way to get author IDs
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!title || !isbn || !authorId) {
      setError('Please fill in all fields.');
      return;
    }

    try {
      await apiClient.post('/books', {
        book: {
          title,
          isbn,
          author_id: authorId,
          // Add other book fields as necessary, e.g., status
          status: 'published',
        },
      });
      navigate('/books');
    } catch (err) {
      setError(err.response?.data?.errors?.join(', ') || 'Could not create the book.');
    }
  };

  return (
    <div className="flex justify-center">
      <div className="w-full max-w-lg p-8 mt-10 bg-white rounded-lg shadow-xl">
        <h2 className="text-3xl font-bold text-center text-gray-800">Add a New Book</h2>
        <p className="mt-2 text-center text-gray-600">Fill out the details to add a new book to the collection.</p>
        <div className="mt-8">
          {error && <p className="mb-4 text-center text-red-500">{error}</p>}
          <form className="space-y-6" onSubmit={handleSubmit}>
            <div>
              <label htmlFor="title" className="text-sm font-medium text-gray-700">
                Title
              </label>
              <input
                id="title"
                name="title"
                type="text"
                required
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>
            <div>
              <label htmlFor="isbn" className="text-sm font-medium text-gray-700">
                ISBN
              </label>
              <input
                id="isbn"
                name="isbn"
                type="text"
                required
                value={isbn}
                onChange={(e) => setIsbn(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>
            <div>
              <label htmlFor="authorId" className="text-sm font-medium text-gray-700">
                Author ID
              </label>
              <input
                id="authorId"
                name="authorId"
                type="number"
                required
                value={authorId}
                onChange={(e) => setAuthorId(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                placeholder="Enter an existing author ID"
              />
              {/* In a real app, this would be a dropdown/search for authors */}
            </div>
            <div>
              <button
                type="submit"
                className="w-full px-4 py-3 text-sm font-medium text-white bg-indigo-600 border border-transparent rounded-md shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Create Book
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default BookForm;
