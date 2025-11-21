# Build stage
FROM golang:1.24.0-alpine AS builder

WORKDIR /app

# Copy go mod files if they exist
COPY go.mod go.sum* ./
RUN go mod download || true

# Copy source code
COPY *.go ./

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /app/parcel-tracker .

# Final stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates sqlite

WORKDIR /root/

# Copy the binary from builder
COPY --from=builder /app/parcel-tracker .

# Run the application
CMD ["./parcel-tracker"]

