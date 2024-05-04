FROM amd64/golang:1.22.2-alpine3.19 as build

WORKDIR /app

COPY cmd /app/cmd

COPY lib /app/lib

COPY go.mod /app

COPY main.go /app

RUN go mod tidy

RUN go build -o build/fizzbuzz

FROM gcr.io/distroless/nodejs22-debian12:debug-nonroot

WORKDIR /app

COPY --from=build /app/build /app/build

COPY templates /app/templates

COPY run.js package.json /app

CMD ["run.js"]
