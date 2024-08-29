FROM cgr.dev/chainguard/go@sha256:f59ee941f033b3267531ec9b3543f87a2e5d0c680ed711bd6c01806bdc22f874 AS builder

WORKDIR /app
COPY . /app

RUN go mod tidy; \
    go build -o main .

FROM cgr.dev/chainguard/glibc-dynamic@sha256:09c74721beb055d94e49515381cc5118d85bae208e7ddefe1d28f6b355a1a6f5

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/docs docs

ENV ARANGO_HOST localhost
ENV ARANGO_USER root
ENV ARANGO_PASS rootpassword
ENV ARANGO_PORT 8529
ENV MS_PORT 8080

EXPOSE 8080

ENTRYPOINT [ "/app/main" ]
