import jwt
from fastapi import HTTPException, Header
from config import settings

def get_admin_id_from_token(authorization: str = Header(...)) -> str:
    try:
        token = authorization.split(" ")[1]
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        if payload.get("role") != "admin":
            raise HTTPException(status_code=403, detail="Not an admin")
        return payload.get("sub")
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")
