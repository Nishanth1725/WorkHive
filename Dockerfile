# Stage 1: Build the WAR file using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the WAR file using Tomcat 10
FROM tomcat:10.1-jdk17
# Clear out default Tomcat junk
RUN rm -rf /usr/local/tomcat/webapps/*
# Copy the compiled WAR file from Stage 1 into Tomcat
# Naming it ROOT.war ensures your app loads on the main URL without a subpath
COPY --from=build /app/target/JobPortalWeb.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
