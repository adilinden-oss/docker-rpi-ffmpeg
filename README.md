# About

## What is this for?

To run `ffmpeg` on [Raspberry Pi](https://www.raspberrypi.org/) with the OpenMAX H.264 GPU acceleration enabled.

I built this to stream the webcam attached to my [OctoPi](https://octoprint.org/) to [YouTube Live](https://www.youtube.com/channel/UC4R8DWoMoI7CAwX8_LjQHig). There is nothing more excting then watching a live stream of a 3D printer laying down lines of plastic, right?

The [Dockerfile](https://github.com/adilinden-oss/docker-rpi-ffmpeg/blob/master/Dockerfile) is on GitHub [adilinden-oss/docker-rpi-ffmpeg](https://github.com/adilinden-oss/docker-rpi-ffmpeg).

## Prerequisities

A Raspberry Pi with docker installed.

	curl -sSL https://get.docker.com | sh
	sudo usermod pi -aG docker
	sudo reboot

## Building

Build it from Github

    git clone https://github.com/adilinden-oss/docker-rpi-ffmpeg.git
    cd docker-rpi-ffmpeg
    docker build -t adilinden/rpi-ffmpeg .

Or, get it from Docker Hub

    docker pull adilinden/rpi-ffmpeg

## Usage

To use simply execute `ffmpeg`.

    docker run -it --rm --privileged adilinden/rpi-ffmpeg ffmpeg \
	    -re -f mjpeg -framerate 5 -i http://<IP of OctoPi>:8080/?action=stream \
	    -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -acodec aac -ab 128k \
	    -strict experimental -vcodec h264 -pix_fmt yuv420p -g 10 -vb 700k -framerate 5 \
	    -f flv rtmp://a.rtmp.youtube.com/live2/<YouTube Stream ID>
