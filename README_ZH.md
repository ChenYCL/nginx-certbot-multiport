# Nginx Certbot Multiport Setup

这个项目提供了一个简单的 shell 脚本，用于快速设置 Nginx 反向代理，并使用 Let's Encrypt 自动配置 HTTPS。它支持多个端口的反向代理配置。

## 功能

- 自动配置 Nginx 反向代理
- 使用 Let's Encrypt 自动获取和更新 SSL 证书
- 支持多个端口的反向代理配置
- 使用 Docker 和 Docker Compose 进行部署

## 前提条件

- 已安装 Docker 和 Docker Compose
- 拥有一个指向您服务器 IP 的域名

## 使用方法

1. 克隆此仓库：
```
git clone https://github.com/yourusername/nginx-certbot-multiport.git
cd nginx-certbot-multiport
```
2. 运行设置脚本：
```
./setup.sh
```
3. 按照提示输入以下信息：
- 您的域名
- 您的邮箱地址（用于 Let's Encrypt 通知）
- 要反向代理的端口号（可以输入多个，每行一个）

4. 脚本执行完成后，进入新创建的目录并启动服务：
```
cd <your_domain> && docker-compose up -d
```
## 注意事项

- 确保您的防火墙允许 80 和 443 端口的流量
- 如果您的服务不在同一台机器上运行，需要修改生成的 Nginx 配置文件中的 `proxy_pass` 地址

## 贡献

欢迎提交 Issues 和 Pull Requests！

## 许可

本项目采用 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。
