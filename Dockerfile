FROM golang:1.22.2-alpine3.19

WORKDIR /app

COPY cmd /app/cmd

COPY lib /app/lib

COPY go.mod /app

COPY main.go /app

RUN go mod tidy

RUN go build -o build/fizzbuzz

COPY templates /app/templates

CMD ["./build/fizzbuzz", "serve"]
