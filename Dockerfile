FROM python:3.7-alpine

WORKDIR /app

RUN apk add --no-cache gcc musl-dev linux-headers

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

#EXPOSE 5000 on va gérer le port dans le pod ?

CMD ["python", "main.py"]