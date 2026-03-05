from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from models import User, Wallet
from schemas import UserCreate, DepositWithdraw
from database import get_db

router = APIRouter()


@router.post("/users")
async def create_user(user: UserCreate, db: AsyncSession = Depends(get_db)):
    new_user = User(name=user.name)

    db.add(new_user)
    await db.commit()
    await db.refresh(new_user)

    return new_user


@router.get("/users")
async def get_users(db: AsyncSession = Depends(get_db)):

    result = await db.execute(select(User))

    return result.scalars().all()


@router.post("/wallet/deposit")
async def deposit(data: DepositWithdraw, db: AsyncSession = Depends(get_db)):

    result = await db.execute(
        select(Wallet).where(Wallet.user_id == data.user_id)
    )

    wallet = result.scalar_one_or_none()

    if not wallet:
        wallet = Wallet(user_id=data.user_id, balance=0)
        db.add(wallet)

    wallet.balance += data.amount

    await db.commit()

    return {"balance": wallet.balance}


@router.post("/wallet/withdraw")
async def withdraw(data: DepositWithdraw, db: AsyncSession = Depends(get_db)):

    result = await db.execute(
        select(Wallet).where(Wallet.user_id == data.user_id)
    )

    wallet = result.scalar_one_or_none()

    if not wallet:
        raise HTTPException(status_code=404, detail="Wallet not found")

    if wallet.balance < data.amount:
        raise HTTPException(status_code=400, detail="Insufficient funds")

    wallet.balance -= data.amount

    await db.commit()

    return {"new_balance": wallet.balance}