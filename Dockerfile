FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git build-essential wget \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/AlexeyAB/darknet.git && cd darknet \
    && make \
    && cp darknet /usr/local/bin \
    && cp -r cfg /usr/local/bin/ \
    && cp -r data /usr/local/bin/ \
    && cd .. && rm -rf darknet

WORKDIR /usr/local/bin

RUN wget https://pjreddie.com/media/files/yolov3.weights

RUN echo '#!/bin/bash\n\
wget --no-check-certificate -U "Mozilla/5.0" -O test.jpg $1\n\
./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights test.jpg -dont_show -ext_output' > run.sh && chmod +x run.sh

ENTRYPOINT ["./run.sh"]