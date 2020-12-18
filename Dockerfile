FROM golang:1.14.6-alpine AS build

ARG TAG
ARG BUILD
RUN apk add -U git make curl build-base
RUN go get github.com/Masterminds/glide
ENV APP interlock
ENV REPO tmassey/$APP
WORKDIR /go/src/github.com/$REPO
COPY . /go/src/github.com/$REPO
RUN make TAG=$TAG BUILD=$BUILD build

FROM alpine:latest
RUN apk add --no-cache -U iptables
WORKDIR /bin
ENV APP interlock
ENV REPO tmassey/$APP
COPY --from=build /go/src/github.com/${REPO}/cmd/${APP}/${APP} /bin/${APP}
EXPOSE 8080
LABEL interlock.app main
ENTRYPOINT ["/bin/interlock"]
CMD ["-h"]
