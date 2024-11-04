# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Ensure the directory exists
RUN mkdir -p /app

# Set the working directory in the container
WORKDIR /app

# Copy the application's jar file into the container at /app
COPY target/your-app-1.0-SNAPSHOT.jar /app/app.jar

# Run the application
ENTRYPOINT ["java","-jar","/app/app.jar"]
~                                         
