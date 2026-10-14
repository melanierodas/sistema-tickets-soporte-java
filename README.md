# Sistema de Gestión de Tickets de Soporte Técnico (Java Web + Colas FIFO)

Plataforma web para el registro, asignación y resolución de incidentes técnicos en telecomunicaciones (soporte al cliente). El sistema implementa la estructura de datos lineal **Queue (Colas FIFO)** en memoria para garantizar que las solicitudes pendientes se atiendan estrictamente en orden cronológico de llegada, respaldado por una base de datos relacional.

## 🚀 Funcionalidades Principales

- **Registro de Reclamos:** Captura de datos del cliente, contacto, servicio afectado (televisión, cajas receptoras de cable) y descripción detallada del problema con estado inicial `PENDIENTE`.
- **Estructura de Datos FIFO (Queue):** Implementación de `java.util.Queue` y `LinkedList` (`offer`, `peek`, `poll`) para gestionar el flujo ordenado de atención sin alterar la prioridad de los tickets.
- **Panel de Soporte Técnico y Resolución:** Visualización del ticket activo en cabecera de cola, selección de la solución aplicada (reinicio remoto, activación de plan, visita técnica) y actualización en base de datos a estado `ATENDIDO` con marca de tiempo.
- **Sincronización Automática:** Carga y refresco de incidentes no resueltos desde el motor relacional hacia la memoria de la aplicación.

## 🛠️ Tecnologías Utilizadas

- **Lenguaje:** Java (JDK 17+)
- **Estructuras de Datos:** `Queue<clsReclamos>`, `LinkedList`
- **Frontend / Web:** JSP (JavaServer Pages), Bootstrap 5, HTML5, CSS3
- **Base de Datos:** Microsoft SQL Server (Transact-SQL con JDBC `PreparedStatement`)
- **Arquitectura:** Modelo en capas (Backend / Frontend / Control de datos)

## 📂 Estructura del Repositorio

- `src/BACKEND/`: 
  - `clsConexion.java`: Conexión JDBC segura hacia SQL Server.
  - `clsReclamos.java`: Lógica de negocio, métodos de persistencia y operaciones sobre la cola `Queue`.
- `web/`:
  - `index.jsp`: Formulario de registro de incidentes técnicos.
  - `atencion.jsp`: Panel operativo del técnico de soporte con procesamiento FIFO.
