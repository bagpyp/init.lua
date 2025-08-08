# 🐳 Services & Docker Workflow

**[← Previous: Multi-cursor Workflow](multicursor.md)** | **[Next: Code Structure →](structure.md)**

---

## Overview

The Services panel (`⌘6`) provides Docker container management similar to JetBrains' Services tab. Monitor, control, and debug containers without leaving Neovim.

## 🚀 Quick Start

### Open Services Panel
Press `⌘6` to toggle the Docker services panel.

### Panel Layout
```
╭─ Docker Services ──────────────────────╮
│ NAMES          STATUS         PORTS    │
│ ──────────────────────────────────────│
│ web-app        Up 2 hours     3000:3000│
│ postgres-db    Up 2 hours     5432:5432│
│ redis-cache    Up 1 hour      6379:6379│
│ nginx-proxy    Exited (1)     -        │
│                                        │
│ Commands:                              │
│   r - Refresh                          │
│   s - Start/Stop container             │
│   l - View logs                        │
│   q - Close                            │
╰────────────────────────────────────────╯
```

## 🎮 Container Management

### Basic Operations

| Key | Action | Description |
|-----|--------|-------------|
| `⌘6` | Toggle Panel | Show/hide services |
| `r` | Refresh | Update container list |
| `s` | Start/Stop | Toggle container state |
| `l` | Logs | View container logs |
| `d` | Delete | Remove container |
| `i` | Inspect | Show container details |
| `q` | Close | Close panel |

### Container States

| Icon | State | Meaning |
|------|-------|---------|
| 🟢 | Up | Container running |
| 🔴 | Exited | Container stopped |
| 🟡 | Restarting | Container restarting |
| ⚪ | Created | Container created but not started |
| 🟣 | Paused | Container paused |

## 📦 Docker Compose Integration

### Compose Commands

```vim
" Start all services
:DockerComposeUp

" Stop all services
:DockerComposeDown

" Restart services
:DockerComposeRestart

" View compose logs
:DockerComposeLogs
```

### Project Structure
```
project/
├── docker-compose.yml
├── .env
├── services/
│   ├── web/
│   │   └── Dockerfile
│   ├── api/
│   │   └── Dockerfile
│   └── db/
│       └── init.sql
```

## 🔍 Container Inspection

### View Container Details
With cursor on container, press `i`:

```yaml
Container: web-app
ID: a1b2c3d4e5f6
Image: node:16-alpine
Status: Up 2 hours
Ports:
  - 3000:3000
  - 9229:9229 (debug)
Environment:
  NODE_ENV: development
  PORT: 3000
Volumes:
  - ./src:/app/src
  - node_modules:/app/node_modules
Networks:
  - app-network
```

### Container Logs

Press `l` on container to view logs:

```
web-app logs:
─────────────
[2024-01-10 10:00:00] Server starting...
[2024-01-10 10:00:01] Connected to database
[2024-01-10 10:00:02] Server running on port 3000
[2024-01-10 10:00:15] GET /api/users 200 45ms
[2024-01-10 10:00:20] POST /api/login 201 120ms
```

### Log Filtering
```vim
" Filter logs by pattern
:DockerLogs web-app --grep ERROR

" Follow logs
:DockerLogs web-app -f

" Last N lines
:DockerLogs web-app --tail 100
```

## 🐛 Debugging Containers

### Attach to Container

```vim
" Open shell in container
:DockerExec web-app /bin/sh

" Run command in container
:DockerExec web-app npm test

" Attach to running process
:DockerAttach web-app
```

### Debug Node.js in Container

1. Expose debug port in docker-compose.yml:
```yaml
services:
  web:
    ports:
      - "3000:3000"
      - "9229:9229"  # Debug port
    command: node --inspect=0.0.0.0:9229 server.js
```

2. Configure DAP debugger:
```lua
{
  type = "pwa-node",
  request = "attach",
  name = "Docker: Attach",
  address = "localhost",
  port = 9229,
  localRoot = "${workspaceFolder}",
  remoteRoot = "/app",
}
```

3. Start debugging with `F5`

## 🔧 Database Management

### Connect to Database Container

Press `⌘5` for database UI, then:

```vim
" Add connection to container
:DBUIAddConnection

" Connection string for PostgreSQL container
postgresql://user:password@localhost:5432/dbname

" For MySQL container
mysql://user:password@localhost:3306/dbname
```

### Database Operations
```sql
-- Run queries directly
SELECT * FROM users;

-- Export data
\copy users TO '/tmp/users.csv' CSV HEADER;

-- Import data
\copy users FROM '/tmp/users.csv' CSV HEADER;
```

## 📊 Container Monitoring

### Resource Usage

```vim
" Show container stats
:DockerStats

" Output:
CONTAINER    CPU %    MEM USAGE    NET I/O
web-app      0.5%     128MB/512MB  1.2kB/3.4kB
postgres-db  2.1%     256MB/1GB    5.6kB/2.1kB
redis-cache  0.1%     32MB/256MB   500B/1.2kB
```

### Health Checks

```yaml
# docker-compose.yml
services:
  web:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

View health status in services panel:
```
web-app    Up 2 hours (healthy)    3000:3000
api-app    Up 1 hour (unhealthy)   8080:8080
```

## 🚀 Development Workflow

### Hot Reload Setup

```yaml
# docker-compose.yml
services:
  web:
    volumes:
      - ./src:/app/src  # Mount source code
      - /app/node_modules  # Exclude node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true  # For file watching
    command: npm run dev  # Development command
```

### Workflow Steps
1. `⌘6` - Open services panel
2. `s` - Start containers
3. `l` - Monitor logs
4. Make code changes (auto-reload)
5. `⌘4` - Debug if needed
6. `s` - Stop when done

## 🔄 Container Orchestration

### Multi-Service Commands

```vim
" Start specific services
:DockerComposeUp web db

" Scale service
:DockerComposeScale web=3

" Rolling restart
:DockerComposeRestart --rolling
```

### Service Dependencies

```yaml
services:
  web:
    depends_on:
      - db
      - redis
    restart: unless-stopped
    
  db:
    restart: always
    
  redis:
    restart: on-failure
```

## 📦 Volume Management

### Volume Operations

```vim
" List volumes
:DockerVolumes

" Inspect volume
:DockerVolumeInspect app_data

" Clean unused volumes
:DockerVolumePrune
```

### Persistent Data
```yaml
volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local
    
services:
  db:
    volumes:
      - postgres_data:/var/lib/postgresql/data
```

## 🌐 Network Management

### Network Commands

```vim
" List networks
:DockerNetworks

" Inspect network
:DockerNetworkInspect app-network

" Connect container to network
:DockerNetworkConnect app-network web-app
```

### Network Configuration
```yaml
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true
    
services:
  web:
    networks:
      - frontend
      - backend
```

## 💡 Tips and Tricks

### 1. Quick Rebuild
```bash
# In terminal (⌘8)
docker-compose build --no-cache web
docker-compose up -d web
```

### 2. Environment Switching
```bash
# Development
docker-compose -f docker-compose.yml up

# Production
docker-compose -f docker-compose.prod.yml up
```

### 3. Debugging Tips
- Use `docker-compose logs -f service_name` for real-time logs
- Add `stdin_open: true` and `tty: true` for interactive debugging
- Mount `.env` files for easy configuration changes

## 🚨 Troubleshooting

### Container Won't Start
1. Check logs: `l` in services panel
2. Verify ports: `docker ps -a`
3. Check resources: `docker system df`

### Connection Issues
1. Verify network: `:DockerNetworkInspect`
2. Check firewall rules
3. Ensure correct port mapping

### Performance Problems
1. Limit resources in docker-compose:
```yaml
services:
  web:
    mem_limit: 512m
    cpus: '0.5'
```
2. Use `.dockerignore`
3. Optimize Dockerfile layers

---

**[← Previous: Multi-cursor Workflow](multicursor.md)** | **[Next: Code Structure →](structure.md)**