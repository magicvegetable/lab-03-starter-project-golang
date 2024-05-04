FROM amd64/golang:1.22.2-alpine3.19 as build

WORKDIR /app

COPY cmd /app/cmd

COPY lib /app/lib

COPY go.mod /app

COPY main.go /app

RUN go mod tidy

RUN go build -o build/fizzbuzz

FROM openjdk:23-ea-17-jdk-bullseye as java-build

WORKDIR /app

COPY run.java /app

RUN javac --release @JAVA_RELEASE@ run.java

RUN jar cfe main.jar Main Main.class

FROM @JAVA_IMAGE@

WORKDIR /app

COPY --from=build /app/build /app/build

COPY --from=java-build /app/main.jar /app

COPY templates /app/templates

CMD ["main.jar"]

