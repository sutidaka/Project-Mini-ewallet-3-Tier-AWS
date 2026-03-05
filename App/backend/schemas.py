from pydantic import BaseModel

class UserCreate(BaseModel):
    name: str

class UserResponse(BaseModel):
    id: int
    name: str

    class Config:
        orm_mode = True

class DepositWithdraw(BaseModel):
    user_id: int
    amount: float