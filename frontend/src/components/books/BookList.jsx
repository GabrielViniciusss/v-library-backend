import React, { useState, useEffect } from 'react';
import apiClient from '../../api';

const BookList = () => {
  const [books, setBooks] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchBooks = async () => {
      try {
        const response = await apiClient.get('/books');
        const { data, included } = response.data;

        // Handle cases where there might be no books or included data
        if (!data || !included) {
          setBooks([]);
          return;
        }

        // 1. Create a map of authors from the 'included' array for efficient lookup
        const authorMap = included.reduce((acc, item) => {
          if (item.type === 'person' || item.type === 'institution') {
            acc[item.id] = item.attributes.name;
          }
          return acc;
        }, {});

        // 2. Map over the books and combine them with the author's name
        const populatedBooks = data.map(book => {
          const authorId = book.relationships.author.data.id;
          const authorName = authorMap[authorId] || 'Unknown Author';
          return {
            ...book.attributes,
            id: book.id, // Use the actual book ID for the key
            authorName: authorName
          };
        });

        setBooks(populatedBooks);
      } catch (err) {
        setError('Could not fetch books.');
      }
    };

    fetchBooks();
  }, []);

  return (
    <div className="w-full max-w-6xl mx-auto">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold text-gray-800">Book Collection</h1>
        {error && <p className="text-red-500">{error}</p>}
      </div>
      <div className="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
        {books.map((book) => (
          <div key={book.id} className="overflow-hidden bg-white rounded-xl shadow-md hover:shadow-lg transition-shadow duration-300">
            <div className="p-6">
              <h3 className="text-xl font-bold text-gray-800 truncate">{book.title}</h3>
              <p className="mt-1 text-sm font-medium text-gray-700">by {book.authorName}</p>
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
