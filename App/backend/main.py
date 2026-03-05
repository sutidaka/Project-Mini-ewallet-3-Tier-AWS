from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from wallet import router as wallet_router

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(wallet_router)

@app.get("/health")
async def health_check():
    return {"status": "healthy"}