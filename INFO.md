# CapRover Complete Teardown & Fresh Setup Guide

## Complete Teardown (Nuclear Option)

### 1. Stop CapRover Services

```bash
# Stop all CapRover-related services
sudo docker service rm captain-captain captain-nginx captain-certbot 2>/dev/null
sudo docker stop caprover-main caprover 2>/dev/null
sudo docker rm caprover-main caprover 2>/dev/null
```

### 2. Leave Docker Swarm & Clean Networks

```bash
# Leave swarm and clean networks
sudo docker swarm leave --force 2>/dev/null
sudo docker network rm captain-overlay-network 2>/dev/null
sudo docker network prune -f
```

### 3. Clean Volumes & Data

```bash
# Remove CapRover data and clean volumes
sudo rm -rf /captain
sudo docker volume prune -f
```

### 4. Full Docker Reset (Optional - Nuclear)

```bash
# Only if you need complete Docker reset
sudo systemctl stop docker.socket
sudo systemctl stop docker.service
sudo rm -rf /var/lib/docker/swarm
sudo systemctl start docker.service
```

### 5. Verify Clean State

```bash
# Check swarm status (should show "inactive")
sudo docker info | grep Swarm
```

## Fresh Setup Options

### Option A: Simple Setup (Recommended)

```bash
# Basic CapRover setup with auto-restart (ONE LINE)
docker run -d --restart unless-stopped --name caprover-main -p 80:80 -p 443:443 -p 3000:3000 -e ACCEPTED_TERMS=true -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover:latest
```

### Option B: Advanced Setup with Custom Domain

```bash
# Setup with specific IP and domain - replace IP and domain values (ONE LINE)
docker run -d --restart unless-stopped --name caprover --cap-add=NET_ADMIN -e MAIN_NODE_IP_ADDRESS=64.227.144.188 -e CAPROVER_ROOT_DOMAIN=caprover_lara.lotusbookerp.work -e ACCEPTED_TERMS=true -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain -p 80:80 -p 443:443 -p 3000:3000 caprover/caprover:latest
```

## Firewall Configuration

```bash
# Configure UFW firewall (ONE LINE)
sudo ufw allow 80/tcp && sudo ufw allow 443/tcp && sudo ufw allow 3000/tcp && sudo ufw --force enable
```

## Post-Setup Verification

```bash
# Check CapRover is running
docker ps | grep caprover

# Check logs if needed
docker logs caprover-main
# or
docker logs caprover

# Verify ports are listening
sudo netstat -tlnp | grep -E ':(80|443|3000)'
```

## One-Liner Commands

### Complete Teardown (One Line)

```bash
sudo docker service rm captain-captain captain-nginx captain-certbot 2>/dev/null; sudo docker stop caprover-main caprover 2>/dev/null; sudo docker rm caprover-main caprover 2>/dev/null; sudo docker swarm leave --force 2>/dev/null; sudo docker network rm captain-overlay-network 2>/dev/null; sudo docker network prune -f; sudo rm -rf /captain; sudo docker volume prune -f
```

### Quick Setup (One Line)

```bash
docker run -d --restart unless-stopped --name caprover-main -p 80:80 -p 443:443 -p 3000:3000 -e ACCEPTED_TERMS=true -v /var/run/docker.sock:/var/run/docker.sock -v /captain:/captain caprover/caprover:latest
```

## Troubleshooting

### Common Issues

- **Port conflicts**: Make sure no other services are using ports 80, 443, or 3000
- **Permission issues**: Ensure user is in docker group: `sudo usermod -aG docker $USER`
- **Swarm conflicts**: Always leave swarm before fresh setup
- **Volume issues**: Clean `/captain` directory if setup fails

### Access CapRover

- Default access: `http://YOUR_SERVER_IP:3000`
- Default password: `captain42`

## Notes

- Always use `2>/dev/null` to suppress error messages for non-existent services
- The `--restart unless-stopped` ensures CapRover starts automatically after reboot
- Remove `/captain` directory to ensure clean configuration
- Firewall configuration is essential for proper operation
