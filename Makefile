# Define variables
DOCKER_COMPOSE_FILE=srcs/docker-compose.yaml

# Default target: Build and start containers
up:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

# Stop containers and remove them
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down

# Restart containers
restart: down up

# View logs
logs:
	docker compose -f $(DOCKER_COMPOSE_FILE) logs -f

# Cleanup unused Docker resources
cleanup:
	docker system prune -f

.PHONY: up down restart logs cleanup

