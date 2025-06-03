#!/bin/bash

set -e

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}🧰 Installing dependencies...${NC}"
sudo apt update
sudo apt install -y curl wget unzip jq openjdk-21-jre-headless

read -p "🎮 Enter the Minecraft version (e.g., 1.21.4): " MINECRAFT_VERSION
read -p "🌐 Enter the server port you want to use (default 25565): " SERVER_PORT
SERVER_PORT=${SERVER_PORT:-25565}
read -p "👑 Enter the Minecraft username to make OP (leave blank for none): " OP_USERNAME
read -p "🛡️ Do you want to enable a allowlist? (y/n): " ENABLE_ALLOWLIST

ALLOWLIST_NAMES=()

if [[ "$ENABLE_ALLOWLIST" =~ ^[Yy]$ ]]; then
  echo "📋 Enter the Minecraft usernames to allowlist. Type 'done' when finished."
  while true; do
    read -p "Allowlist username: " NAME
    [[ "$NAME" == "done" ]] && break
    [[ -z "$NAME" ]] && continue
    ALLOWLIST_NAMES+=("$NAME")
  done
fi

SERVER_DIR="paper-server-$MINECRAFT_VERSION"
mkdir -p "$SERVER_DIR"
cd "$SERVER_DIR" || exit 1

echo -e "${GREEN}📦 Fetching Paper build info...${NC}"
BUILD_JSON=$(curl -s "https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION")
LATEST_BUILD=$(echo "$BUILD_JSON" | jq '.builds[-1]')

if [[ -z "$LATEST_BUILD" || "$LATEST_BUILD" == "null" ]]; then
  echo "❌ Invalid version or Paper not available for $MINECRAFT_VERSION"
  exit 1
fi

JAR_NAME="paper-$MINECRAFT_VERSION-$LATEST_BUILD.jar"
echo -e "${GREEN}⬇️ Downloading $JAR_NAME...${NC}"
curl -Lo paper.jar "https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION/builds/$LATEST_BUILD/downloads/$JAR_NAME"

echo "eula=true" > eula.txt

echo -e "${GREEN}🔧 Generating server files...${NC}"
java -jar paper.jar nogui || true


if [ -f server.properties ]; then
  echo -e "${GREEN}🔁 Setting server port to $SERVER_PORT and allowlist setting...${NC}"
  sed -i "s/^server-port=.*/server-port=$SERVER_PORT/" server.properties
  if [[ "$ENABLE_ALLOWLIST" =~ ^[Yy]$ ]]; then
    sed -i "s/^white-list=.*/white-list=true/" server.properties
  else
    sed -i "s/^white-list=.*/white-list=false/" server.properties
  fi
else
  echo "⚠️ server.properties not found."
  exit 1
fi

if [[ -n "$OP_USERNAME" ]]; then
  echo -e "${GREEN}👑 Adding OP user $OP_USERNAME...${NC}"
  cat > ops.json <<EOF
[
  {
    "uuid": "00000000-0000-0000-0000-000000000000",
    "name": "$OP_USERNAME",
    "level": 4,
    "bypassesPlayerLimit": false
  }
]
EOF
fi

if [[ "$ENABLE_ALLOWLIST" =~ ^[Yy]$ ]]; then
  echo -e "${GREEN}🛡️ Creating allowlist with ${#ALLOWLIST_NAMES[@]} entries...${NC}"
  {
    echo "["
    for i in "${!ALLOWLIST_NAMES[@]}"; do
      name="${ALLOWLIST_NAMES[$i]}"
      comma=","
      if [[ $i -eq $((${#ALLOWLIST_NAMES[@]} - 1)) ]]; then
        comma=""
      fi
      echo "  {"
      echo "    \"uuid\": \"00000000-0000-0000-0000-000000000000\","
      echo "    \"name\": \"$name\""
      echo "  }$comma"
    done
    echo "]"
  } > whitelist.json
fi

echo -e "${GREEN}👌 Setup complete! To start your server later, run:${NC}"
echo "cd $PWD && java -jar paper.jar nogui"

