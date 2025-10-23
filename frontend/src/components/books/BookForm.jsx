import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import apiClient from '../../api';

const BookForm = () => {
  const [title, setTitle] = useState('');
  const [isbn, setIsbn] = useState('');
  const [pages, setPages] = useState('');
  const [authorId, setAuthorId] = useState('');
  const [authors, setAuthors] = useState([]);
  const [error, setError] = useState('');
  const navigate = useNavigate();

  useEffect(() => {
    const fetchAuthors = async () => {
      try {
        const response = await apiClient.get('/people');
        setAuthors(response.data.data);
      } catch (err) {
        setError('Could not load authors for the dropdown.');
      }
    };
    fetchAuthors();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!pages) {
      setError('Number of pages is always required.');
      return;
    }
    if (!isbn && (!title || !authorId)) {
      setError('Please provide an ISBN, or both a Title and an Author.');
      return;
    }

    const bookData = {
      status: 'published',
      pages,
    };

    if (title) bookData.title = title;
    if (isbn) bookData.isbn = isbn;
    if (authorId) bookData.author_id = authorId;

    try {
      await apiClient.post('/books', { book: bookData });
      navigate('/books');
    } catch (err) {
      setError(err.response?.data?.errors?.join(', ') || 'Could not create the book. Please check the details and try again.');
    }
  };

  return (
    <div className="flex justify-center">
      <div className="w-full max-w-lg p-8 mt-10 bg-white rounded-lg shadow-xl">
        <h2 className="text-3xl font-bold text-center text-gray-800">Add a New Book</h2>
        <p className="mt-2 text-center text-gray-600">Add a book using its ISBN or by entering the details manually.</p>
        
        <div className="mt-8">
          {error && <p className="mb-4 text-center text-red-500">{error}</p>}
          <form className="space-y-6" onSubmit={handleSubmit}>
            
            <div className="relative my-4">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300"></div>
              </div>
              <div className="relative flex justify-center">
                <span className="px-2 text-sm text-gray-500 bg-white">Book Details</span>
              </div>
            </div>

            <div>
              <label htmlFor="pages" className="text-sm font-medium text-gray-700">
                Pages (Required)
              </label>
              <input
                id="pages"
                name="pages"
                type="number"
                value={pages}
                onChange={(e) => setPages(e.target.value)}
                required
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>

            <div className="relative my-8">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300"></div>
              </div>
              <div className="relative flex justify-center">
                <span className="px-2 text-sm text-gray-500 bg-white">Option 1: Use ISBN</span>
              </div>
            </div>

            <div>
              <label htmlFor="isbn" className="text-sm font-medium text-gray-700">
                ISBN
              </label>
              <input
                id="isbn"
                name="isbn"
                type="text"
                value={isbn}
                onChange={(e) => setIsbn(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
                placeholder="e.g., 9780140328721 (Title and Author will be auto-filled)"
              />
            </div>

            <div className="relative my-8">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300"></div>
              </div>
              <div className="relative flex justify-center">
                <span className="px-2 text-sm text-gray-500 bg-white">Option 2: Manual Entry</span>
              </div>
            </div>

            <div>
              <label htmlFor="title" className="text-sm font-medium text-gray-700">
                Title
              </label>
              <input
                id="title"
                name="title"
                type="text"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>

            <div>
              <label htmlFor="authorId" className="text-sm font-medium text-gray-700">
                Author
              </label>
              <select
                id="authorId"
                name="authorId"
                value={authorId}
                onChange={(e) => setAuthorId(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              >
                <option value="">Select an Author</option>
                {authors.map((author) => (
                  <option key={author.id} value={author.id}>
                    {author.attributes.name}
                  </option>
                ))}
              </select>
            </div>
            
            <div className="pt-4">
              <button
                type="submit"
                className="w-full px-4 py-2 font-bold text-white bg-indigo-600 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Add Book
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default BookForm;
