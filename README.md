## fastaidocker

This repository contains script to build and run a docker image containing
all the requirements to run the fast.ai deep learning course.

# Run with docker on ubuntu 18.04:

* Install nvidia drivers with cuda from [here](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=debnetwork):

```
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt update
sudo apt install -y cuda-drivers
```

* Install docker-ce

```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER
# reload user groups
exec su -l $USER
```

* Install nvidia-docker (instructions from [here](https://github.com/NVIDIA/nvidia-docker))

```
# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
```

* Get fast ai and the first dataset

```
git clone https://github.com/sgryco/fastai.git --depth 1 ~/fastai
cd ~/fastai/data
wget http://files.fast.ai/data/dogscats.zip
unzip dogscats.zip && rm dogscats.zip
```

* Run the notebook with docker

```
# Clone this repository, change to its directory and run:
./run.sh
# or
docker run --runtime=nvidia --rm -it -p 8888:8888 \
  -v$HOME/.torch:/root/.torch -v $HOME/fastai:/fastai \
    -v $HOME/fastai/data:/fastai/courses/dl1/data \
      sgryco/fastaipip
```


# Commands to install fastai with pip on ubuntu 16/18.04

If you want to install fastai directly on Ubuntu 16/18.04:
* Install cuda 9.0 for Ubuntu 18.04:
```
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1704/x86_64/cuda-repo-ubuntu1704_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1704/x86_64/7fa2af80.pub
sudo apt-get update && sudo apt-get install -y cuda-9-0
```

* Install cuda 9.0 for Ubuntu 18.04:
Follow instructions [here](https://www.kinmanlam.com/2018/06/install-cuda-90-toolkit-on-ubuntu-1804.html)

* Install the requirements in a virtual env

```
# for ubuntu 16.04 do:
sudo add-apt-repository ppa:jonathonf/python-3.6
# for all ubuntu do
sudo apt update && sudo apt install python3.6-dev python3-virtualenv libjpeg-turbo8-dev \
    libtiff5-dev libjpeg8-dev zlib1g-dev \
    libfreetype6-dev liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev \
    tcl8.6-dev tk8.6-dev python-tk

virtualenv -p python3.6 ~/python-fast.ai
source ~/python-fast.ai/bin/activate
CC="cc -mavx2" pip install --no-cache-dir -U --force-reinstall --no-binary :all: --compile pillow-simd
pip install -U fastai PyTurboJPEG ipython jupyter bcolz \
  opencv_python opencv_contrib_python seaborn \
  sklearn ipdb sklearn sklearn_pandas graphviz isoweek pandas \
  pandas_summary torchtext torch
pip uninstall Pollow
git clone https://github.com/sgryco/fastai.git --depth 1
cd fastai/data
wget http://files.fast.ai/data/dogscats.zip
unzip dogscats.zip && rm dogscats.zip
cd ../courses/dl1
jupyter notebook
```

