# aws-apollo

Este proyecto despliega un stack de Apollo Server con Nginx y está preparado para ser ejecutado tanto en local (con Docker Compose) como para crear una imagen personalizada en AWS usando Packer.

## Instalación con Docker Compose en local

1. **Clona el repositorio y accede al directorio**
   ```bash
   git clone https://github.com/gonzalodeniz/elk-apollo
   cd elk-apollo/aws-apollo
   ```

2. **Construye las imágenes (solo la primera vez o tras cambios)**
   ```bash
   docker-compose build
   ```

3. **Arranca todos los servicios**
   ```bash
   docker-compose up -d
   ```

4. **Accede a Apollo Server y Nginx**
   - Apollo Server (vía Nginx): [http://localhost](http://localhost)

---

## Creación de imagen con Packer

El fichero [`apollo.pkr.hcl`](apollo.pkr.hcl) permite construir una AMI de AWS con Docker y el proyecto ya desplegado.

1. **Configura tus credenciales AWS**  
   Exporta tus variables de entorno AWS o usa el script `set-aws-creds.ps1` si usas PowerShell.

2. **Construye la imagen**
   ```bash
   packer init apollo.pkr.hcl
   packer build apollo.pkr.hcl
   ```

   Esto generará una AMI con Docker, Docker Compose y el proyecto copiado en `/home/ubuntu/app`. Al arrancar la instancia, el servicio Docker Compose se iniciará automáticamente.

---

## Configuración de Filebeat y Metricbeat

El contenedor Apollo Server incluye Filebeat y Metricbeat para enviar logs y métricas al stack ELK.

- **Filebeat**: Configuración en [`apollo-server/filebeat.yml`](apollo-server/filebeat.yml)
- **Metricbeat**: Configuración en [`apollo-server/metricbeat.yml`](apollo-server/metricbeat.yml)

### Rutas y parámetros a modificar

- Para que Filebeat y Metricbeat apunten a tu stack ELK, revisa y ajusta las siguientes rutas en los archivos de configuración:

#### Filebeat (`apollo-server/filebeat.yml`)
```yaml
output.logstash:
  hosts: ["logstash:5044"] # Cambia 'logstash' por la IP o hostname de tu Logstash si es externo

setup.kibana:
  host: "http://kibana:5601" # Cambia 'kibana' por la IP o hostname de tu Kibana si es externo
```

#### Metricbeat (`apollo-server/metricbeat.yml`)
```yaml
output.elasticsearch:
  hosts: ["http://elasticsearch:9200"] # Cambia 'elasticsearch' por la IP o hostname de tu Elasticsearch

setup.kibana:
  host: "http://kibana:5601" # Cambia 'kibana' por la IP o hostname de tu Kibana si es externo
```

> **Nota:** Si despliegas en AWS, asegúrate de que los servicios ELK sean accesibles desde la instancia (ajusta los grupos de seguridad y las rutas de red según corresponda).

---

## Resumen de rutas de configuración

- Logs a Logstash: `apollo-server/filebeat.yml` → `output.logstash.hosts`
- Métricas a Elasticsearch: `apollo-server/metricbeat.yml` → `output.elasticsearch.hosts`
- Dashboards a Kibana: ambos archivos → `setup.kibana.host`

---

## Prueba de consultas en Apollo Server
Cuando se haya creado la instancia en AWS, ejecuta la siguiente consulta para probar que responde correctamente:
```
query GetBooks {
  books {
    title
    author
  }
}
```

## Referencias

- [Documentación oficial de Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)
- [Documentación oficial de Metricbeat](https://www.elastic.co/guide/en/beats/metricbeat/current/index.html)
- [Packer AWS Builder](https://developer.hashicorp.com/packer/plugins/builders/amazon/ebs)