# IstroSec

IstroSec is a containerized Flask web application demonstrating a complete
Docker CI/CD workflow with GitHub Actions, GitHub Container Registry,
security scanning, versioning, and Ansible deployment.

## Features

- Flask web application
- Multi-stage Docker build
- Docker Compose
- HTTPS with automatically generated self-signed certificates
- GitHub Actions CI/CD
- GitHub Container Registry
- Trivy container security scanning
- Automated deployment with Ansible
- Separate development and production environments
- Nix and direnv development environment

## Application

The application provides:
    GET /
    GET /health

The application runs on port 5000 inside the container.

## Requirements

    Git
    Docker
    Docker Compose
    Python 3.12
    OpenSSL
    Ansible
    Nix
    direnv

## Local Development

Start the development environment:
    docker compose -f docker-compose.dev.yml up --build

Test the application:
    curl -k https://localhost:5000/

Health check:
    curl -k https://localhost:5000/health

Stop the environment:
    docker compose -f docker-compose.dev.yml down

## Docker

Build the development image:
    docker build --target development -t istrosec:dev .

Build the production image:
    docker build --target production -t istrosec:latest .

Run the production image:
    docker run --rm -p 5000:5000 istrosec:latest

## Versioning

The application version is stored in:
    VERSION

Create a new release:
    git tag v1.1.0
    git push origin v1.1.0

## Testing

Install development dependencies:
    python -m pip install -r requirements-dev.txt

Run tests:
    pytest

Check formatting:
    ruff format --check .

Run the linter:
    ruff check .

## CI/CD

GitHub Actions are used for automated quality checks, Docker image builds, security scanning, and publishing.

Quality checks include:
    Ruff formatting
    Ruff linting
    Pytest

The Docker workflow builds the production image and publishes it to GitHub Container Registry:
    ghcr.io/metjumetju/istrosec

The security workflow scans the container image with Trivy and fails when critical vulnerabilities are detected.

## Ansible Deployment

The Ansible configuration is located in:
    Ansible/

Development inventory:
    inventories/dev/hosts.yml

Production inventory:
    inventories/prod/hosts.yml

The deployment uses separate development and production inventories and Vault secrets.

Run a development deployment:

    ansible-playbook \
      -i inventories/dev/hosts.yml \
      playbooks/deploy.yml \
      --ask-pass \
      --ask-become-pass \
      --vault-id dev@prompt

Run a production deployment:

    ansible-playbook \
      -i inventories/prod/hosts.yml \
      playbooks/deploy.yml \
      --ask-pass \
      --ask-become-pass \
      --vault-id prod@prompt

The deployment:

    Logs in to GitHub Container Registry
    Pulls the latest container image
    Deploys the Docker Compose configuration
    Starts or updates the application

Development and production applications use separate container names,
project directories, and host ports so they can run simultaneously.

## TLS Certificates

TLS certificates are generated automatically by the Docker Compose bootstrap service.
The generated certificate and private key are stored in a Docker named volume.
Certificates are not stored in the Git repository.
The certificates are self-signed and are intended for development and lab use.

## Nix and direnv

The repository contains a Nix development environment.

Start the environment:
    nix develop

If direnv is installed:
    direnv allow

## Repository Structure

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

    Ansible/
        inventories/
            dev/
            prod/
        playbooks/
        roles/
            docker_app/
