# Insurance API — Reto Integrador

Proyecto final que implementa una API de gestión de pólizas de seguros aplicando **Arquitectura Hexagonal**, principios **SOLID**, y patrones de diseño orientados a objetos.

---

## 🚀 Stack Tecnológico

| Componente | Especificación |
|-----------|----------------|
| **Lenguaje** | Python 3.12 |
| **Framework** | Django con Django REST Framework |
| **Persistencia** | SQLite (vía Django ORM) |
| **Broker (Observer)** | RabbitMQ |
| **Contenedores** | Docker & Docker Compose |
| **Documentación** | Swagger/OpenAPI (drf-spectacular) |

---

## 🏗️ Arquitectura del Proyecto

El proyecto sigue el patrón de **Arquitectura Hexagonal** (Ports & Adapters) para desacoplar la lógica de negocio de las preocupaciones de infraestructura.

### Estructura de directorios

```
apisofka/
├── config/                           # Configuración de Django
├── customers/                        # Módulo: Gestión de clientes
│   ├── domain/
│   │   ├── entities.py
│   │   └── ports/
│   ├── application/
│   │   └── use_cases/
│   └── infrastructure/
│       ├── api/
│       └── persistence/
├── policies/                         # Módulo: Gestión de pólizas (6 patrones)
│   ├── domain/
│   │   ├── entities.py
│   │   ├── ports/
│   │   ├── states/                  # 🔹 State Pattern (5 clases)
│   │   ├── factories/               # 🔹 Factory Method (4 concretas)
│   │   ├── strategies/              # 🔹 Strategy Pattern (3 concretas)
│   │   └── builders/                # 🔹 Builder Pattern
│   ├── application/
│   │   └── use_cases/               # 🔹 Orquestación de patrones
│   └── infrastructure/
│       ├── api/
│       ├── events/                  # 🔹 Observer & Broker
│       └── persistence/             # Mapper & Repository
├── shared/                           # Código compartido
│   └── events/
│       ├── domain/
│       └── infrastructure/           # EventPublisher (port + adapter)
├── notifications/                    # 🔹 Consumer 1: Notificaciones
│   ├── application/
│   │   └── consumers/
│   └── infrastructure/
├── audit/                            # 🔹 Consumer 2: Auditoría
│   ├── application/
│   │   └── consumers/
│   └── infrastructure/
├── manage.py
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
├── .env
├── .gitignore
└── README.md
```

---

## 🛠️ Requisitos Previos

- Docker y Docker Compose instalados
- Git

---

## 🚀 Pasos de Arranque

### 1. Clonar el repositorio

```bash
git clone <URL_DEL_REPO>
cd apisofka
```

### 2. Levantar los contenedores

```bash
docker-compose up -d
```

Esto iniciará automáticamente:
- La API de Django
- El servicio de RabbitMQ

### 3. Verificación

- **API**: [http://localhost:8000/api/docs](http://localhost:8000/api/docs) (Swagger)
- **Broker**: [http://localhost:15672](http://localhost:15672) (Credenciales: `guest` / `guest`)

---

## 🎨 Mapa de Patrones de Diseño

| Patrón | Ubicación | Descripción |
|--------|-----------|-------------|
| **Factory Method** | `policies/domain/factories/` | 4 factories concretas (Auto, Life, Home, Health) que crean coberturas específicas por ramo |
| **Builder** | `policies/domain/builders/` | `PolicyBuilder` fluido para ensamblar el agregado Policy con validación |
| **State** | `policies/domain/states/` | 5 clases de estado (Quoted, Issued, Active, Suspended, Cancelled) que definen transiciones válidas |
| **Strategy** | `policies/domain/strategies/` | 3 estrategias de tarificación (Standard, RiskBased, Loyalty) intercambiables |
| **Observer** | `shared/events/` + `policies/infrastructure/events/` | EventPublisher (port) + adapter RabbitMQ; 2 consumers desacoplados (notifications + audit) |
| **Singleton** | `policies/domain/` | PolicyNumberSequencer (inyectado via DI para garantizar unicidad de números de póliza) |

---

## 💡 Investigación: Patrón Singleton

### Recurso implementado
**PolicyNumberSequencer**

### Justificación
Se utiliza este patrón para garantizar que la generación de números de póliza sea:
- **Consistente**: Evita duplicidades
- **Thread-safe**: Funciona en entornos concurrentes

### Mitigación de riesgos (Testabilidad)
Se ha mitigado el riesgo de testabilidad inyectando la instancia mediante el contenedor de dependencias (DI), asegurando que:
- El estado global sea controlado
- El patrón sea completamente testeable

---

## 🧪 Pruebas

Puedes probar el flujo completo utilizando la colección de **Postman/HTTP** incluida en la carpeta `/postman`.

### Casos de prueba

#### 1. **Casos Base**
Verifica la creación de pólizas para los siguientes ramos:
- `AUTO`
- `LIFE`
- `HOME`
- `HEALTH`

#### 2. **Ciclo de Vida de la Póliza**
Prueba la transición completa del estado:

```
QUOTED → ISSUED → ACTIVE → SUSPENDED → ACTIVE → CANCELLED
```

#### 3. **Validación de Errores**
- Valida que transiciones inválidas retornen código `400`
- Verifica que el uso de `RISK_BASED` sin `riskScore` falle correctamente

---

## 📝 Notas

Desarrollado como reto integrador de Arquitectura de Software.

---