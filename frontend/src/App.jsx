import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes, Link, useNavigate } from 'react-router-dom';
import SignIn from './components/auth/SignIn.jsx';
import SignUp from './components/auth/SignUp.jsx';
import BookList from './components/books/BookList.jsx';
import BookForm from './components/books/BookForm.jsx';
import AuthorList from './components/authors/AuthorList.jsx';
import AuthorForm from './components/authors/AuthorForm.jsx';

const App = () => {
  const [isAuthenticated, setIsAuthenticated] = useState(!!localStorage.getItem('token'));

  // This component will handle the logic for the main layout
  const MainLayout = () => {
    const navigate = useNavigate();

    const handleLogout = () => {
      localStorage.removeItem('token');
      setIsAuthenticated(false);
      navigate('/signin');
    };

    return (
      <div className="min-h-screen bg-slate-50">
        <nav className="bg-white shadow-sm">
          <div className="container px-4 mx-auto">
            <div className="flex items-center justify-between h-16">
              <Link to="/" className="text-2xl font-bold text-indigo-600">
                v-library
              </Link>
              <div className="hidden md:flex items-center space-x-6">
                {isAuthenticated && (
                  <>
                    <Link to="/books" className="text-gray-700 hover:text-indigo-600 transition-colors">Books</Link>
                    <Link to="/authors" className="text-gray-700 hover:text-indigo-600 transition-colors">Authors</Link>
                    <Link to="/create-book" className="text-gray-700 hover:text-indigo-600 transition-colors">Create Book</Link>
                  </>
                )}
              </div>
              <div className="flex items-center space-x-4">
                {!isAuthenticated ? (
                  <>
                    <Link to="/signin" className="px-4 py-2 text-sm font-medium text-gray-700 border border-slate-200 rounded-lg hover:bg-slate-100 transition">
                      Sign In
                    </Link>
                    <Link to="/signup" className="px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-lg shadow hover:bg-indigo-700 hover:translate-y-[1px] transition">
                      Sign Up
                    </Link>
                  </>
                ) : (
                  <button
                    onClick={handleLogout}
                    className="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg shadow hover:bg-red-700 hover:translate-y-[1px] transition"
                  >
                    Logout
                  </button>
                )}
              </div>
            </div>
          </div>
        </nav>

        <main className="p-8">
          <Routes>
            <Route path="/signin" element={<SignIn onLogin={() => setIsAuthenticated(true)} />} />
            <Route path="/signup" element={<SignUp />} />
            <Route path="/books" element={<BookList />} />
            <Route path="/create-book" element={<BookForm />} />
            <Route path="/authors" element={<AuthorList />} />
            <Route path="/authors/new" element={<AuthorForm />} />
            <Route path="/" element={<Home />} />
          </Routes>
        </main>
      </div>
    );
  };

  return (
    <Router>
      <MainLayout />
    </Router>
  );
};

const Home = () => (
  <div className="py-20 text-center bg-white rounded-xl shadow-md">
    <h1 className="text-5xl font-bold text-gray-800">Welcome to v-library</h1>
    <p className="mt-4 text-xl text-gray-600">Your digital space for managing and discovering new materials.</p>
    <div className="mt-8">
      <Link to="/books" className="px-6 py-3 font-medium text-white bg-indigo-600 rounded-lg shadow hover:bg-indigo-700 hover:translate-y-[1px] transition">
        Explore Books
      </Link>
    </div>
  </div>
);

export default App;
