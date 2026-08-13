FROM python:3.12-slim AS base
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /app

FROM base AS dependencies
COPY requirements.txt .
RUN python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

FROM base AS development
COPY requirements.txt .
COPY requirements-dev.txt .
RUN python -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir -r requirements-dev.txt
ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONPATH="/app"
COPY app ./app
COPY tests ./tests
COPY VERSION .
EXPOSE 5000
CMD ["flask", "--app", "app.main:app", "run", "--host=0.0.0.0", "--port=5000", "--cert=/certs/server.crt", "--key=/certs/server.key"]

FROM base AS production
COPY --from=dependencies /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONPATH="/app"
RUN useradd --create-home --uid 10001 --shell /bin/bash appuser
COPY app ./app
COPY VERSION .
RUN chown -R appuser:appuser /app
USER appuser
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--certfile=/certs/server.crt", "--keyfile=/certs/server.key", "app.main:app"]
