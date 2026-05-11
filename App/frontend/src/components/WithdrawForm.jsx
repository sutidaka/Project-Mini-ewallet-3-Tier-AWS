import React, { useState } from 'react';
import { API_BASE_URL } from '../config';

const WithdrawForm = () => {
  const [userId, setUserId] = useState('');
  const [amount, setAmount] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    const response = await fetch(`${API_BASE_URL}/wallet/withdraw`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user_id: parseInt(userId), amount: parseFloat(amount) }),
    });
    if (response.ok) {
      setUserId('');
      setAmount('');
      alert('Withdrawal successful!');
    } else {
      alert('Failed to withdraw.');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Withdraw</h2>
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
      <button type="submit">Withdraw</button>
    </form>
  );
};

export default WithdrawForm;
