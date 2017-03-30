FROM alpine:3.5

MAINTAINER Tit Petric <black@scene-si.org>

ARG GITVERSION=development
ARG GITTAG=development
ENV GITVERSION ${GITVERSION} GITTAG ${GITTAG}

ADD ./build/sonyflake /sonyflake
ENTRYPOINT ["/sonyflake"]
