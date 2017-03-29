FROM alpine:3.5

MAINTAINER Tit Petric <black@scene-si.org>

ARG GITVERSION=development
ENV GITVERSION ${GITVERSION}

ADD sonyflake /sonyflake

ENTRYPOINT ["/sonyflake"]
