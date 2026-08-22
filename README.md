# 📊 Homelab Observability & Cockpit Stack (Homepage, Beszel, Dozzle, Uptime Kuma)

Complete observability, monitoring, logging, and portal suite for the homelab cluster.

---

## 🏛️ Stack Architecture & Endpoints

| Service | Public URL | Role | Authentication |
| :--- | :--- | :--- | :--- |
| **Homepage** | `https://homelab.example.com` | Unified startpage & cockpit | Authelia SSO |
| **Beszel Hub** | `https://metrics.example.com` | Multi-node telemetry & bandwidth charts | Authelia 2FA + Native Admin |
| **Dozzle Hub** | `https://logs.example.com` | Centralized multi-node log viewer | Authelia SSO |
| **Uptime Kuma** | `https://status.example.com` | Outage alerts & status page | Public View / Native Admin |

---

## 💾 Standard Data & Storage Template

Persistent state is stored cleanly outside the Git repository in the standard homelab hierarchy:

```
/home/${SYSTEM_USER}/DATA/observability/data/
├── beszel/                    # Beszel historical resource & bandwidth database
├── uptime-kuma/               # Uptime Kuma monitoring & alert SQLite database
└── homepage/
    └── logs/                  # Homepage application logs
```

---

## 🚀 Deployment via Arcane GitOps

1. Open **Arcane Cockpit** at `https://arcane.example.com`.
2. Click **Projects** $\rightarrow$ **New Project**.
3. Set:
   * **Name:** `observability`
   * **Git Repository:** `https://github.com/medzarka/homelab-observability.git`
   * **Branch:** `main`
4. Add Environment Variables (from `.env.example`):
   ```env
   SYSTEM_USER=mgrsys
   DATA_DIR=/home/mgrsys/DATA
   TZ=UTC
   ROOT_DOMAIN=example.com
   BESZEL_PUBLIC_KEY=your_key_from_beszel_hub
   DOZZLE_REMOTE_AGENT=100.x.y.1:7007,100.x.y.2:7007
   ```
5. Click **Deploy**.

---

## 📡 Deploying Agents on Worker Nodes (VM2, VM3, etc.)

On any remote worker node (e.g. `oci01-flex` or `orangepi5plus`):

### 1. Run Dozzle Remote Log Agent:
```bash
docker run -d \
  --name dozzle_agent \
  --restart unless-stopped \
  -p 7007:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  amir20/dozzle:latest agent
```

### 2. Run Beszel Telemetry Agent:
```bash
docker run -d \
  --name beszel_agent \
  --restart unless-stopped \
  --network host \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /:/extra-filesystems/root:ro \
  -e PORT=45876 \
  -e KEY="<YOUR_BESZEL_PUBLIC_KEY>" \
  henrygd/beszel-agent:latest
```
