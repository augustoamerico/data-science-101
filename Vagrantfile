Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  ENV['LC_ALL']="C"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 4
  end

  config.vm.synced_folder "course", "/home/vagrant/course", type: "nfs"
  config.vm.network "private_network", ip: "192.168.50.13"
  config.vm.network "forwarded_port", guest: 8888, host: 8888


  config.vm.provision "installation", type: "shell", privileged: false, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y build-essential libblas-dev liblapack-dev gfortran python3 python3-dev python3-pip git
    sudo pip3 install --upgrade pip
    # install six ahead of time because otherwise jupyter installation hits a conflicting bug
    sudo pip3 install -U six
    sudo pip3 install Cython==0.25.2 numpy==1.12.0 jupyter==1.0.0 pandas==0.19.2 scikit-learn==0.18.1 seaborn==0.7.1 matplotlib==2.0.0
    jupyter notebook --generate-config -y
    sed -i -e 's/#c.NotebookApp.open_browser = True/c.NotebookApp.open_browser = False/' /home/vagrant/.jupyter/jupyter_notebook_config.py
    sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/" /home/vagrant/.jupyter/jupyter_notebook_config.py
    sed -i -e "s/#c.NotebookApp.disable_check_xsrf = False/c.NotebookApp.disable_check_xsrf = True/" /home/vagrant/.jupyter/jupyter_notebook_config.py
    sed -i -e "s/#c.NotebookApp.token = '<generated>'/c.NotebookApp.token = ''/" /home/vagrant/.jupyter/jupyter_notebook_config.py
  SHELL

  config.vm.provision "setup-r-env", type: "shell", privileged: false, inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    # installing R
    # add the R repository to apt-get the package
    echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee -a /etc/apt/sources.list
    echo "deb http://mirrors.up.pt/ubuntu/ trusty-backports main restricted universe" | sudo tee -a /etc/apt/sources.list
    gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E084DAB9
    gpg -a --export E084DAB9 | sudo apt-key add -
    mkdir -p /home/vagrant/R/lib
  SHELL

  config.vm.provision "installation-r-irkernel", type: "shell", privileged: false, inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    echo "export R_LIBS_USER=/home/vagrant/R/lib" | tee -a /home/vagrant/.bashrc
    #echo "export R_LIBS_USER="/usr/local/lib/R/site-library:/home/vagrant/R/lib"" | tee -a /home/vagrant/.bashrc
    echo "export R_LIBS_SITE=/home/vagrant/R/lib" | tee -a /home/vagrant/.bashrc
    echo "export PYTHONPATH=.:/home/vagrant/course" | tee -a /home/vagrant/.bashrc
    cp /home/vagrant/.bashrc /home/vagrant/.bashrc.bkup
    tail -n +10 /home/vagrant/.bashrc | tee /home/vagrant/.bashrc
    tail /home/vagrant/.bashrc 
    source /home/vagrant/.bashrc
    env
    # installing R
    sudo sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sudo sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list
    sudo apt-get update
    sudo apt-get install -y r-base r-base-dev
    sudo apt-get -y build-dep libcurl4-gnutls-dev
    sudo apt-get -y install libcurl4-gnutls-dev
    # installing IRKernel 
    echo "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'), repos='http://cran.us.r-project.org', lib='/home/vagrant/R/lib')" | R --save 
    echo "devtools::with_libpaths(new='/home/vagrant/R/lib', devtools::install_github('IRkernel/IRkernel'))" | R --save
    echo "IRkernel::installspec()" | R --save
  SHELL

  config.vm.provision "run-notebook", type: "shell", run: "always", privileged: false, inline: <<-SHELL
    #export PYTHONPATH=.:/home/vagrant/course
    nohup jupyter-notebook --notebook-dir=/home/vagrant &
  SHELL

end
