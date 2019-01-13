FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

LABEL com.nvidia.volumes.needed="nvidia_driver"

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list &&\
    echo "deb http://ppa.launchpad.net/jonathonf/python-3.6/ubuntu xenial main" > /etc/apt/sources.list.d/python3.6.list &&\
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F06FC659

# python 3.6
RUN apt-get update && apt-get install -y --no-install-recommends \
  python3.6-dev libjpeg-turbo8-dev \
  libpng-dev \
  curl \
  build-essential \
  libglib2.0-0 graphviz\
  &&\
  rm -rf /var/lib/apt/lists/* &&\
  curl https://bootstrap.pypa.io/get-pip.py | python3.6

RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1

# jupyter and numpy before install other packages else bcolz will break
RUN pip install --no-cache-dir jupyter_contrib_nbextensions \
  ipython jupyter numpy

RUN pip install --no-cache-dir fastai==0.7.0 torchtext==0.2.3

# fix read_feather, will be fixed in next pandas release
RUN pip install --no-cache-dir -U ipywidgets feather-format pyarrow==0.10.0

RUN jupyter notebook --generate-config --allow-root && \
    echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py &&\
    echo "c.NotebookApp.custom_display_url = 'http://localhost:8888'" >> ~/.jupyter/jupyter_notebook_config.py

WORKDIR /fastai

# fix path for some lessons, put data in /data
RUN ln -s /fastai/data /data

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
