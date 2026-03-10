# Build stage
FROM golang:1.26-alpine AS build
RUN apk add --no-cache git
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /bin/agenthub-server ./cmd/agenthub-server \
 && CGO_ENABLED=0 go build -o /bin/ah ./cmd/ah

# Runtime stage
FROM alpine:3.21
RUN apk add --no-cache git
COPY --from=build /bin/agenthub-server /bin/ah /usr/local/bin/
VOLUME /data
ENTRYPOINT ["agenthub-server"]
CMD ["--data", "/data"]
