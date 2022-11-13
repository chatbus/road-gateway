FROM maven:3.8.6-eclipse-temurin-17-alpine AS build
WORKDIR /opt/src
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src src
RUN mvn package -Dmaven.test.skip=true spring-boot:repackage

FROM eclipse-temurin:17

LABEL Name="road-gateway Version=1.0.0-SNAPSHOT"
LABEL maintainer="Jiam Seo <jams7777@gmail.com>"

COPY --from=build /opt/src/target/road-gateway.jar /opt/app.jar

ENV SPRING_PROFILES_ACTIVE local

EXPOSE 8080

ENTRYPOINT ["java","-jar","/opt/app.jar"]