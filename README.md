# Nginx Certbot Multiport Setup
[![简体中文](https://img.shields.io/badge/语言-简体中文-red.svg)](README_ZH.md)

This project provides a simple shell script to quickly set up an Nginx reverse proxy with automatic HTTPS configuration using Let's Encrypt. It supports reverse proxy configuration for multiple ports.

## Features

- Automatic Nginx reverse proxy configuration
- Automatic SSL certificate acquisition and renewal using Let's Encrypt
- Support for multiple port reverse proxy configurations
- Deployment using Docker and Docker Compose

## Prerequisites

- Docker and Docker Compose installed
- A domain name pointing to your server's IP address

## Usage

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/nginx-certbot-multiport.git
   cd nginx-certbot-multiport
   ```

2. Run the setup script:
   ```
   ./setup.sh
   ```

3. Follow the prompts to enter:
   - Your domain name
   - Your email address (for Let's Encrypt notifications)
   - The ports you want to reverse proxy (you can enter multiple, one per line)

4. After the script completes, navigate to the newly created directory and start the services:
   ```
   cd <your_domain> && docker-compose up -d
   ```

## Configuration

The script will create a new directory named after your domain. Inside this directory, you'll find:

- `nginx-conf/`: Contains the Nginx configuration file
- `docker-compose.yml`: The Docker Compose file for running the Nginx-Certbot container

## Customization

If you need to modify the Nginx configuration or Docker Compose setup, you can edit the respective files in the created domain directory.

## Notes

- Ensure your firewall allows traffic on ports 80 and 443
- If your services are not running on the same machine, you'll need to modify the `proxy_pass` address in the generated Nginx configuration file

## Troubleshooting

If you encounter any issues, check the Docker logs:
```
docker-compose logs nginx-certbot
```

## Contributing

Issues and Pull Requests are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
