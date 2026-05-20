FROM python:3.11.6-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /build

COPY . .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11.6-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_PORT=8000

# non-root user for security
RUN groupadd --system appuser && useradd --system --no-log-init --gid appuser appuser

COPY --from=builder /install /usr/local

WORKDIR /app
COPY app/ app/
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
