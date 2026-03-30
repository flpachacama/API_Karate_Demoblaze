# AI Workflow - Proyecto QA Automation REST Demoblaze con Karate DSL

## 1. Introduccion

### Objetivo del proyecto
Definir y ejecutar un flujo de automatizacion QA para los servicios REST de autenticacion de Demoblaze, con foco en estabilidad funcional, deteccion temprana de defectos y evidencia de calidad reutilizable en ciclos de integracion continua.

### Alcance
Este workflow aplica al proyecto actual y cubre los endpoints:
- `POST /signup`
- `POST /login`

Cobertura funcional implementada:
- Crear un nuevo usuario en signup
- Intentar crear un usuario ya existente
- Login con usuario y password correcto
- Login con usuario y password incorrecto

Incluye ademas:
- Manejo de datos dinamicos para evitar colisiones
- Validaciones de status y mensajes de negocio
- Ejecucion con Maven y Karate JUnit5
- Generacion de reportes para analisis QA

### Tecnologias utilizadas
- **Karate DSL (1.5.0):** escenarios API en Gherkin y validaciones declarativas
- **Java (17):** runtime de pruebas y runner JUnit5
- **Maven:** gestion de dependencias y ejecucion de suites

## 2. Metodologia de trabajo

### Enfoque de automatizacion
Se aplica un enfoque **API-first y orientado a riesgo** sobre autenticacion, priorizando escenarios criticos de alta frecuencia (registro e inicio de sesion).

Principios aplicados:
- Escenarios por comportamiento de negocio
- Independencia entre pruebas
- Datos desacoplados de la logica
- Reutilizacion de utilidades para mantenimiento simple

### Uso de IA (Copilot) en el flujo de trabajo
La IA se usa para acelerar tareas repetitivas sin comprometer control de calidad:
- Propuesta inicial de escenarios positivos y negativos
- Asistencia en aserciones Karate (`match`, contains, tipos)
- Refactor de reutilizacion en `utils` y estructura de `features`
- Redaccion tecnica y estandarizacion documental

Control QA:
- Todo aporte generado con IA se revisa funcionalmente antes de merge
- No se aprueba codigo sin ejecucion local de pruebas
- Se documentan ajustes manuales relevantes

### Buenas practicas operativas
- Mantener trazabilidad: caso de prueba -> feature -> evidencia
- Ejecutar smoke antes de integrar cambios
- Revisar consistencia de mensajes de negocio esperados
- Evitar hardcode de usuarios reutilizando generacion dinamica

## 3. Flujo de desarrollo (AI Workflow)

### Paso 1: Analisis del servicio REST
- Revisar contrato de `signup` y `login` (payload y formato de respuesta)
- Identificar criterios de exito y errores funcionales esperados
- Confirmar comportamiento real del API (incluyendo respuestas con `status 200` en fallos de negocio)

### Paso 2: Identificacion de endpoints
- Clasificar endpoints en dominio de autenticacion
- Definir prioridad de cobertura: registro y acceso
- Delimitar dependencias entre escenarios

### Paso 3: Definicion de casos de prueba
- Positivos:
  - Alta de usuario nuevo
  - Login con credenciales validas
- Negativos:
  - Alta de usuario duplicado
  - Login con password incorrecto

### Paso 4: Diseno de escenarios en Gherkin
- Implementar features en `src/test/resources/features`
- Mantener steps legibles y orientados a validacion de negocio
- Separar precondiciones en `Background`

### Paso 5: Implementacion en Karate
- Configurar base URL y headers en `src/test/java/karate-config.js`
- Crear `signup.feature` y `login.feature` con requests JSON
- Generar usuarios dinamicos con `src/test/resources/utils/user-generator.js`
- Externalizar credenciales base en `src/test/resources/data/users.json`
- Validar respuestas por `status`, token y mensajes de error/confirmacion

### Paso 6: Ejecucion de pruebas
- Orquestar la suite con `src/test/java/runners/TestRunner.java`
- Ejecutar con Maven en entorno `qa` por defecto
- Analizar fallos por escenario y tipo de validacion

### Paso 7: Generacion de reportes
- Revisar `target/karate-reports/karate-summary.html`
- Revisar detalle por feature para evidencia puntual
- Complementar con `target/surefire-reports` para integracion CI

## 4. Estructura del proyecto

Estructura alineada al repositorio actual:

```text
src/
  test/
    java/
      karate-config.js
      runners/
        TestRunner.java
    resources/
      features/
        signup.feature
        login.feature
      data/
        users.json
      utils/
        user-generator.js
AI_Protocol/
  AI_Workflow.md
README.md
conclusiones.md
```

Responsabilidades:
- `src/test/java`: configuracion global y runner
- `src/test/resources/features`: escenarios API en Gherkin
- `src/test/resources/data`: datos de entrada reutilizables
- `src/test/resources/utils`: funciones auxiliares y datos dinamicos

## 5. Estrategia de pruebas

### Tipos de pruebas
- **Positivas:** validan flujos exitosos de signup y login
- **Negativas:** validan mensajes funcionales para usuario existente y password incorrecto

### Validaciones de respuesta
- `status 200` segun comportamiento actual del API
- Mensajes de negocio esperados:
  - `Sign up successful`
  - `This user already exist`
  - `Wrong password`
- Presencia de `Auth_token` en login exitoso

### Manejo de datos dinamicos
- Username aleatorio por UUID para evitar colisiones
- Reutilizacion controlada del mismo usuario para casos negativos de duplicidad
- Separacion entre datos fijos (`users.json`) y datos generados (`user-generator.js`)

## 6. Integracion y ejecucion

### Como ejecutar pruebas desde consola

```bat
mvn clean test
mvn -Dtest=runners.TestRunner test
mvn test -Dkarate.env=qa
```

### Uso de Gradle o Maven
- **Maven:** herramienta activa y configurada en el proyecto
- **Gradle:** opcion referencial, no configurada en esta base

### Generacion de reportes
Salida de ejecucion:
- `target/karate-reports`: reportes funcionales HTML/JSON de Karate
- `target/surefire-reports`: resultados JUnit/Surefire para CI

## 7. Buenas practicas

- Reutilizar utilidades para evitar duplicidad de steps
- Mantener separados: features, datos y funciones auxiliares
- Escribir escenarios cortos, legibles y con un objetivo claro
- Validar contenido funcional ademas del status HTTP
- Mantener convenciones de nombres consistentes por endpoint
- Actualizar documentacion (`README.md` y `conclusiones.md`) con cada cambio relevante

## 8. Conclusion

El flujo actual permite una automatizacion robusta y mantenible para autenticacion REST en Demoblaze, con una estructura simple de escalar y facil de operar por el equipo QA.

La combinacion Karate + Java + Maven brinda ejecucion repetible y trazabilidad de resultados, mientras que el uso controlado de IA acelera la construccion de pruebas sin reemplazar la validacion tecnica experta.

Este AI Workflow queda alineado al proyecto vigente y sirve como guia operativa para evolucionar la cobertura de pruebas API en siguientes iteraciones.