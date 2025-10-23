import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import apiClient from '../../api';

const AuthorForm = () => {
  const [name, setName] = useState('');
  const [dateOfBirth, setDateOfBirth] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (!name || !dateOfBirth) {
      setError('Please fill in all fields.');
      return;
    }

    try {
      await apiClient.post('/people', {
        person: {
          name,
          date_of_birth: dateOfBirth,
        },
      });
      navigate('/authors');
    } catch (err) {
      setError(err.response?.data?.errors?.join(', ') || 'Could not create the author.');
    }
  };

  return (
    <div className="flex justify-center">
      <div className="w-full max-w-lg p-8 mt-10 bg-white rounded-lg shadow-xl">
        <h2 className="text-3xl font-bold text-center text-gray-800">Add a New Author</h2>
        <p className="mt-2 text-center text-gray-600">Fill out the details to add a new author.</p>
        <div className="mt-8">
          {error && <p className="mb-4 text-center text-red-500">{error}</p>}
          <form className="space-y-6" onSubmit={handleSubmit}>
            <div>
              <label htmlFor="name" className="text-sm font-medium text-gray-700">
                Name
              </label>
              <input
                id="name"
                name="name"
                type="text"
                required
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-white border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              />
            </div>
            <div>
              <label htmlFor="dateOfBirth" className="text-sm font-medium text-gray-700">
                Date of Birth
              </label>
              <input
                id="dateOfBirth"
                name="dateOfBirth"
                type="date"
                required
                value={dateOfBirth}
                onChange={(e) => setDateOfBirth(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-white border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              />
            </div>
            <div>
              <button
                type="submit"
                className="w-full px-4 py-2 font-bold text-white bg-indigo-600 rounded-lg shadow hover:bg-indigo-700 hover:translate-y-[1px] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition"
              >
                Create Author
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default AuthorForm;
