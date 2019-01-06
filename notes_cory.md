# commands to install fastai with pip on ubuntu 18.04
Before, install the nvidia drivers with cuda, adding the network repo
and doing `sudo apt install cuda-9-0`
```
sudo apt install python3.6 libjpeg-turbo8-dev
virtualenv -p python3.6 ~/python-fast.ai
source ~/python-fast.ai/bin/activate
pip install fastai PyTurboJPEG ipython jupyter bcolz \
  opencv_python opencv_contrib_python seaborn \
  sklearn ipdb sklearn sklearn_pandas graphviz isoweek pandas \
  pandas_summary torchtext
CC="cc -mavx2" pip install --no-cache-dir -U --force-reinstall --no-binary :all: --compile pillow-simd
git clone https://github.com/fastai/fastai --depth 1
cd fastai/data
wget http://files.fast.ai/data/dogscats.zip
unzip dogscats.zip && rm dogscats.zip
cd ../courses/dl1
jupyter notebook
```


# run with docker on ubuntu 18.04:
* Install cuda 9.0 from [here](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=debnetwork):
```
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt update
sudo apt install -y cuda-9-0
```

* Install docker-ce
```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker $USER
# reload user groups
exec su -l $USER
```
* Install nvidia-docker from [here]()
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
cd ~
git clone https://github.com/fastai/fastai --depth 1
cd fastai/data
wget http://files.fast.ai/data/dogscats.zip
unzip dogscats.zip && rm dogscats.zip


```

* Run the notebook with docker from [here](https://github.com/MattKleinsmith/dockerfiles/tree/master/fastai)
```
docker run --runtime=nvidia --init -it -p 8888:8888 -v$HOME/.torch:/root/.torch -v $HOME/fastai:/fastai -v $HOME/fastai/data:/fastai/courses/dl1/data sgryco/fastaiconda
```
