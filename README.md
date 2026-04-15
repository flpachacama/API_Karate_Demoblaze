# API Karate Demoblaze

Proyecto de automatizacion de pruebas API REST con Karate DSL para validar los servicios de signup y login de Demoblaze.

## Descripcion del proyecto
Este framework automatiza los siguientes escenarios:
- Crear un nuevo usuario en signup
- Intentar crear un usuario ya existente
- Login con usuario y password correcto
- Login con usuario y password incorrecto
- Login con usuario no registrado

El proyecto aplica una estrategia data-driven declarativa:
- `Scenario Outline` + `Examples` con datos externos JSON
- Datos separados en `src/test/resources/data`
- JS solo para generar usernames unicos cuando es necesario

## Requisitos
- Java 17+
- Maven 3.8+
- Conexion a internet (consumo de APIs publicas de Demoblaze)

## Instalacion
```bat
git clone https://github.com/flpachacama/API_Karate_Demoblaze.git
cd API_Karate_Demoblaze
mvn -version
```

## Ejecucion paso a paso
1. Ejecutar toda la suite:
```bat
mvn clean test
```

2. Ejecutar solo el runner principal:
```bat
mvn -Dtest=runners.TestRunner test
```

3. Ejecutar con entorno explicito:
```bat
mvn test -Dkarate.env=qa
```

## Comandos Maven o Gradle
### Maven
```bat
mvn clean test
mvn -Dtest=runners.TestRunner test
```

### Gradle (opcional, no configurado por defecto)
```bat
gradle test
```

## Estructura principal
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
        helpers/
          create-user.feature
      data/
        users.json
        signup-data.json
        login-data.json
      utils/
        user-generator.js
AI_Protocol/
  AI_Workflow.md
  AI_Workflow_v2.md
conclusiones.md
```

## Casos y validaciones de negocio
- Signup exitoso: `Sign up successful`
- Signup duplicado: `This user already exist`
- Login password incorrecto: `Wrong password`
- Login usuario no registrado: `User does not exist`
- Login exitoso: respuesta contiene `Auth_token:`

## Reportes
Al finalizar la ejecucion, Karate y Surefire generan evidencias en:
- `target/karate-reports`
- `target/surefire-reports`