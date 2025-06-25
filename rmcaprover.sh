#!/bin/bash

echo "Stopping and removing CapRover..."

# Remove CapRover services if they exist
echo "Removing Docker services..."
sudo docker service rm captain-captain captain-nginx captain-certbot 2>/dev/null

# Remove CapRover overlay network if exists
echo "Removing Docker network..."
sudo docker network rm captain-overlay-network 2>/dev/null

# Leave Docker Swarm (forcefully)
echo "Leaving Docker swarm..."
sudo docker swarm leave --force 2>/dev/null

# Clean up unused networks and volumes
echo "Pruning unused Docker networks and volumes..."
sudo docker network prune -f
sudo docker volume prune -f

# Remove CapRover persistent directory
echo "Deleting /captain directory..."
sudo rm -rf /captain

# Stop Docker services
echo "Stopping Docker services..."
sudo systemctl stop docker.socket
sudo systemctl stop docker.service

echo "CapRover removal complete."
