FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# System dependencies
RUN apt-get update && apt-get install -y \
    curl nano \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"

COPY / /app

WORKDIR /app

# Install dependencies
RUN uv sync --no-dev

# RUN cp .env.example .env

# Runtime configuration
ENV HOST=0.0.0.0
ENV PORT=8000
ENV OPENWEBUI_BASE_URL=http://localhost:3000
ENV OPENWEBUI_API_KEY=sk-
ENV OPENWEBUI_TIMEOUT=30
ENV OPENWEBUI_MAX_RETRIES=3
ENV OPENWEBUI_RATE_LIMIT=10
ENV LOG_LEVEL=INFO
ENV LOG_FORMAT=json

EXPOSE 8000

CMD ["uv", "run", "python", "-m", "src.server"]