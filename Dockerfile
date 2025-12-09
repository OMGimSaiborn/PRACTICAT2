# Etapa 1: construir el JAR con Maven y Java 17
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copiamos definición de proyecto y código
COPY pom.xml .
COPY src ./src

# Construimos el JAR sin tests
RUN mvn clean package -DskipTests

# Etapa 2: imagen final ligera solo con el JAR
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copiamos el JAR desde la etapa de build
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Exponemos el puerto interno
EXPOSE 8080

# Render suele pasar PORT como variable de entorno,
# y tu app ya tiene server.port=${PORT:8080}, así que
# solo arrancamos normalmente:
ENTRYPOINT ["java", "-jar", "app.jar"]
