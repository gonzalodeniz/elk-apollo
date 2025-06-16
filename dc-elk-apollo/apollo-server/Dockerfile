# Imagen base Ubuntu 22.04 (jammy)
FROM ubuntu:22.04

# Instala Node.js 20 y dependencias necesarias
RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y wget gnupg && \
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | \    
    gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg && \    
    echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" \    
        > /etc/apt/sources.list.d/elastic-7.x.list && \
    apt-get update && apt-get install -y filebeat=7.17.17 metricbeat=7.17.17 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Carpeta de trabajo
WORKDIR /app

# Solo copiamos lo necesario para instalar dependencias
COPY package*.json ./
RUN npm install --omit=dev --no-audit --no-fund && \
    npm install elastic-apm-node --save


# Copia filebeat y su configuración
COPY filebeat.yml /etc/filebeat/filebeat.yml
COPY metricbeat.yml /etc/metricbeat/metricbeat.yml
RUN chown root:root /etc/filebeat/filebeat.yml && \
    chown root:root /etc/metricbeat/metricbeat.yml 


# Copiamos el resto del código
COPY index.js .

# Copiamos el script de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Puerto expuesto por Apollo Server
EXPOSE 4000

ENTRYPOINT ["/entrypoint.sh"]
