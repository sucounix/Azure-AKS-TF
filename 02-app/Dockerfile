FROM python:3.10.0-slim-bullseye AS app

WORKDIR /app

RUN pip install --upgrade pip && \
    pip install --no-cache-dir uvicorn

RUN apt-get update && \
    apt-get install python3-dev \
                    libpq-dev \
                    gcc \
                    gnupg \
                    postgresql-client \
                    curl \
                    wget \
                    apt-transport-https -y && \
    rm -rf /var/lib/apt/lists/*


COPY /app .

RUN pip install -r requirements.txt



ENV PYTHONPATH=/app
ENV WORKERS=1

RUN adduser --shell /bin/sh appuser && \
  chown -R appuser:appuser .

#USER appuser
EXPOSE 80

CMD ["sh", "-c", "uvicorn --host=0.0.0.0 --port=80 main:app"]
