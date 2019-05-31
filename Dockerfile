FROM golang:1.12.5-alpine3.9 AS downloader

RUN apk add --no-cache ca-certificates
RUN apk add --no-cache git gcc musl-dev

COPY  . /usr/local/go/src/github.com/eatigo/migrate
WORKDIR /usr/local/go/src/github.com/eatigo/migrate/cli/migrate/

ENV GO111MODULE=on
ENV DATABASES="postgres mysql redshift cassandra spanner cockroachdb clickhouse mongodb mssql"
ENV SOURCES="file go_bindata github aws_s3 google_cloud_storage godoc_vfs gitlab"

RUN go build -tags "$DATABASES $SOURCES" .

FROM alpine:3.9

RUN apk add --no-cache ca-certificates

COPY --from=downloader /usr/local/go/src/github.com/eatigo/migrate/cli/migrate/migrate /migrate
RUN chmod u+x migrate

ENTRYPOINT ["/migrate"]
CMD ["--help"] 
