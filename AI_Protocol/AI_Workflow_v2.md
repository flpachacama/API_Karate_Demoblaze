# AI Workflow - Proyecto QA Automation REST Demoblaze con Karate DSL

## 1. Introducción

### Objetivo del proyecto

Definir y ejecutar un flujo de automatización QA para los servicios REST de autenticación de Demoblaze, incorporando prácticas avanzadas como **parametrización declarativa (CSV/JSON)** y ampliación de cobertura negativa.

### Alcance

Endpoints cubiertos:

* `POST /signup`
* `POST /login`

Cobertura funcional:

* Crear usuario nuevo
* Crear usuario existente
* Login exitoso
* Login con password incorrecto
* **Login con usuario no registrado (nuevo agregado)**

Incluye además:

* Parametrización declarativa con archivos externos (CSV/JSON)
* Reducción de lógica programática innecesaria (JS)
* Validaciones robustas de negocio

---

## 2. Metodología de trabajo

### Enfoque de automatización

Se evoluciona hacia un enfoque **data-driven declarativo**, donde:

* Los datos viven fuera del código (CSV/JSON)
* Los escenarios usan `Scenario Outline`
* Se minimiza lógica JS innecesaria

Principios:

* Separación clara: lógica vs datos
* Escenarios reutilizables
* Alta legibilidad (Gherkin puro)

---

## 3. Flujo de desarrollo (AI Workflow Mejorado)

### Paso 1: Análisis del servicio REST

- Revisar contrato de `signup` y `login` (payload y formato de respuesta)
- Identificar criterios de exito y errores funcionales esperados
- Confirmar comportamiento real del API (incluyendo respuestas con `status 200` en fallos de negocio)

---

### Paso 2: Identificación de endpoints

- Clasificar endpoints en dominio de autenticacion
- Definir prioridad de cobertura: registro y acceso
- Delimitar dependencias entre escenarios

---

### Paso 3: Definición de casos de prueba

#### Positivos:

* Alta de usuario nuevo
* Login con credenciales válidas

#### Negativos:

* Alta de usuario duplicado
* Login con password incorrecto
* **Login con usuario no registrado (nuevo caso obligatorio)**

---

### Paso 4: Diseño de escenarios en Gherkin (MEJORADO)

#### Nuevo estándar obligatorio:

* Uso de `Scenario Outline`
* Uso de `Examples` con:

  * CSV o JSON
* Eliminación de parametrización manual con JS cuando no sea necesaria

#### Ejemplo esperado:

```gherkin
Scenario Outline: Login con diferentes tipos de credenciales
  Given url baseUrl + '/login'
  And request { username: "<username>", password: "<password>" }
  When method POST
  Then status 200
  And match response.errorMessage contains "<message>"

Examples:
| username        | password     | message              |
| user_valido     | pass_valido  | Auth_token           |
| user_valido     | pass_malo    | Wrong password       |
| user_inexistente| pass_cualquiera | User does not exist |
```

---

### Paso 5: Implementación en Karate

#### Cambios clave:

**Incorporar data-driven testing**

* Crear:

  * `data/login-data.json` o `login-data.csv`
  * `data/signup-data.json`

**Eliminar sobreuso de JS**

* Mantener `user-generator.js` SOLO para:

  * Generación de usuarios únicos en signup
* NO usar JS para iterar escenarios

**Uso de `read()` en Karate**

```gherkin
* def users = read('classpath:data/login-data.json')
```

#### Estructura sugerida:

```text
data/
  login-data.json
  signup-data.json
```

Ejemplo JSON:

```json
[
  {
    "username": "user_valido",
    "password": "pass_valido",
    "expected": "Auth_token"
  },
  {
    "username": "user_no_registrado",
    "password": "1234",
    "expected": "User does not exist"
  }
]
```

---

### Paso 6: Ejecución de pruebas

- Orquestar la suite con `src/test/java/runners/TestRunner.java`
- Ejecutar con Maven en entorno `qa` por defecto
- Analizar fallos por escenario y tipo de validacion

---

### Paso 7: Generación de reportes

- Revisar `target/karate-reports/karate-summary.html`
- Revisar detalle por feature para evidencia puntual
- Complementar con `target/surefire-reports` para integracion CI

---

## 4. Estrategia de pruebas (ACTUALIZADO)

### Tipos de pruebas

#### Positivas:

* Registro exitoso
* Login exitoso

#### Negativas:

* Usuario duplicado
* Password incorrecto
* **Usuario no registrado (nuevo obligatorio)**

---

### Validaciones de respuesta

Mensajes esperados:

* `Sign up successful`
* `This user already exist`
* `Wrong password`
* **`User does not exist`**

---

### Manejo de datos

#### Antes:

* Datos dinámicos + JS

#### Ahora:

* Datos declarativos (principal)
* JS solo para generación dinámica necesaria

#### Estrategia final:

| Tipo de dato | Uso                           |
| ------------ | ----------------------------- |
| JSON/CSV     | Escenarios (login/signup)     |
| JS           | Generación de usuarios únicos |

---

## 5. Buenas prácticas reforzadas

* Usar `Scenario Outline` siempre que haya variación de datos
* Evitar lógica en JS si Karate puede resolverlo declarativamente
* Centralizar datos en `/data`
* Mantener features limpias y legibles
* Cada escenario debe validar comportamiento, no implementación
* Agregar casos negativos faltantes en cada endpoint

---

## 6. Evolución del AI Workflow

### Antes:

* Parametrización programática (JS)
* Cobertura incompleta de negativos

### Ahora:

* Parametrización declarativa (CSV/JSON)
* Cobertura completa (incluye usuario no registrado)
* Mejor mantenibilidad
* Mayor alineación con buenas prácticas de Karate

---

## 7. Conclusión

La mejora del workflow permite:

* Mayor escalabilidad de pruebas
* Reducción de complejidad técnica
* Mayor claridad en escenarios
* Mejor alineación con estándares QA modernos

El uso combinado de:

* Karate DSL declarativo
* Data-driven testing
* Uso controlado de IA

garantiza un framework robusto, mantenible y preparado para crecimiento.

---
