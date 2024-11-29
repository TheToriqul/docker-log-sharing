# Docker Log Sharing Reference Commands

> **Author**: [Md Toriqul Islam](https://linkedin.com/TheToriqul)  
> **Description**: Guide for sharing log files between Docker containers using bind mounts and volumes.
> **Learning Focus**: Understanding advanced Docker volume concepts and multi-container data sharing.
> **Note**: This is a reference guide. Do not execute commands directly without understanding their implications.

## Section 1: Core Workflow

### Step 1: Set Up Known Location on Host
```bash
# Create a directory on the host to store logs
LOG_SRC=~/web-logs-example
mkdir ${LOG_SRC}
```

### Step 2: Create Log-Writing Container (Bind Mount)
```bash
# Run a container that writes logs to the bind-mounted directory
docker run --name plath -d \
    --mount type=bind,src=${LOG_SRC},dst=/data \
    my_writer
```

### Step 3: Create Log-Reading Container (Bind Mount)
```bash
# Run a container that reads logs from the bind-mounted directory  
docker run --rm \
    --mount type=bind,src=${LOG_SRC},dst=/data \
    alpine:latest \
    head /data/logA
```

### Step 4: View Logs from Host
```bash
# Display the contents of the log file on the host
cat ${LOG_SRC}/logA
```

### Step 5: Stop Log-Writing Container
```bash  
# Stop and remove the log-writing container
docker rm -f plath
```

### Step 6: Create Docker Volume
```bash
# Create a named Docker volume for log sharing
docker volume create --driver local logging-example

# Verify the volume creation
docker volume ls
```

### Step 7: Create Log-Writing Container (Volume)
```bash
# Run a container that writes logs to the Docker volume
docker run --name plath -d \
    --mount type=volume,src=logging-example,dst=/data \
    my_writer
```

### Step 8: Create Log-Reading Container (Volume)  
```bash
# Run a container that reads logs from the Docker volume
docker run --rm \
    --mount type=volume,src=logging-example,dst=/data \
    alpine:latest \
    head /data/logA
```

### Step 9: View Logs from Host (Volume)
```bash
# Display the contents of the log file in the Docker volume
cat /var/lib/docker/volumes/logging-example/_data/logA
```

### Step 10: Stop Log-Writing Container (Volume)
```bash
# Stop the log-writing container  
docker stop plath
```

## Section 2: Advanced Operations

### Create Containers with Anonymous Volumes
```bash
# Create a container with anonymous volumes
docker run --name fowler \
    --mount type=volume,dst=/library/PoEAA \
    --mount type=bind,src=/tmp,dst=/library/DSL \
    alpine:latest \
    echo "Fowler collection created."
    
# Create another container with anonymous volumes  
docker run --name knuth \
    --mount type=volume,dst=/library/TAoCP.vol1 \
    --mount type=volume,dst=/library/TAoCP.vol2 \
    --mount type=volume,dst=/library/TAoCP.vol3 \
    --mount type=volume,dst=/library/TAoCP.vol4.a \
    alpine:latest \
    echo "Knuth collection created"
```

### Share Volumes with Another Container
```bash  
# Create a container that uses volumes from other containers
docker run --name reader \
    --volumes-from fowler \
    --volumes-from knuth \
    alpine:latest ls -l /library/
```

### Inspect Volumes of the New Container
```bash
# Display detailed information about the container's volumes
docker inspect --format "{{json .Mounts}}" reader | jq
```

## Section 3: Cleanup

### Remove a Specific Volume
```bash
# List all volumes
docker volume ls

# Remove a specific volume by name  
docker volume rm <volume_name>
```

### Prune Unused Volumes
```bash  
# Remove all unused volumes
docker volume prune
```

### Forcefully Remove All Volumes
```bash
# Stop and remove all containers
docker stop $(docker ps -aq)  
docker rm $(docker ps -aq)

# Remove all volumes
docker volume rm $(docker volume ls -q)
```

## Learning Notes

1. Bind mounts are simple but create host dependencies.
2. Docker volumes provide better portability and management.
3. Anonymous volumes allow flexible data sharing between containers.
4. The `--volumes-from` flag enables volume sharing without exposing host paths.
5. Regularly clean up unused volumes to optimize disk space.

---

> 💡 **Best Practice**: Use Docker volumes instead of bind mounts for production deployments.

> ⚠️ **Warning**: Be cautious when forcefully removing all volumes, as it can lead to data loss.

> 📝 **Note**: Use meaningful names for volumes to facilitate management and organization.