# Epicentro Gourmet

**Sistema de gestión de festivales gastronómicos**

![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-4.1.1-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)
![Spring Security](https://img.shields.io/badge/Spring_Security-6DB33F?style=for-the-badge&logo=springsecurity&logoColor=white)
![Thymeleaf](https://img.shields.io/badge/Thymeleaf-005F0F?style=for-the-badge&logo=thymeleaf&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.4-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Maven](https://img.shields.io/badge/Maven-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Lombok](https://img.shields.io/badge/Lombok-BC4521?style=for-the-badge)
![OpenPDF](https://img.shields.io/badge/OpenPDF-1.3.30-CC0000?style=for-the-badge)

---

## Descripción

**Epicentro Gourmet** es una aplicación web para la gestión integral de festivales gastronómicos. Centraliza la administración de festivales, unidades de venta, empleados, platos, pedidos, caja y liquidaciones de sueldo en un único sistema con distintos niveles de acceso.

- **¿A quién va dirigido?** A organizadores de festivales gastronómicos, responsables de unidades de venta (food trucks y puestos desarmables) y personal operativo: cajeros, cocineros, ayudantes de cocina y lavaplatos.
- **Objetivo principal:** digitalizar y unificar la operación diaria del festival, desde la registración de un pedido y el control de caja hasta la liquidación de haberes y los reportes de rentabilidad.

---

## Características principales

### Autenticación y seguridad
- Inicio de sesión con Spring Security y control de acceso por roles.
- Roles diferenciados: administrador, responsable y empleados (cajeros y personal de cocina).
- Recuperación de contraseña mediante enlace temporal enviado por correo.
- Cambio de contraseña desde el perfil del usuario.
- Edición de datos personales para responsables y staff.

### Festivales y unidades de venta
- Visualización de los festivales disponibles en la página de inicio.
- Registro de unidades de venta con asignación de un responsable.
- Soporte para food trucks y puestos desarmables.
- Listado de unidades de venta por festival.
- Ranking de unidades de venta por facturación de pedidos.
- Reporte de unidades con mayor canon.
- Cálculo de rentabilidad neta, general y entre fechas.

### Gestión de empleados
- Alta de empleados con envío de credenciales por correo.
- Listado y filtrado de empleados.
- Activación y desactivación de empleados.
- Historial de empleados y asignaciones a unidades de venta.

### Gestión de platos
- Alta de platos con precio, costo y unidad de venta.
- Activación y desactivación de platos.
- Reporte de plato estrella.

### Pedidos
- Registro de pedidos con validación de la unidad de venta y de la caja abierta.
- Listado paginado de pedidos por unidad de venta.
- Generación y descarga del ticket/comanda del pedido en PDF.

### Caja
- Apertura y cierre de caja exclusivo para cajeros.
- Registro del total declarado al cierre.
- Cálculo automático del total del sistema y de la diferencia de caja.

### Contabilidad y reportes
- Cálculo de liquidaciones de sueldo.
- Generación del recibo de sueldo en PDF.
- Envío de liquidaciones por correo electrónico.
- Reporte de ventas por festival.
- Ranking de unidades de venta por facturación.
- Reportes de rentabilidad y mayor canon.

### Interfaz
- Vistas server-side con Thymeleaf.
- Diseño responsive.
- Modo claro y modo oscuro.

---

## Tecnologías utilizadas

| Categoría | Tecnología |
|-----------|------------|
| Lenguaje | Java 17 |
| Framework principal | Spring Boot 4.1.1 |
| Web | Spring MVC |
| Seguridad | Spring Security + Thymeleaf Extras Spring Security |
| Persistencia | Spring Data JPA / Hibernate |
| Base de datos | MySQL 8.4 |
| Motor de plantillas | Thymeleaf |
| Build | Maven (wrapper incluido) |
| Utilidades | Lombok, ModelMapper |
| Reportes PDF | OpenPDF |
| Correo electrónico | Spring Mail (SMTP Gmail) |
| Contenedores | Docker + Docker Compose |

---

## Estructura del proyecto

```text
src/main/java/com/unla/hito2
├── controller     # Controladores web
├── service        # Lógica de negocio
├── repository     # Acceso a datos
├── entity         # Entidades JPA
├── dto            # Objetos de transferencia
└── config         # Configuración de seguridad y aplicación

src/main/resources
├── templates      # Vistas Thymeleaf
├── static         # CSS, JS e imágenes
├── data.sql       # Datos iniciales
└── pedidos.sql    # Pedidos de prueba
```
---

## 🧩 Diagrama de clases
![Diagrama de Clases](https://github.com/user-attachments/assets/a5f79203-9c2c-48f3-b137-c99e884581ba)
[Ver diagrama de clases](https://github.com/user-attachments/assets/a5f79203-9c2c-48f3-b137-c99e884581ba)

## Requisitos previos

- **Java 17** o superior
- **Git**
- **Docker y Docker Compose** (opcional, recomendado)
- **MySQL 8.4** (si no se utiliza Docker)

> Maven no es necesario instalarlo: el proyecto incluye el wrapper `mvnw` / `mvnw.cmd`.

---

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/sOliveto93/TPGrupalHito2Grupo06.git
cd TPGrupalHito2Grupo06
```

### 2. Configurar variables de entorno

La aplicación toma la configuración desde variables de entorno:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `SPRING_DATASOURCE_URL` | URL de conexión a MySQL | `jdbc:mysql://localhost:3307/hito2` |
| `BD_USER` | Usuario de la base de datos | `root` |
| `BD_PASS` | Contraseña de la base de datos | `root` |
| `MAIL_USER` | Cuenta de correo para envíos | `tu_correo@gmail.com` |
| `MAIL_PASS` | Contraseña de aplicación de Gmail | `abcd efgh ijkl mnop` |
| `APP_URL_BASE` | URL base usada en los enlaces de los mails | `http://localhost:8080` |

**PowerShell (Windows):**

```powershell
$env:SPRING_DATASOURCE_URL="jdbc:mysql://localhost:3307/hito2"
$env:BD_USER="root"
$env:BD_PASS="root"
$env:MAIL_USER="tu_correo@gmail.com"
$env:MAIL_PASS="tu_password_de_aplicacion"
$env:APP_URL_BASE="http://localhost:8080"
```

**Bash (Linux / macOS / Git Bash):**

```bash
export SPRING_DATASOURCE_URL="jdbc:mysql://localhost:3307/hito2"
export BD_USER="root"
export BD_PASS="root"
export MAIL_USER="tu_correo@gmail.com"
export MAIL_PASS="tu_password_de_aplicacion"
export APP_URL_BASE="http://localhost:8080"
```

### 3. Levantar la base de datos

**Opción A — Todo con Docker (aplicación + MySQL):**

```bash
docker compose up --build
```

La aplicación queda disponible en `http://localhost:8080`.

**Opción B — Solo MySQL con Docker y la aplicación en local:**

```bash
docker compose up -d mysql
```

Esto expone MySQL en el puerto **3307** del host, por eso la URL de conexión es `jdbc:mysql://localhost:3307/hito2`.

### 4. Ejecutar la aplicación

**Windows:**

```powershell
.\mvnw.cmd spring-boot:run
```

**Linux / macOS / Git Bash:**

```bash
./mvnw spring-boot:run
```

Luego abrir en el navegador:

```text
http://localhost:8080
```

### 5. Ejecutar los tests

Tests unitarios (no requieren base de datos):

```powershell
.\mvnw.cmd -Dtest=PedidoServiceTest,FestivalServiceTest test
```

Suite completa (requiere MySQL y las variables de entorno configuradas):

```powershell
.\mvnw.cmd test
```

### 6. Datos de prueba

La aplicación usa `spring.jpa.hibernate.ddl-auto=create-drop` y carga automáticamente:

- `data.sql`: costos, festivales, usuarios, empleados, unidades de venta, platos y cierres de caja.
- `pedidos.sql`: pedidos y detalles de prueba.

> ⚠️ **Importante:** al reiniciar la aplicación, el esquema se recrea y se vuelven a cargar los datos iniciales. Los cambios realizados en la base se pierden.

---

## 👤 Roles del sistema

| Rol | Alcance |
|-----|---------|
| **Administrador** | Gestión general del sistema y acceso a reportes globales. |
| **Responsable** | Administración de sus unidades de venta, empleados, liquidaciones y rentabilidad. |
| **Cajero** | Apertura y cierre de caja, registro de pedidos y emisión de tickets. |
| **Cocina** (cocinero, ayudante, lavaplatos) | Consulta de pedidos y descarga de comandas/tickets. |

---

## Casos de uso implementados

| N.º | Caso de uso | Integrante |
|:---:|-------------|------------|
| 1 | Visualización de festivales en la página de inicio(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/3) | Patricio Anrrique |
| 2 | Registro de unidad de venta con responsable(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/3) | Patricio Anrrique |
| 3 | Alta de empleado con envío de mail(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/4) | Patricio Anrrique |
| 4 | Ver liquidación de sueldo(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/8) | Patricio Anrrique |
| 5 | Calcular liquidación de sueldo y recibo en PDF(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/20)(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/26) | Patricio Anrrique |
| 6 | Recibir liquidación por mail(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/27) | Patricio Anrrique |
| 7 | Editar perfil de usuario para Responsable y Staff(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/32) | Patricio Anrrique |
| 8 | Modo oscuro(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/32) | Patricio Anrrique |
| 9 | Alta de pedido(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/9) | Sebastián Oliveto |
| 10 | Vista de reporte para el Administrador(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/12) | Sebastián Oliveto |
| 11 | Listar unidades de venta por festival(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/13) | Sebastián Oliveto |
| 12 | Ranking de unidades de venta por facturación de pedidos(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/13) | Sebastián Oliveto |
| 13 | Reporte plato estrella(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/14) | Sebastián Oliveto |
| 14 | Reporte de venta por festival(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/17) | Sebastián Oliveto |
| 15 | Reporte mayor canon(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/18) | Sebastián Oliveto |
| 16 | Apertura y cierre de caja(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/23) | Sebastián Oliveto |
| 17 | Activar y desactivar platos(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/24) | Sebastián Oliveto |
| 18 | Activar y desactivar empleados(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/25) | Sebastián Oliveto |
| 19 | Rentabilidad neta entre fechas(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/30) | Sebastián Oliveto |
| 20 | Ticket de pedido en PDF(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/31) | Sebastián Oliveto |
| 21 | Alta de plato(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/7) | Matías Torres de Lima |
| 22 | Perfil de usuario(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/28) | Matías Torres de Lima |
| 23 | Cambio de contraseña(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/28) | Matías Torres de Lima |
| 24 | Recuperación de contraseña(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/29) | Matías Torres de Lima |
| 25 | Filtrar empleado activo(https://github.com/sOliveto93/TPGrupalHito2Grupo06/pull/33) | Matías Torres de Lima |
---

## 👥 Integrantes

| Integrante | Casos de uso | Participación |
|------------|:------------:|---------------|
| **Patricio Anrrique** | 1 – 8 | Festivales, unidades de venta, empleados, liquidaciones, perfil y modo oscuro. |
| **Sebastián Oliveto** | 9 – 20 | Pedidos, caja, reportes, rankings, rentabilidad y tickets PDF. |
| **Matías Torres de Lima** | 21 – 24 | Platos, perfil de usuario, cambio y recuperación de contraseña. |

---

## Licencia

Proyecto académico desarrollado para la materia **Objetos 2** de la **Universidad Nacional de Lanús (UNLa)**.
