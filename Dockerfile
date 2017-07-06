FROM ubuntu:16.04

MAINTAINER Tomohisa Kusano <siomiz@gmail.com>

COPY copyables /

ADD https://dl.google.com/linux/linux_signing_key.pub /tmp/
ADD https://launchpad.net/ubuntu/+archive/primary/+files/libgcrypt11_1.5.3-2ubuntu4.4_amd64.deb /tmp/

RUN apt-key add /tmp/linux_signing_key.pub \
	&& apt-get update \
	&& apt-get install -y \
	google-chrome-stable \
	chrome-remote-desktop \
	fonts-takao \
	pulseaudio \
	supervisor \
	x11vnc \
	fluxbox \
	&& dpkg -i /tmp/libgcrypt11_*.deb \
	&& apt-get clean \
	&& rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/* \
	&& addgroup chrome-remote-desktop \
	&& useradd -m -G chrome-remote-desktop,pulse-access chrome \
	&& ln -s /crdonly /usr/local/sbin/crdonly \
	&& ln -s /update /usr/local/sbin/update \
	&& mkdir -p /home/chrome/.config/chrome-remote-desktop \
	&& chown -R chrome:chrome /home/chrome/.config \
	&& mkdir -p /home/chrome/.fluxbox \
	&& echo $' \n\
		session.screen0.defaultDeco: NONE \n\
		session.screen0.toolbar.visible: NONE \n\
		session.screen0.fullMaximization: true \n\
		session.screen0.maxDisableResize: true \n\
		session.screen0.maxDisableMove: true \n\
	' >> /home/chrome/.fluxbox/init

VOLUME ["/home/chrome"]

EXPOSE 5900

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
