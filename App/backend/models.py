from sqlalchemy import Column, Integer, String, Float
from sqlalchemy.ext.declarative import declarative_base
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)

class Wallet(Base):
    __tablename__ = "wallets"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer)
    balance = Column(Float, default=0.0)