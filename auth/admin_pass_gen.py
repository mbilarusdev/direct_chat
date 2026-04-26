import getpass
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def main():
    password = getpass.getpass("Введите пароль админа: ")
    
    if not password:
        print("Ошибка: пароль не может быть пустым.")
        return

    hashed_password = pwd_context.hash(password)
    
    print("\nСкопируйте этот хеш и вставьте в колонку password_hash:")
    print(hashed_password)

if __name__ == "__main__":
    main()
