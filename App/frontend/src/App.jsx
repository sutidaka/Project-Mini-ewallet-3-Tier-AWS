import React from 'react';
import CreateUser from './components/CreateUser';
import UserList from './components/UserList';
import DepositForm from './components/DepositForm';
import WithdrawForm from './components/WithdrawForm';

const App = () => {
  return (
    <div style={{ padding: '20px' }}>
      <h1>Mini E-Wallet</h1>
      <CreateUser />
      <UserList />
      <DepositForm />
      <WithdrawForm />
    </div>
  );
}

export default App;