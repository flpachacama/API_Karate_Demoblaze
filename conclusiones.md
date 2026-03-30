# Conclusiones - QA Automation Demoblaze API

## Hallazgos
- Los endpoints de `signup` y `login` responden con `status 200` tanto en flujos exitosos como en errores funcionales.
- El flujo exitoso de login retorna token de autenticacion en `Auth_token`.
- La validacion de usuario duplicado y password incorrecto depende del mensaje de negocio en el body.

## Problemas encontrados
- El API no diferencia errores funcionales con codigos HTTP 4xx/5xx.
- Los mensajes de error pueden variar en formato (texto o campo estructurado), por lo que se requiere normalizacion de respuesta.
- Las pruebas dependen de conectividad externa y disponibilidad del sitio Demoblaze.

## Recomendaciones
- Mantener validaciones por contenido de mensaje ademas de status code.
- Centralizar funciones de parsing de respuesta para manejar distintos formatos del body.
- Ejecutar las pruebas en pipeline con reintentos controlados ante fallos de red transitorios.
- Agregar suite de regresion negativa extendida (campos vacios, formato invalido, payload malformado).
