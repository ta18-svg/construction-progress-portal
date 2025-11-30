FROM eclipse-temurin:17-jre

WORKDIR /app

COPY construction-progress-portal.jar app.jar

EXPOSE 8080

ENV SPRING_PROFILES_ACTIVE=prod

ENTRYPOINT ["java", "-jar", "app.jar"]