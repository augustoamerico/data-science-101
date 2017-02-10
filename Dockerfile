FROM ubuntu:14.04.5

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /root/course

COPY ./course /root/course

RUN sudo apt-get update && \
    sudo apt-get install -y build-essential libblas-dev liblapack-dev gfortran python3 python3-dev python3-pip git && \
    sudo pip3 install --upgrade pip && \
    sudo pip3 install -U six && \
    sudo pip3 install Cython==0.25.2 numpy==1.12.0 jupyter==1.0.0 pandas==0.19.2 scikit-learn==0.18.1 seaborn==0.7.1 matplotlib==2.0.0 && \
    jupyter notebook --generate-config -y
    
RUN sed -i -e 's/#c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/' /root/.jupyter/jupyter_notebook_config.py 

RUN sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/" /root/.jupyter/jupyter_notebook_config.py 

RUN sed -i -e "s/#c.NotebookApp.disable_check_xsrf = False/c.NotebookApp.disable_check_xsrf = True/" /root/.jupyter/jupyter_notebook_config.py 

RUN sed -i -e "s/#c.NotebookApp.token = '<generated>'/c.NotebookApp.token = ''/" /root/.jupyter/jupyter_notebook_config.py
 
RUN export PYTHONPATH=.:/root/course

WORKDIR /root/course

ENTRYPOINT ["nohup","jupyter-notebook","--notebook-dir=/root","&"]

