# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Ensure the directory exists and copy the JAR file into the container at /app
RUN mkdir -p /app
COPY target/your-app-1.0-SNAPSHOT.jar /app/app.jar

# Run the application
ENTRYPOINT ["java","-jar","/app/app.jar"]

