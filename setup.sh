#!/bin/bash

# 函数：检查是否为有效的端口号
is_valid_port() {
    local port=$1
    if [[ "$port" =~ ^[0-9]+$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
        return 0
    else
        return 1
    fi
}

# 提示输入域名
read -p "your domain: " domain

# 提示输入邮箱
read -p "your email: " email

# 提示输入端口号
ports=()
echo "proxy port (Each line one port，input 'done' finish):"
while true; do
    read port
    if [ "$port" == "done" ]; then
        break
    fi
    if is_valid_port "$port"; then
        ports+=("$port")
    else
        echo "Invalid port input: $port"
    fi
done

# 如果没有输入端口，使用默认端口 9999
if [ ${#ports[@]} -eq 0 ]; then
    ports+=("9999")
    echo "Default port: 9999"
fi

# 创建项目目录
mkdir -p "$domain/nginx-conf"
cd "$domain"

# 创建 Nginx 配置文件
cat > "nginx-conf/$domain.conf" <<EOL
server {
    listen 80;
    listen [::]:80;
    server_name $domain;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $domain;

    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

EOL

# 添加每个端口的 location 块
for port in "${ports[@]}"; do
    cat >> "nginx-conf/$domain.conf" <<EOL
    location /$port/ {
        proxy_pass http://host.docker.internal:$port/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

EOL
done

# 结束 Nginx 配置文件
echo "}" >> "nginx-conf/$domain.conf"

# 创建 Docker Compose 文件
cat > docker-compose.yml <<EOL
version: '3'

services:
  nginx-certbot:
    image: jonasal/nginx-certbot:latest
    restart: unless-stopped
    environment:
      - CERTBOT_EMAIL=$email
    ports:
      - 80:80
      - 443:443
    volumes:
      - nginx_secrets:/etc/letsencrypt
      - ./nginx-conf:/etc/nginx/user_conf.d:ro
    extra_hosts:
      - "host.docker.internal:host-gateway"

volumes:
  nginx_secrets:
EOL

echo "All config setup done："
echo "cd $domain && docker-compose up -d"
