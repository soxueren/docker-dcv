# docker-vnc-dcv-nvidia-centos
基于nvidia/cuda:8.0-runtime-centos7镜像制作集tigervnc-server、nice-dcv-2017等软件的docker
- 默认安装 perl wget xauth xkeyboard-config  pciutils xterm expect工具
- 交互shell用到expect，请参考相关教程
- nice-dcv-2017使用2018年10月到期的license.lic
- vncviewer进入默认启用xterm
- dcv服务启用，需要nvidia-docker run启动，并且配置nvidia-driver库到容器内映射
