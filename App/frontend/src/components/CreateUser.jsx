import React, { useState } from 'react';

const CreateUser = () => {
  const [name, setName] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    const response = await fetch(`${import.meta.env.VITE_API_URL}/users`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name }),
    });
    if (response.ok) {
      setName('');
      alert('User created successfully!');
    } else {
      alert('Failed to create user.');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Create User</h2>
      <input
        type="text"
        placeholder="Enter name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        required
      />
      <button type="submit">Create User</button>
    </form>
  );
};

export default CreateUser;