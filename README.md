# 📊 Homelab Observability & Cockpit Stack (Homepage, Beszel, Dozzle, Uptime Kuma)

Complete observability, monitoring, logging, and portal suite for the homelab cluster.

---

## 🏛️ Stack Architecture & Endpoints

| Service | Public URL | Role | Target Node | Authentication |
| :--- | :--- | :--- | :--- | :--- |
| **Homepage** | `https://homelab.example.com` | Unified startpage & cockpit | Main (VM1) | Authelia SSO |
| **Beszel Hub** | `https://metrics.example.com` | Multi-node telemetry & bandwidth charts | Main (VM1) | Authelia 2FA + Native Admin |
| **Dozzle Hub** | `https://logs.example.com` | Centralized multi-node log viewer | Main (VM1) | Authelia SSO |
| **Uptime Kuma** | `https://status.example.com` | Outage alerts & status page | Main (VM1) | Public View / Native Admin |
| **Beszel Agent** | Internal Port `45876` | Node metrics collector daemon | All Nodes | Hub SSH Keypair |
| **Dozzle Agent** | Internal Port `7007` | Remote container log streamer | Worker Nodes | Tailscale Mesh Only |

---

## 📁 Repository Structure

```
homelab-observability/
├── docker-compose.yaml          # Master stack (Homepage, Beszel Hub, Dozzle Master, Uptime Kuma)
├── docker-compose-worker.yaml   # Worker stack (Beszel Agent + Dozzle Agent)
├── .env.example                 # Environment template for Main Manager VM
├── .env.worker.example          # Environment template for Worker Nodes
└── config/                      # Homepage dashboards, themes, and bookmarks
```

---

## 🚀 1. Manager Node Deployment (`zap-vps`)

### Via Arcane Cockpit (Recommended):
1. Open **Arcane** at `https://arcane.example.com`.
2. Click **Projects** $\rightarrow$ **New Project**.
3. Set:
   * **Name:** `observability`
   * **Git Repository:** `https://github.com/medzarka/homelab-observability.git`
   * **Branch:** `main`
4. Set Environment Variables (from `.env.example`):
   ```env
   SYSTEM_USER=mgrsys
   DATA_DIR=/home/mgrsys/DATA
   TZ=UTC
   ROOT_DOMAIN=example.com
   BESZEL_PUBLIC_KEY=ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...
   DOZZLE_REMOTE_AGENT=100.x.y.2:7007,100.x.y.3:7007
   ```
5. Click **Deploy**.

---

## 📡 2. Worker Node Deployment (`oci01-flex`, `orangepi`, etc.)

Deploy the ultra-lightweight agent stack on any worker node.

### A. Via Arcane Agent (GitOps):
1. In Arcane Cockpit, create a project targeting the worker node.
2. Select Compose file: `docker-compose-worker.yaml`.
3. Provide `.env.worker` variables and deploy.

### B. Via Docker Compose CLI:
```bash
# 1. Clone repository on the worker node
git clone https://github.com/medzarka/homelab-observability.git
cd homelab-observability

# 2. Configure worker environment
cp .env.worker.example .env
nano .env  # Set TS_NODE_IP and BESZEL_PUBLIC_KEY

# 3. Start observability agents
docker compose -f docker-compose-worker.yaml up -d
```
