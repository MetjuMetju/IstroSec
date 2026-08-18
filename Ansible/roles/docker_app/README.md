# docker_app

Ansible role for deploying the IstroSec application using Docker Compose.

## Description

This role deploys the IstroSec containerized application on a Docker host.

The role:

1. Creates the application directory.
2. Generates a Docker Compose configuration from a Jinja2 template.
3. Pulls the configured Docker image.
4. Starts the application using Docker Compose.
5. Recreates the application when the deployment configuration changes.

## Requirements

- Ansible >= 2.14
- Docker
- Docker Compose v2
- `community.docker` Ansible collection

The Docker installation can be handled separately using the
`geerlingguy.docker` Ansible Galaxy role.

## Role Variables

| Variable | Description | Default |
|---|---|---|
| `app_name` | Application name | `istrosec` |
| `app_environment` | Application environment | `development` |
| `app_image` | Docker image used by the application | `ghcr.io/metjumetju/istrosec:main` |
| `app_container_name` | Docker container name | `{{ app_name }}` |
| `app_container_port` | Port exposed by the application inside the container | `5000` |
| `app_host_port` | Port exposed on the Docker host | `{{ app_container_port }}` |
| `app_project_dir` | Docker Compose project directory | `/opt/{{ app_name }}` |
| `app_restart_policy` | Docker container restart policy | `unless-stopped` |

## Example

```yaml
- name: Deploy IstroSec application
  hosts: app_servers
  become: true

  roles:
    - role: docker_app
