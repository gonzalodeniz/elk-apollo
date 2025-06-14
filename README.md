# ELK + Apollo Stack

Este proyecto despliega un stack completo de observabilidad y monitorización usando Elastic Stack (ELK: Elasticsearch, Logstash, Kibana), Apollo Server (GraphQL), APM y Nginx como proxy inverso. Permite recolectar logs y métricas de aplicaciones Node.js (Apollo Server) y visualizarlos en Kibana.

## ¿Qué incluye este stack?

- **Elasticsearch**: Almacén de datos para logs y métricas.
- **Logstash**: Procesa y enruta logs recibidos de Filebeat.
- **Kibana**: Visualización de logs, dashboards y APM.
- **APM Server**: Recibe métricas de rendimiento de aplicaciones.
- **Apollo Server**: Servidor GraphQL de ejemplo.
- **Nginx**: Proxy inverso para exponer Apollo Server en el puerto 80.
- **Filebeat**: (Configurado en Apollo Server) Envía logs a Logstash.

## Instalación y arranque

1. **Clona el repositorio y accede al directorio**
   ```bash
   git clone https://github.com/gonzalodeniz/elk-apollo
   cd elk-apollo
   ```

2. **Construye las imágenes (solo la primera vez o tras cambios)**
   ```bash
   docker-compose build
   ```

3. **Arranca todos los servicios**
   ```bash
   docker-compose up -d
   ```

4. **Verifica que todo está funcionando**
   - Apollo Server: http://localhost (proxy Nginx)
   - Kibana: http://localhost:5601

## Configuración de Kibana para ver los datos

1. **Accede a Kibana**
   - Navega a [http://localhost:5601](http://localhost:5601)

2. **Visualiza logs y métricas**
   - Ve a "Observability > Logs" para explorar los logs enviados por Filebeat.

3. **Discovery logs-generic-default***
   - Ve a "Descovery" y se mostrará los campos de los logs
## Parar y limpiar

```bash
docker-compose down -v
```
Esto detiene y elimina los contenedores y volúmenes de datos.

---

# Problemas

**Conexión de apollo con kibana**
Puede que en kibana no se visualice los índices del apollo-server. Comprueba los logs de apollo-server y puede que muestre este mensaje:
"Exiting: error connecting to Kibana: fail to get the Kibana version: HTTP GET request to http://kibana:5601/api/status fails"

En este caso, reinicia el apollo-server o el filebeat para que reconecte. Esto puede pasar si Kibana no está disponible en el momento de 
inicializar el filebeat.


