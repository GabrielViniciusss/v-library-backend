import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import apiClient from '../../api';

const SignUp = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    if (password !== passwordConfirmation) {
      setError("Passwords don't match");
      return;
    }

    try {
      await apiClient.post('/signup', {
        user: {
          email,
          password,
          password_confirmation: passwordConfirmation,
        },
      });
      navigate('/signin');
    } catch (err) {
      let errorMessage = 'An error occurred during sign up.';
      const errors = err.response?.data?.errors;
      if (errors) {
        // Convert errors object to a string
        errorMessage = Object.keys(errors)
          .map(key => `${key} ${errors[key].join(', ')}`)
          .join('; ');
      } else if (err.response?.data?.status?.message) {
        errorMessage = err.response.data.status.message;
      }
      setError(errorMessage);
    }
  };

  return (
    <div className="flex justify-center">
      <div className="w-full max-w-lg p-8 mt-10 bg-white rounded-lg shadow-xl">
        <h2 className="text-3xl font-bold text-center text-gray-800">Create an Account</h2>
        <p className="mt-2 text-center text-gray-600">Join us and start building your digital library.</p>
        <div className="mt-8">
          {error && <p className="mb-4 text-center text-red-500">{error}</p>}
          <form className="space-y-6" onSubmit={handleSubmit}>
            <div>
              <label
                htmlFor="email"
                className="text-sm font-medium text-gray-700"
              >
                Email
              </label>
              <input
                id="email"
                name="email"
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>
            <div>
              <label
                htmlFor="password"
                className="text-sm font-medium text-gray-700"
              >
                Password
              </label>
              <input
                id="password"
                name="password"
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>
            <div>
              <label
                htmlFor="password-confirmation"
                className="text-sm font-medium text-gray-700"
              >
                Confirm Password
              </label>
              <input
                id="password-confirmation"
                name="password-confirmation"
                type="password"
                required
                value={passwordConfirmation}
                onChange={(e) => setPasswordConfirmation(e.target.value)}
                className="w-full px-4 py-2 mt-1 text-gray-700 bg-gray-100 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent"
              />
            </div>
            <div>
              <button
                type="submit"
                className="w-full px-4 py-3 text-sm font-medium text-white bg-indigo-600 border border-transparent rounded-md shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                Sign Up
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default SignUp;
