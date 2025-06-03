# 🚀 Paper Minecraft Server Setup Script

A powerful, interactive script that sets up a fully functional Paper Minecraft server on **Linux** in seconds.

No manual downloads. No guesswork. Just run it, answer a few questions, and boom — server online or ready to go. With some port forwarding.

---

## 🧰 Features

- ✅ Prompts for your **Minecraft version**
- ✅ Downloads the latest **Paper server jar**
- ✅ Installs **Java 21 and required dependencies**
- ✅ Asks what **port** you want your server on
- ✅ Adds **your Minecraft username as OP**
- ✅ Supports an optional **allowlist**
- ✅ Automatically sets up `eula.txt` and `server.properties`
- ✅ Clean directory creation for each server version
- ✅ Future-proof: asks for variables instead of hardcoding

---

## 🛠️ Requirements

- 🐧 A terminal to run it in (Only works on linux based terminals)
- 🌐 Internet connection
- 🧠 1 human willing to answer a few questions

---

## 🏃 How to Use

1. Clone or download the script file:
    ```bash
    curl -O https://raw.githubusercontent.com/thecoder133/minecraft-server-script/main/Make-Minecraft-Server.sh
    ```

2. Make it executable:
    ```bash
    chmod +x Make-Minecraft-Server.sh
    ```

3. Run it!
    ```bash
    ./Make-Minecraft-Server.sh
    ```

4. Answer a few questions:
    - Minecraft version (e.g., `1.21.4`)
    - Port number (default: `25565`)
    - Your options such as allowlist and op
    - **Make sure that once it is complete to type stop and start server again to apply allowlist and op settings**
