#!/bin/bash

# Function to confirm user wants to proceed
confirm() {
    read -p "Are you sure you want to reset your Docker environment? This will delete all containers, images, volumes, and networks. (y/N): " confirmation
    case "$confirmation" in
        [yY]|[yY][eE][sS])
            return 0
            ;;
        *)
            echo "Aborting."
            exit 1
            ;;
    esac
}

# Confirm action
confirm

confirm() {
    read -p "Are you sure you SURE? (y/N): " confirmation
    case "$confirmation" in
        [yY]|[yY][eE][sS])
            return 0
            ;;
        *)
            echo "Aborting."
            exit 1
            ;;
    esac
}

# Confirm action
confirm


# Step 1: Stop all running containers
echo "Stopping all running containers..."
docker stop $(docker ps -q) 2>/dev/null || echo "No running containers to stop."

# Step 2: Remove all containers
echo "Removing all containers..."
docker rm $(docker ps -aq) 2>/dev/null || echo "No containers to remove."

# Step 3: Remove all images
echo "Removing all images..."
docker rmi $(docker images -q) --force 2>/dev/null || echo "No images to remove."

# Step 4: Remove all volumes
echo "Removing all volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null || echo "No volumes to remove."
echo "Removing dangling volumes..."
docker volume prune -f 2>/dev/null

# Step 5: Remove all networks
echo "Removing all networks..."
docker network rm $(docker network ls -q) 2>/dev/null || echo "No user-defined networks to remove."
echo "Removing dangling networks..."
docker network prune -f 2>/dev/null

# Step 6: Clear Docker system
echo "Clearing Docker system..."
docker system prune -a --volumes -f

# Step 7: Reset Docker's data directory (optional)
echo "Stopping Docker service..."
sudo systemctl stop docker

echo "Deleting Docker data directory..."
sudo rm -rf /var/lib/docker

echo "Restarting Docker service..."
sudo systemctl start docker

# Final check
echo "Docker environment has been reset. Verifying..."
docker ps -a
docker images
docker volume ls
docker network ls

echo "Reset complete!"