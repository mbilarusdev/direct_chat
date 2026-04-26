FROM python:3.11-slim
WORKDIR /app
RUN apt-get update && apt-get install -y gcc libpq-dev && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
# Генерируем протобафы внутри контейнера (если не копируешь готовые)
RUN python -m grpc_tools.protoc -I../proto --python_out=./proto --grpc_python_out=./proto ../proto/chat.proto
CMD ["python", "main.py"]