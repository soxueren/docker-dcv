# docker-vnc-dcv-nvidia-centos
基于nvidia/cuda:8.0-runtime-centos7镜像制作集tigervnc-server、nice-dcv-2017等软件的docker
- 默认安装 perl wget xauth xkeyboard-config  pciutils xterm expect工具
- 交互shell用到expect，请参考相关教程
- nice-dcv-2017使用2018年10月到期的license.lic
- vncviewer进入默认启用xterm
- dcv服务启用，需要nvidia-docker run启动，
## build容器
git clone https://github.com/soxueren/docker-vnc-dcv-nvidia-centos.git
cd docker-vnc-dcv-nvidia-centos
docker build -t docker-vnc-dcv .
或者docker pull soxueren/docker-vnc-dcv
## 运行容器
nvidia-docker run -it   --rm --name=dcv  --privileged=true -p 5901:5901  -p 8443:8443   -v /usr/lib:/usr/lib64/nvidia docker-vnc-dcv
增加增加nvidia-driver库到容器内
-v /usr/lib:/usr/lib64/nvidia  
'''
#配置nvidia-driver搜索路径
echo  /usr/lib64/nvidia > /etc/ld.so.conf.d/nice-dcv-2017.1-5870-el7.x86_64.conf && ldconfig
'''
