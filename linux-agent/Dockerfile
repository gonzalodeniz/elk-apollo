# Imagen base ultraligera
FROM debian:bookworm-slim

# 1. Instala dependencias mínimas y Filebeat
RUN apt-get update && apt-get install -y wget gnupg && \
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | \
        gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" \
        > /etc/apt/sources.list.d/elastic-8.x.list && \
    apt-get update && apt-get install -y filebeat=8.13.4 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Copia configuración por defecto (puede montarse -v para override)
COPY filebeat.yml /etc/filebeat/filebeat.yml
RUN chown root:root /etc/filebeat/filebeat.yml

# 3. Arranca Filebeat en primer plano (logs -> stdout)
ENTRYPOINT ["/usr/bin/filebeat", "-e", "-c", "/etc/filebeat/filebeat.yml"]

