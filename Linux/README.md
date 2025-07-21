## 🚀 Linux Setup & Startup Instructions

Follow these steps to get your local AI assistant running on Linux.

### 1️⃣ Install Ollama (manually)

Download and install Ollama:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Then run a model (for example, LLaMA 3):

```bash
ollama run llama3
```

> ℹ️ You can explore more models at [ollama.com/library](https://ollama.com/library)

---

### 2️⃣ Configure Ollama to Listen on `0.0.0.0`

To allow Docker containers to connect to Ollama running on the host, update your Ollama configuration file.

Edit or create:

```bash
~/.ollama/config.toml
```

Add or modify this line:

```toml
host = "0.0.0.0"
```

Then restart Ollama:

```bash
ollama serve &
```

Directly start with configuration
```bash
OLLAMA_HOST=0.0.0.0 ollama serve
```

---

### 3️⃣ Start Frontend and Proxy (Containers)

Run the provided script:

```bash
./run.sh
```

This will:

- Automatically create a `.env` file with the correct `OLLAMA_BASE_URL`
- Start Docker containers for the frontend and NGINX
- Set up proper networking to communicate with the host Ollama service

> 🌐 Once everything starts, visit: **[http://localhost](http://localhost)**

---

### 4️⃣ Check System Status

Use the `check.sh` script to verify everything is connected:

```bash
./check.sh
```

This will:

- Confirm that containers are running
- Check if the frontend is reachable
- Test if Ollama is accessible from inside the container

---

### 5️⃣ Stop & Clean Up

To stop the containers and exit Docker:

```bash
./stop.sh
```

This will:

- Stop the running containers
- Remove them (but not images or volumes)
- Exit Docker cleanly

---

### 📁 Environment File (`.env`)

The `.env` file is automatically created by `run.sh`. It stores the Ollama URL used by the frontend:

```dotenv
OLLAMA_BASE_URL=http://<your-ip>:11434
```

> 🔐 Make sure this file exists and is correctly configured before launching the frontend.

---
