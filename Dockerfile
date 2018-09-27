FROM nvidia/cuda:7.0-runtime-centos7


## install utils
RUN yum install -y perl \
                   wget \
		   xauth \
		   xkeyboard-config \
		   tigervnc-server \
		   pciutils \
		   xterm \
		   expect \
		   xorg-x11-server-common  \
		   xorg-x11-server-Xorg \
		   xorg-x11-server-Xephyr  \
		   xorg-x11-server-utils \
		   xorg-x11-server-Xdmx 

## install dcv
RUN wget https://d1uj6qtbmh3dt5.cloudfront.net/server/nice-dcv-2017.1-5870-el7.tgz
RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/pcsc-lite-libs-1.8.8-7.el7.x86_64.rpm
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/d/dkms-2.6.1-1.el7.noarch.rpm

## localinstall pcsc-lite-libs
RUN yum install -y pcsc-lite-libs-1.8.8-7.el7.x86_64.rpm dkms-2.6.1-1.el7.noarch.rpm

## localinstall nice-dcv-server
RUN tar zxvf nice-dcv-2017.1-5870-el7.tgz && \
    cd nice-dcv-2017.1-5870-el7 && \
    yum install -y nice-dcv-server-2017.1.5870-1.el7.x86_64.rpm  \
                   nice-xdcv-2017.1.170-1.el7.x86_64.rpm  \
                   nice-dcv-gl-2017.1.366-1.el7.x86_64.rpm \
	           nice-dcv-gltest-2017.1.198-1.el7.x86_64.rpm

## add viewer user
RUN groupadd viewer && \
    useradd -m -r viewer  -g viewer
   
## remove download
RUN rm -rf /nice-dcv-2017.1-5870-el7.tgz  \
    /nice-dcv-2017.1-5870-el7  \
    /pcsc-lite-libs-1.8.8-7.el7.x86_64.rpm \
    /dkms-2.6.1-1.el7.noarch.rpm

## install xorg-x11-server-Xorg, xorg-x11-server-utils, xorg-x11-utils	
#RUN yum install -y xorg-x11-server-Xorg xorg-x11-server-utils xorg-x11-utils
	
RUN echo "default start vncserver ......... " > /vncserver.log

ADD ./xstartup /tmp/xstartup
ADD ./vncservers  /etc/sysconfig/vncservers
ADD ./license.lic /usr/share/dcv/license/license.lic
ADD ./dcv.conf /etc/dcv/dcv.conf
ADD ./init_commond.exp /init_commond.exp
ADD ./start.sh /start.sh

RUN chmod +x /start.sh
RUN chmod +x /init_commond.exp
RUN chmod +x /tmp/xstartup

EXPOSE 5901 5902 5903 5904 5905  8443

ENTRYPOINT  ["/start.sh"]
CMD ["/usr/sbin/init"]
