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
   git clone <repo-url>
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

2. **Importa dashboards de Filebeat**
   - Los dashboards de Filebeat se cargan automáticamente si `setup.dashboards.enabled: true` en la configuración de Filebeat.
   - Ve a "Dashboards" y busca los de Filebeat (por ejemplo, "[Filebeat System] Syslog dashboard").

3. **Visualiza logs y métricas**
   - Ve a "Discover" para explorar los logs enviados por Filebeat.
   - Filtra por el índice `filebeat-*` o `logstash-*` según la configuración.

4. **APM (Opcional)**
   - Si tienes agentes APM configurados en tu app, ve a la sección "APM" para ver trazas y métricas de rendimiento.

## Personalización

- Puedes modificar la configuración de Filebeat, Logstash o Apollo Server según tus necesidades.
- Para añadir más módulos de Filebeat, edita el archivo `filebeat.yml` en el contenedor correspondiente.

## Parar y limpiar

```bash
docker-compose down -v
```
Esto detiene y elimina los contenedores y volúmenes de datos.

---

**Autor:** Tu nombre o equipo
