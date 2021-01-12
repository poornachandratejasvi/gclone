FROM  golang:alpine AS builder
ENV CGO_ENABLED=0
ENV GO111MODULE=on

RUN set -xe && \
    apk add --no-cache --virtual .build-deps \
        build-base \
        tzdata \
        git \
        upx && \
    cd /root && \
    git clone https://github.com/donwa/gclone.git && \
    cd /root/gclone && \
    sed -i '/"gclone sa file:"/d' ./backend/drive/drive.go && \
    LDFLAGS="-s -w" && \
    go build -ldflags "$LDFLAGS" -v -o /usr/bin/gclone && \
    upx --lzma /usr/bin/gclone && \
    apk del .build-deps 

FROM alpine:3.12

VOLUME ["/var/gclone"]
RUN apk add --no-cache su-exec
RUN apk add --update tzdata
RUN rm -rf /var/cache/apk/*
COPY --from=builder /usr/bin/gclone /usr/bin/gclone
COPY ./entrypoint.sh /bin/entrypoint.sh
COPY ./gclone_start.sh /bin/gclone_start.sh

ENV PUID=0 PGID=0 HOME=/var/gclone
RUN mkdir -p /var/gclone/.config/rclone
RUN chmod 777 /bin/entrypoint.sh
RUN chmod 777 /bin/gclone_start.sh


#ENTRYPOINT ["/bin/entrypoint.sh", "/usr/bin/gclone"]
ENTRYPOINT ["/bin/entrypoint.sh"]
