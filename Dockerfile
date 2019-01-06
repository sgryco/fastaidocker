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
  &&\
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  &&\
  rm -rf /var/lib/apt/lists/* &&\
  curl https://bootstrap.pypa.io/get-pip.py | python3.6
  # --allow-downgrades
  # zip \
  # unzip \
  # curl \
  #ca-certificates \
  #libnccl2=2.0.5-3+cuda9.0 \
  #libnccl-dev=2.0.5-3+cuda9.0 \

RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1

#ENV PYTHON_VERSION=3.6

#RUN CC="cc -mavx2" pip install --no-cache-dir -U --force-reinstall --no-binary :all: \
# --compile pillow-simd

# jupyter and ml
RUN pip install jupyter_contrib_nbextensions \
  PyTurboJPEG ipython jupyter 
RUN pip install torch==0.4.1


RUN pip install \
  matplotlib pandas \
  bottleneck \
  dataclasses \
  fastprogress>=0.1.18 \
  bs4 \
  matplotlib \
  numexpr    \
  numpy>=1.12 \
  nvidia-ml-py3 \
  pandas \
  packaging \
  Pillow \
  pyyaml  \
  requests \
  scipy \
  spacy>=2.0.18 \
  torchvision \
  typing \
  notebook

RUN pip install bcolz opencv_python-headless opencv_contrib_python-headless

RUN apt-get update && apt-get install -y --no-install-recommends \
  libglib2.0-0 graphviz\
  &&\
  rm -rf /var/lib/apt/lists/*

RUN pip install seaborn graphviz sklearn_pandas \
  sklearn ipdb sklearn sklearn_pandas  isoweek pandas \
  pandas_summary torchtext

# fix read_feather, will be fixed in next pandas release
RUN pip install -U ipywidgets feather-format pyarrow==0.10.0

RUN jupyter notebook --generate-config --allow-root && \
    echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py &&\
    echo "c.NotebookApp.custom_display_url = 'http://localhost:8888'" >> ~/.jupyter/jupyter_notebook_config.py

WORKDIR /fastai

# fix path for some lessons, put data in /data
RUN ln -s /fastai/data /data

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]

#ENV PATH /opt/conda/bin:/opt/conda/envs/fastai/bin:$PATH
#RUN echo "source activate fastai" >> ~/.bashrc
#RUN bash -c "source activate fastai && conda update -y notebook jupyter"
#RUN bash -c "source activate fastai && conda install -c conda-forge jupyter_contrib_nbextensions \
            #jupyter_nbextensions_configurator"


#RUN echo "source activate fastai ;  jupyter notebook --ip='0.0.0.0' --allow-root --no-browser" > ~/runnotebook.sh &&\
    #echo "c.NotebookApp.custom_display_url = 'http://localhost:8888'" >> ~/.jupyter/jupyter_notebook_config.py

#CMD /bin/bash ~/runnotebook.sh

