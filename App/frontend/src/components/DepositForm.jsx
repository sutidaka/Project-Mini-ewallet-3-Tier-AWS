import React, { useState } from 'react';
import { API_BASE_URL } from '../config';

const DepositForm = () => {
  const [userId, setUserId] = useState('');
  const [amount, setAmount] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    const response = await fetch(`${API_BASE_URL}/wallet/deposit`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user_id: parseInt(userId), amount: parseFloat(amount) }),
    });
    if (response.ok) {
      setUserId('');
      setAmount('');
      alert('Deposit successful!');
    } else {
      alert('Failed to deposit.');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Deposit</h2>
      <input
        type="number"
        placeholder="User ID"
        value={userId}
        onChange={(e) => setUserId(e.target.value)}
        required
      />
      <input
        type="number"
        placeholder="Amount"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        required
      />
      <button type="submit">Deposit</button>
    </form>
  );
};

export default DepositForm;
