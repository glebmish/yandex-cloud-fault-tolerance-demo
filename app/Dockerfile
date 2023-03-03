FROM python:3.7-slim-buster

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y gcc libpq-dev
RUN pip install --no-cache-dir flask flask_sqlalchemy psycopg2

COPY . .

ARG COLOR_SCHEME=light
ENV COLOR_SCHEME "$COLOR_SCHEME"
CMD ["python", "./app.py"]
