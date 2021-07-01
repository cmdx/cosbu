FROM ubuntu
LABEL maintainer="Craig Maddux, craig.maddux@us.ibm.com"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
RUN apt-get install -y curl wget tar git vim iputils-ping iputils-tracepath
RUN apt install rclone -y
WORKDIR /cosbu
COPY cosbu.sh ./
CMD ["/cosbu/cosbu.sh", "check"]