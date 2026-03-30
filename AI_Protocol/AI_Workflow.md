# AI Workflow - Proyecto de Automatizacion QA API REST con Karate DSL

## 1. Introduccion

### Objetivo del proyecto
Establecer un framework de automatizacion de pruebas para servicios REST que permita validar de forma continua la calidad funcional y contractual de la API objetivo, reduciendo defectos en integracion y mejorando el tiempo de retroalimentacion al equipo de desarrollo.

### Alcance
Este workflow aplica al proyecto actual de pruebas API con Karate para los dominios funcionales de cuenta y productos, incluyendo los endpoints:
- `POST /api/createAccount`
- `PUT /api/updateAccount`
- `DELETE /api/deleteAccount`
- `GET /api/productsList`

El alcance cubre:
- Diseno y automatizacion de escenarios funcionales
- Validaciones de contrato (schema y campos clave)
- Manejo de datos dinamicos para ejecuciones repetibles
- Ejecucion desde runner centralizado y generacion de reportes

### Tecnologias utilizadas
- **Karate DSL (1.5.0):** definicion de escenarios API en Gherkin y validaciones declarativas
- **Java (17):** soporte de ejecucion y runner JUnit 5
- **Maven:** gestion de dependencias, build y ejecucion de pruebas

## 2. Metodologia de trabajo

### Enfoque de automatizacion
Se utiliza un enfoque **API-first, modular y orientado a riesgo**, priorizando endpoints criticos y asegurando que cada prueba sea independiente, legible y mantenible.

Principios del enfoque:
- Casos de prueba alineados al contrato REST y reglas de negocio
- Escenarios por comportamiento esperado, no por detalle tecnico
- Reutilizacion de pasos comunes para minimizar duplicidad
- Datos desacoplados de la logica de prueba

### Uso de IA (Copilot) en el flujo de trabajo
Copilot se integra como acelerador de productividad en tareas controladas:
- Propuesta inicial de escenarios positivos y negativos
- Sugerencias de aserciones `match` y estructuras de schema
- Refactor de codigo repetido hacia `features/common` y `utils`
- Redaccion tecnica de documentacion y convenciones

Control de calidad:
- Toda contribucion generada por IA requiere revision de QA Automation
- No se acepta codigo sin validacion funcional local
- Se registran ajustes manuales para trazabilidad

### Buenas practicas operativas
- Definir criterios de aceptacion antes de automatizar
- Mantener checklist de revision por Pull Request
- Ejecutar smoke suite antes de integrar cambios
- Documentar decisiones tecnicas del framework

## 3. Flujo de desarrollo (AI Workflow)

### Paso 1: Analisis del servicio REST
- Revisar contrato del endpoint: metodo, path, headers, payload y respuestas
- Identificar precondiciones, datos requeridos y dependencias
- Definir criterios de exito y reglas de error esperadas

### Paso 2: Identificacion de endpoints
- Agrupar endpoints por dominio (`account`, `products`)
- Clasificar criticidad (alta, media, baja)
- Definir prioridad de automatizacion (smoke, regresion)

### Paso 3: Definicion de casos de prueba
- Diseñar casos positivos (flujo valido de negocio)
- Diseñar casos negativos (payload invalido, campos faltantes, metodo incorrecto)
- Incluir casos de borde (valores limite, formato invalido)

### Paso 4: Diseno de escenarios en Gherkin
- Crear features legibles en `src/test/resources/features`
- Usar `Background` para configuracion comun
- Mantener escenarios cortos, independientes y orientados a resultado

### Paso 5: Implementacion en Karate
- Externalizar payloads base en `src/test/resources/data`
- Implementar utilidades de datos dinamicos en `src/test/resources/utils`
- Reutilizar acciones comunes con `call read(...)` y tags en `features/common`
- Validar status, body y contrato con `match`

### Paso 6: Ejecucion de pruebas
- Ejecutar la suite desde runner JUnit en `src/test/java/com/softka/runner/ApiTestRunner.java`
- Seleccionar entorno con `karate-config.js` (`dev` o `qa`)
- Analizar fallos por escenario y endpoint impactado

### Paso 7: Generacion de reportes
- Revisar reporte consolidado en `target/karate-reports/karate-summary.html`
- Revisar detalle por feature para evidencia de defectos
- Publicar resultados en pipeline y registrar hallazgos

## 4. Estructura del proyecto

Estructura recomendada para Karate en este proyecto:

```text
src/
  test/
    java/
      karate-config.js
      com/softka/runners/
        ApiTestRunner.java
    resources/
      features/
        account/
        products/
        common/
      data/
        account/
        schemas/
      utils/
```

Relacion con los componentes solicitados:
- `src/test/java`: configuracion global y **runners**
- `src/test/resources`: artefactos de pruebas
- `features`: escenarios funcionales por dominio
- `runners`: orquestacion de ejecucion de suites
- `utils`: logica utilitaria para datos y reutilizacion

## 5. Estrategia de pruebas

### Tipos de pruebas
- **Positivas:** validan respuestas esperadas con datos correctos
- **Negativas:** validan robustez ante datos invalidos y errores funcionales

### Validaciones de respuesta
- Codigo HTTP esperado por operacion
- Codigo funcional de respuesta (`responseCode`)
- Mensaje funcional esperado (`created`, `updated`, `deleted`)
- Contrato JSON con schema para listas de productos

### Manejo de datos dinamicos
- Generacion de correo unico por ejecucion para evitar colisiones
- Encadenamiento de datos entre escenarios (create -> update/delete)
- Limpieza de datos para idempotencia de la suite

## 6. Integracion y ejecucion

### Como ejecutar pruebas desde consola

```bat
mvn clean test
mvn test -Dkarate.env=qa
```

### Uso de Gradle o Maven
- **Maven:** herramienta activa del proyecto (configurada en `pom.xml`)
- **Gradle:** opcion valida para otros contextos, no adoptada en este repositorio

### Generacion de reportes
Al finalizar la ejecucion:
- Karate genera reportes HTML y JSON en `target/karate-reports`
- Surefire genera evidencia XML/TXT en `target/surefire-reports`
- Estos artefactos se usan como evidencia en CI/CD

## 7. Buenas practicas

- Reutilizar flujos comunes en `features/common` para evitar duplicidad
- Separar datos de prueba en `data` y logica en `features`
- Mantener escenarios legibles y con un solo objetivo de validacion
- Evitar dependencias ocultas entre pruebas
- Garantizar limpieza de datos para estabilidad en regresion
- Versionar cambios con enfoque en impacto de calidad

## 8. Conclusion

Este enfoque permite construir una automatizacion API robusta, mantenible y escalable para pruebas REST con Karate DSL en un contexto real de QA.

La combinacion de Karate, Java y Maven ofrece una base tecnica solida para integrarse a pipelines de entrega continua, mientras que el uso controlado de IA acelera la construccion de escenarios y la estandarizacion del framework sin perder calidad tecnica.

Como resultado, el equipo obtiene mayor cobertura en menos tiempo, defectos detectados de forma temprana y reportes accionables para desarrollo y negocio.
