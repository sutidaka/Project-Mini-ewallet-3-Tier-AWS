import React, { useEffect, useState } from 'react';

const UserList = () => {
  const [users, setUsers] = useState([]);

  const fetchUsers = async () => {
    const response = await fetch(`${import.meta.env.VITE_API_URL}/users`);
    const data = await response.json();
    setUsers(data);
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  return (
    <div>
      <h2>User List</h2>
      <ul>
        {users.map((user) => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
    </div>
  );
};

export default UserList;