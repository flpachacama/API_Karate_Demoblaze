# Conclusiones - QA Automation API REST Demoblaze

## 1. Resumen del ejercicio
Se implemento un proyecto de automatizacion de pruebas API con Karate DSL para los servicios de autenticacion de Demoblaze (`/signup` y `/login`).

La suite cubre cuatro escenarios clave del flujo de negocio:
- Registro exitoso de usuario nuevo.
- Registro de usuario duplicado.
- Login con credenciales correctas.
- Login con credenciales incorrectas.

Durante la ejecucion se validaron solicitudes `POST` con payload JSON, codigos de estado HTTP, mensajes funcionales de respuesta y presencia de token en login exitoso. Tambien se aplico generacion de usuarios dinamicos para evitar colisiones entre ejecuciones.

## 2. Hallazgos importantes
- **Comportamiento en signup:** el alta de usuario puede retornar respuesta vacia o mensaje de confirmacion, manteniendo `status 200`.
- **Usuarios duplicados:** la validacion de duplicidad se confirma por mensaje funcional (`This user already exist`) y no por codigo HTTP de error.
- **Login exitoso:** retorna token de autenticacion en formato texto (`Auth_token: <valor>`), no siempre como objeto JSON estructurado.
- **Login fallido:** credenciales invalidas responden con mensaje de negocio (`Wrong password`) y `status 200`.
- **Inconsistencias no estandar:** el API mezcla formatos de respuesta (texto plano, string con comillas o estructura variable), lo que exige normalizacion de parsing en pruebas.

## 3. Problemas encontrados
- Falta de semantica HTTP para errores funcionales (no se usan 4xx/5xx en casos de negocio fallidos).
- Contrato de respuesta poco consistente entre escenarios equivalentes.
- Mensajes funcionales dependientes de texto exacto, con riesgo de fragilidad ante cambios menores.
- Dependencia de disponibilidad externa del servicio para la estabilidad de ejecuciones automatizadas.

## 4. Buenas practicas aplicadas
- Uso de datos dinamicos para generar usuarios unicos y reducir conflictos entre corridas.
- Separacion de escenarios por comportamiento funcional en features independientes (`signup` y `login`).
- Validaciones claras de estado y contenido funcional, adaptadas al comportamiento real del API.
- Estructura del proyecto organizada por capas (`features`, `data`, `utils`, `runner`) para facilitar mantenimiento y escalabilidad.

## 5. Recomendaciones

### Mejoras para el API
- Implementar codigos HTTP alineados a estandares REST (por ejemplo, `201`, `400`, `401`, `409`).
- Unificar el contrato de respuesta en formato JSON para exitos y errores.
- Estandarizar mensajes y catalogo de errores con codigos funcionales internos.

### Mejoras para pruebas
- Extender cobertura negativa con casos de campos vacios, formatos invalidos y payload incompleto.
- Incorporar enfoque data-driven para variaciones de usuarios y credenciales.
- Agregar ejecucion en pipeline CI con politicas de reintento controlado y reporte historico.
- Mantener trazabilidad entre escenarios, resultados y hallazgos en reportes de Karate.

## 6. Conclusion final
La automatizacion implementada confirma que el flujo de autenticacion principal de Demoblaze puede validarse de forma repetible y trazable con Karate DSL, reduciendo esfuerzo manual y mejorando la deteccion temprana de defectos.

Karate DSL aporta rapidez de implementacion, legibilidad en Gherkin e integracion efectiva con Maven y reportes automaticos. El uso de IA (Copilot) acelero la construccion inicial de escenarios y la estandarizacion documental, manteniendo la revision tecnica de QA como control final de calidad.
