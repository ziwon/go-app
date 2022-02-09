# step 1
FROM --platform=$BUILDPLATFORM golang:1.17-alpine AS builder
ENV GO111MODULE=auto
ARG TARGETOS TARGETARCH
RUN apk add --update --no-cache ca-certificates git
WORKDIR /app
RUN --mount=target=. \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg \
    GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /out/app .

# step 2
FROM scratch
COPY --from=builder /out/app /bin
ENTRYPOINT ["app"]
