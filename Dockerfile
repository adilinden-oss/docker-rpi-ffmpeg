FROM balenalib/raspberry-pi-debian:stretch as builder

RUN apt-get update -qy && apt-get -qy install \
        build-essential git nasm \
        libomxil-bellagio-dev

WORKDIR /root
RUN git clone -b n4.1.2 --single-branch https://github.com/FFmpeg/FFmpeg.git 

WORKDIR /root/FFmpeg
RUN ./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree
RUN make -j$(nproc)
RUN make install

###

FROM balenalib/raspberry-pi-debian:stretch

RUN apt-get update && apt-get install -qy libraspberrypi-bin libomxil-bellagio0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root
COPY --from=builder /usr/local/bin/ /usr/local/bin
COPY --from=builder /usr/local/lib/ /usr/local/lib
COPY --from=builder /usr/local/share/ffmpeg/ /usr/local/share/ffmpeg
COPY --from=builder /usr/local/share/man/ /usr/local/share/man

CMD ["/bin/bash"]
