FROM alpine:latest
LABEL maintainer="Jan Soendermann <jan.soendermann+git@gmail.com>"

RUN apk add --update bash curl && rm -rf /var/cache/apk/*

WORKDIR /scripts
ADD entrypoint.sh .
RUN chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]