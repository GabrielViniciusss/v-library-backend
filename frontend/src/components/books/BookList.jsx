import React, { useState, useEffect } from 'react';
import apiClient from '../../api';

const BookList = () => {
  const [books, setBooks] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchBooks = async () => {
      try {
        const response = await apiClient.get('/books');
        // The data is nested under a `data` property
        const bookData = response.data.data.map(item => item.attributes);
        setBooks(bookData);
      } catch (err) {
        setError('Could not fetch books.');
      }
    };

    fetchBooks();
  }, []);

  return (
    <div>
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold text-gray-800">Book Collection</h1>
        {error && <p className="text-red-500">{error}</p>}
      </div>
      <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
        {books.map((book, index) => (
          <div key={index} className="overflow-hidden bg-white rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300">
            <div className="p-6">
              <h3 className="text-xl font-bold text-gray-800 truncate">{book.title}</h3>
              <p className="mt-2 text-sm text-gray-600">ISBN: {book.isbn}</p>
              <div className="mt-4">
                <span className="inline-block px-3 py-1 text-xs font-semibold tracking-wider text-green-800 uppercase bg-green-200 rounded-full">
                  {book.status}
                </span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default BookList;
