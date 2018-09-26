# docker-dcv-vnc from nvidia-centos base image
基于nvidia/cuda:7.0-runtime-centos7镜像制作包括tigervnc-server、nice-dcv-2017的docker镜像
- 默认安装 perl wget xauth xkeyboard-config  pciutils xterm expect工具
- 交互shell用到expect，请参考相关教程
- nice-dcv-2017使用2018年10月到期的license.lic
- vnc默认启用 :1(5901端口)，vncviewer进入默认启用xterm
- 启用dcv，需要nvidia-driver及nvidia-docker，详情参见[nvidia-docker](https://devblogs.nvidia.com/nvidia-docker-gpu-server-application-deployment-made-easy/)
## build容器
```
git clone https://github.com/soxueren/docker-dcv.git
cd docker-dcv
docker build -t docker-dcv .
```
或
```
docker pull soxueren/docker-dcv:7.0-runtime-centos7
```
## 运行容器
```
docker run -it --rm --name=dcv  --privileged=true -p 5901:5901  -p 8443:8443 docker-dcv:7.0-runtime-centos7
```
## 出现错误解决方法
```
Sep 23 06:20:13 30793f8fc873 dcvserver[126]: libcuda.so.1: cannot open shared object file: No such file or directory
Sep 23 06:20:13 30793f8fc873 dcvserver[126]: Failed to load module: /usr/lib64/dcv/modules/libdcvnvenc.so
Sep 23 06:20:13 30793f8fc873 dcvserver[126]: libnvidia-ifr.so.1: cannot open shared object file: No such file or directory
Sep 23 06:20:13 30793f8fc873 dcvserver[126]: Failed to load module: /usr/lib64/dcv/modules/libdcvnvifr.so
```
#### 1、安装nvidia驱动
```
./NVIDIA-Linux_x86_64-375.26.run
```
#### 2、安装nvidia-docker2或者nvidia-docker-plugins
#### CentOS 7 (docker-ce), RHEL 7.4/7.5 (docker-ce), Amazon Linux 1/2

If you are **not** using the official `docker-ce` package on CentOS/RHEL, use the next section.

```sh
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo yum remove nvidia-docker

# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | \
  sudo tee /etc/yum.repos.d/nvidia-docker.repo

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo yum install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```
If `yum` reports a conflict on `/etc/docker/daemon.json` with the
`docker` package, you need to use the next section instead.

For docker-ce on `ppc64le`, look at the [FAQ](https://github.com/nvidia/nvidia-docker/wiki/Frequently-Asked-Questions#do-you-support-powerpc64-ppc64le).

#### CentOS 7 (docker), RHEL 7.4/7.5 (docker)
```sh
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo yum remove nvidia-docker

# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.repo | \
  sudo tee /etc/yum.repos.d/nvidia-container-runtime.repo

# Install the nvidia runtime hook
sudo yum install -y nvidia-container-runtime-hook

# Test nvidia-smi with the latest official CUDA image
# You can't use `--runtime=nvidia` with this setup.
docker run --rm nvidia/cuda:9.0-base nvidia-smi
```
#### 启动NICE DCV server
```
dcvserver --display=1 --create-session
```
或后台运行
```
nohup dcvserver --display=1 --create-session &
```
#### dcv测试
```
dcvgltest
```
<有问题请QQ:250029975>
