# ai.local

**ai.local** is a local AI chatbot system using [Ollama](https://ollama.com/) as the backend and a web-based frontend served through Nginx.

This project includes **two architecture designs** for different environments:

- 🐧 Linux system
- 🪟 Windows system (with WSL for containers)

Each setup keeps Ollama installed on the host, and runs the frontend via containers.

---

## 🐧 Linux System Architecture (./Linux)

In this configuration:

- **Ollama is installed directly on the Linux host**
- **Frontend (Open WebUI)** and **Nginx (reverse proxy)** are both containerized

### 🔄 Flow Diagram (Linux)

```text
                   ┌────────────────────────────┐
                   │    Client Browser (User)   │
                   └────────────┬───────────────┘
                                │
                                ▼
                       ┌────────────────┐
                       │    NGINX       │ (Docker)
                       │  Reverse Proxy │
                       └──────┬─────────┘
                              │
              ┌───────────────┴──────────────┐
              ▼                              ▼
      ┌──────────────┐             ┌──────────────────┐
      │  Frontend    │   HTTP API  │     Ollama       │
      │ (Open WebUI) │◄───────────▶│  (Host Installed)│
      └──────────────┘             └──────────────────┘
````

---

## 🪟 Windows System Architecture (./Windows)

In this setup:

* **Ollama is installed natively on Windows**
* **Docker (running inside WSL)** hosts the frontend and Nginx containers
* Communication occurs between WSL containers and the Windows host Ollama backend via host networking

### 🔄 Flow Diagram (Windows + WSL)

```text
                   ┌────────────────────────────┐
                   │    Client Browser (User)   │
                   └────────────┬───────────────┘
                                │
                                ▼
                       ┌────────────────┐
                       │    NGINX       │ (Docker in WSL)
                       │  Reverse Proxy │
                       └──────┬─────────┘
                              │
              ┌───────────────┴──────────────┐
              ▼                              ▼
      ┌──────────────┐             ┌──────────────────┐
      │  Frontend    │   HTTP API  │     Ollama       │
      │ (Open WebUI) │◄───────────▶│ (Windows Native) │
      └──────────────┘             └──────────────────┘
```

> 📌 Make sure the WSL containers can reach Ollama on the Windows host IP (e.g., `host.docker.internal` or local network IP).

---

## 💡 Summary

| Component     | Linux                   | Windows (with WSL)           |
| ------------- | ----------------------- | ---------------------------- |
| Ollama        | Host-installed (native) | Windows-native               |
| Frontend      | Docker container        | Docker in WSL                |
| NGINX         | Docker container        | Docker in WSL                |
| Communication | Localhost or bridge     | `host.docker.internal` or IP |

---