FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app
COPY src/Main.java ./src/Main.java
RUN javac -d out src/Main.java

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /app/out ./out
ENV PORT=8080
EXPOSE 8080
USER 10001
ENTRYPOINT ["java", "-cp", "out", "Main"]
