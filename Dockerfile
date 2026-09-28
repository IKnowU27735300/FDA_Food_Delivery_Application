# Step 1: Build the WAR package using Maven & OpenJDK 8
FROM maven:3.8.8-eclipse-temurin-8 AS build
WORKDIR /app

# Copy pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the WAR file (packaged as fashion-store.war)
RUN mvn clean package -DskipTests

# Step 2: Run application inside Apache Tomcat 9
FROM tomcat:9.0-jdk8-corretto

# Clear default Tomcat demo webapps and disable shutdown port (prevents health check warnings)
RUN rm -rf /usr/local/tomcat/webapps/* && \
    sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Copy the built WAR as ROOT.war so it serves directly from /
COPY --from=build /app/target/fashion-store.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
