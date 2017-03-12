FROM alpine:3.5

MAINTAINER Tit Petric <black@scene-si.org>

ADD sonyflake /sonyflake

ENTRYPOINT ["/sonyflake"]
