# services/api/Dockerfile
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1     PIP_NO_CACHE_DIR=1

WORKDIR /app

# System deps for psycopg2
#RUN apt-get update && apt-get install -y --no-install-recommends     build-essential libpq-dev && rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008  # Pinning apt packages across slim variants is brittle; using immutable base image + cleanup.
RUN apt-get update \
 && apt-get install -y --no-install-recommends gcc libpq-dev \
 && rm -rf /var/lib/apt/lists/*


COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY app.py ./

EXPOSE 8000
CMD ["gunicorn", "-w", "1", "--threads", "8", "-b", "0.0.0.0:8000", "--timeout", "120", "app:app"]