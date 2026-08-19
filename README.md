# IstroSec

- IstroSec is a Docker and Ansible deployment project for a minimal HTTPS web application.
- The project provides containerized application delivery through GitHub Actions, GitHub Container Registry and Ansible.

## Application

- The application is a minimal HTTPS web service packaged as a Docker image.
- It includes
    - Multi stage Docker build
    - Development and production targets
    - Docker Compose configurations
    - Automatic TLS certificate bootstrap
    - Application health endpoint
    - Application versioning

## CI

- GitHub Actions provide

    - Code quality checks
    - Docker image build
    - Docker image publishing to GHCR
    - Docker image security scanning

- The application image is published as:
    - ghcr.io/metjumetju/istrosec:main

## Ansible

- Ansible provides automated Docker installation and application deployment.

- The project contains

- DEV and PROD inventories
- Logical host groups
- group_vars and host_vars
- Separate Ansible Vault files
- Separate DEV and PROD Vault IDs
- Docker installation playbook
- Application deployment playbook
- Application update playbook
- Reusable Docker application role

## Environments

- DEV
    - dev-app01
    - dev-app02

- PROD
    - prod-app01
    - prod-app02

- DEV and PROD use separate inventories and encrypted Vault files.

## Application Ports

- All application containers listen on internal port 5000.
- Each host exposes the application on a unique host port.

    - dev-app01   Host 5002   Container 5000
    - dev-app02   Host 5003   Container 5000
    - prod-app01  Host 5004   Container 5000
    - prod-app02  Host 5005   Container 5000

- This allows all application instances to run simultaneously on the same Docker host.

## Security

- Sensitive registry credentials are stored using Ansible Vault.
-  DEV and PROD use separate Vault IDs.

- DEV
    - dev@prompt
- PROD
    - prod@prompt

- Registry credentials are protected from Ansible output using no_log.
- TLS certificates are generated during deployment and are not stored in the repository.
- The application uses HTTPS with a self signed certificate in the lab environment.

## Deployment

- The docker_app Ansible role is responsible for application deployment.
- It creates:
    - the application directory
    - authenticates against GHCR
    - deploys the Docker Compose configuration
    - pulls the application image and manages the application lifecycle

## Repository Structure

    IstroSec

    app
    tests
    .github
    workflows

    Dockerfile
    docker-compose.dev.yml
    docker-compose.prod.yml
    VERSION
    README.md

    Ansible
    inventories
        dev
        prod
    roles
        docker_app
    playbooks
        install-docker.yml
        deploy.yml
        update.yml

