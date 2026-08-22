# 📊 Homelab Observability & Portal Stack

The **Homelab Observability & Portal Stack** provides a comprehensive telemetry, log aggregation, automated uptime monitoring, and startpage cockpit for the 3-node homelab cluster.

---

## 🏛️ Services & Access Points

| Application | Subdomain | Role |
| :--- | :--- | :--- |
| **Homepage** | [`https://homelab.bluewave.work`](https://homelab.bluewave.work) | Unified Homelab Cockpit & Service Cards |
| **Beszel Hub** | [`https://metrics.bluewave.work`](https://metrics.bluewave.work) | Real-Time Multi-Node CPU, RAM, Disk & Bandwidth Metrics |
| **Dozzle** | [`https://logs.bluewave.work`](https://logs.bluewave.work) | Cluster-Wide Real-Time Container Log Viewer |
| **Uptime Kuma** | [`https://status.bluewave.work`](https://status.bluewave.work) | Multi-Node Service Health & Alerting |

---

## 🚀 Deployment on Primary Node (`zap-vps`)

### 1. Configure Environment
```bash
cp .env.example .env
# Edit .env and adjust OBSERVABILITY_HOME if needed
```

### 2. Start the Stack
```bash
docker compose up -d
```

---

## 🤖 Remote Agents on Worker Nodes (`oci01-flex` & `orangepi5plus`)

To stream logs and telemetry from VM2 and VM3 to the central Hubs on VM1:

### 1. Beszel Agent (Telemetry & Bandwidth Collector)
Run on each worker node:
```bash
docker run -d \
  --name beszel_agent \
  --restart unless-stopped \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /:/extra-filesystems/root:ro \
  -e PORT=45876 \
  -e KEY="<YOUR_BESZEL_PUBLIC_KEY_FROM_HUB>" \
  henrygd/beszel-agent:latest
```

### 2. Dozzle Agent (Container Log Collector)
Run on each worker node:
```bash
docker run -d \
  --name dozzle_agent \
  --restart unless-stopped \
  -p 7007:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  amir20/dozzle:latest agent
```
*(Port 7007 is secured behind Tailscale mesh and blocked by Firewalld from the public internet).*
