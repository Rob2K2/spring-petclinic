FROM openjdk:8-jre-alpine

COPY target/spring-petclinic.jar /app/

EXPOSE 8080

CMD java -jar /app/spring-petclinic.jar 