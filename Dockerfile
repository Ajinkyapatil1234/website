FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/your-app-1.0-SNAPSHOT.jar /app/app.jar
CMD ["sh", "-c", "java -cp app.jar com.example.MainClass && tail -f /dev/null"]


                                      
