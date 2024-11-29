# Docker Log Sharing Reference Commands

- [Section 1: Prerequisites](#section-1-prerequisites)
- [Section 2: Core Workflow](#section-2-core-workflow)
- [Section 3: Advanced Operations](#section-3-advanced-operations)
- [Section 4: Volume Management](#section-4-volume-management)
- [Section 5: Cleanup](#section-5-cleanup)

> **Author**: [Md Toriqul Islam](https://linkedin.com/TheToriqul)  
> **Description**: Reference commands for sharing log files between Docker containers using bind mounts and volumes.  
> **Learning Focus**: Advanced Docker volume concepts, multi-container data sharing, and volume management.  
> **Note**: This is a reference guide. Exercise caution and understand the implications before executing any commands.

## Section 1: Prerequisites

- Docker 20.10.17 or higher
- Alpine Linux 3.16 or compatible

## Section 2: Core Workflow

### Step 1: Build Custom Image

```bash
# Build the custom Docker image
docker build -t my_writer .
```

### Step 2: Set Up Known Location on Host

```bash
# Create a directory on the host to store logs
LOG_SRC=~/web-logs-example
mkdir -p ${LOG_SRC}
```

### Step 3: Create Log-Writing Container (Bind Mount)

```bash
# Run a container that writes logs to the bind-mounted directory
docker run --name plath -d \
    --mount type=bind,src=${LOG_SRC},dst=/data \
    my_writer

# Verify the container is running
docker ps -f name=plath
```

### Step 4: Create Log-Reading Container (Bind Mount)

```bash
# Run a container that reads logs from the bind-mounted directory
docker run --rm \
    --mount type=bind,src=${LOG_SRC},dst=/data \
    alpine:latest \
    head /data/logA
```

### Step 5: View Logs from Host (Bind Mount)

```bash
# Display the contents of the log file on the host
cat ${LOG_SRC}/logA
```

### Step 6: Stop Log-Writing Container (Bind Mount)

```bash
# Stop and remove the log-writing container
docker rm -f plath
```

### Step 7: Create Docker Volume

```bash
# Create a named Docker volume for log sharing
docker volume create --driver local logging-example

# Verify the volume creation
docker volume ls
```

### Step 8: Create Log-Writing Container (Volume)

```bash
# Run a container that writes logs to the Docker volume
docker run --name plath -d \
    --mount type=volume,src=logging-example,dst=/data \
    my_writer

# Verify the container is running
docker ps -f name=plath
```

### Step 9: Create Log-Reading Container (Volume)

```bash
# Run a container that reads logs from the Docker volume
docker run --rm \
    --mount type=volume,src=logging-example,dst=/data \
    alpine:latest \
    head /data/logA
```

### Step 10: View Logs from Host (Volume)

```bash
# Display the contents of the log file in the Docker volume
docker exec plath cat /data/logA
```

### Step 11: Stop Log-Writing Container (Volume)

```bash
# Stop the log-writing container
docker stop plath
```

## Section 3: Advanced Operations

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
    echo "Knuth collection created."
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
docker inspect --format '{{json .Mounts}}' reader | jq
```

## Section 4: Volume Management

### List Volumes

```bash
# List all volumes
docker volume ls
```

### Remove a Specific Volume

```bash
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
# Remove all volumes forcefully
docker volume rm $(docker volume ls -q)
```

## Section 5: Cleanup

### Stop and Remove All Containers

```bash
# Stop and remove all containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
```

### Remove All Volumes

```bash
# Remove all volumes
docker volume rm $(docker volume ls -q)
```

---

> 💡 **Best Practice**: Use meaningful names for containers and volumes to facilitate management and organization.

> ⚠️ **Warning**: Be cautious when forcefully removing all volumes, as it can lead to data loss.

> 📝 **Note**: Always verify the contents of a volume before removing it to avoid unintended data loss.