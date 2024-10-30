# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application's jar file into the container at /app
COPY target/your-app.jar app.jar

# Run the application
ENTRYPOINT ["java","-jar","/app.jar"]
