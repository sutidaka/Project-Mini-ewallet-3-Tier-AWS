CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE INDEX IF NOT EXISTS ix_users_id ON users (id);
CREATE INDEX IF NOT EXISTS ix_users_name ON users (name);

CREATE TABLE IF NOT EXISTS wallets (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    balance DOUBLE PRECISION DEFAULT 0.0
);

CREATE INDEX IF NOT EXISTS ix_wallets_id ON wallets (id);
CREATE INDEX IF NOT EXISTS ix_wallets_user_id ON wallets (user_id);
