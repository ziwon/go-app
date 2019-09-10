# step 1
FROM golang:1.12.4-alpine3.9 as builder

RUN apk add --update --no-cache ca-certificates git

RUN mkdir /app
WORKDIR /app
COPY go.mod .
COPY go.sum .

RUN go mod download
COPY . .

RUN CGO_ENABLED=0 go build -o /go/bin/go-app

# step 2
FROM scratch
COPY --from=builder /go/bin/go-app /go/bin/go-app
ENTRYPOINT ["/go/bin/go-app"]
