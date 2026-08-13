# Docker CI Demo

A minimal HTTPS web application demonstrating Docker multi-stage builds,
Docker Compose, CI, Docker image security scanning, application versioning,
and a reproducible development environment using Nix and direnv.

## Requirements

The following tools are recommended:

- Git
- Docker
- Docker Compose
- Python 3.12
- OpenSSL
- Nix
- direnv

## Application

The application is a minimal Flask web service.
The application exposes:

- `/`
- `/health`

The application supports HTTPS.

The development and production Docker Compose configurations automatically
create a self-signed TLS certificate using a bootstrap container.

## Versioning

The current application version is stored in the `VERSION` file.
The initial version is:
    1.0.0

Create a new version using a Git tag:
    git tag v1.1.0
    git push origin v1.1.0

## Development with Docker Compose

Build and start the development environment:
    docker compose -f docker-compose.dev.yml up --build

The application is available at:
    https://localhost:5000

Because the certificate is self-signed, a browser will display a certificate
warning.

The certificate can be tested with curl:
    curl -k https://localhost:5000

The health endpoint can be tested with:
    curl -k https://localhost:5000/health

Stop the development environment:
    docker compose -f docker-compose.dev.yml down

## Production with Docker Compose

Build and start the production environment:
    docker compose -f docker-compose.prod.yml up --build

The application is available at:
    https://localhost:5000

Test the application:
    curl -k https://localhost:5000

Stop the production environment:
    docker compose -f docker-compose.prod.yml down

## Docker builds

Build the development image:
    docker build --target development -t docker-ci-demo:dev .

Build the production image:
    docker build --target production -t docker-ci-demo:latest .

Run the production image:
    docker run --rm \
      -p 5000:5000 \
      -v docker-ci-demo_certs:/certs:ro \
      docker-ci-demo:latest

## Code quality

Install development dependencies:
    python -m pip install -r requirements-dev.txt

Run the tests:
    pytest

Check formatting:
    ruff format --check .

Run the linter:
    ruff check .

The GitHub Actions quality workflow automatically performs all three checks.

## CI

The repository contains three GitHub Actions workflows.

### Quality

The quality workflow:

1. Installs Python dependencies.
2. Checks code formatting.
3. Runs Ruff.
4. Runs pytest.

### Docker

The Docker workflow:
1. Builds the production Docker image.
2. Creates Docker image metadata.
3. Pushes the image to GitHub Container Registry.

### Security

The security workflow:
1. Builds the production Docker image.
2. Runs Trivy against the image.
3. Checks for critical vulnerabilities.
4. Fails when critical vulnerabilities are found.

## Local security scanning

If Docker Scout is available, the image can be inspected with:
    docker scout quickview docker-ci-demo:latest

Scan the image for vulnerabilities:
    docker scout cves docker-ci-demo:latest

## Nix and direnv

The repository contains a `flake.nix` defining the development environment.
Enter the Nix development environment:
    nix develop

If direnv is installed, allow the repository environment:
    direnv allow

The development environment provides tools including:
- Python
- uv
- Docker
- Docker Compose
- Git
- OpenSSL
- direnv

## TLS certificates

The Compose bootstrap service generates a self-signed certificate.
The generated files are:

    server.crt
    server.key

They are stored in a Docker named volume.
The certificates are not committed to Git.

The production application uses the generated certificate and private key
directly with Gunicorn.

## Repository structure

    .
    Dockerfile
    docker-compose.dev.yml
    docker-compose.prod.yml
    requirements.txt
    requirements-dev.txt
    VERSION
    README.md
    flake.nix
    .envrc
    .gitignore

    app/
        __init__.py
        main.py

    tests/
        test_main.py

    .github/
        workflows/
            quality.yml
            docker.yml
            security.yml
