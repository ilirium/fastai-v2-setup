#! /bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
black=`tput setaf 0`
bg=`tput setab 7`
reset=`tput sgr0`
echo "Setting up ${green}fast.ai v2${reset} environment."
DEBIAN_FRONTEND=noninteractive

echo "${red}Updating package repositories...${reset}"
sudo rm /etc/apt/apt.conf.d/*.*
sudo apt update

echo "${red}Upgrading packages...${reset}"
sudo apt -y upgrade --force-yes
sudo apt install unzip git -y

echo "${red}Removing unneeded packages...${reset}"
sudo apt -y autoremove

echo "${bg}                         ${reset}"
echo "${bg}${black} Downloading ${green}Anaconda${black}... ${reset}"
echo "${bg}                         ${reset}"
cd ~
sudo rm -R downloads
mkdir downloads
cd downloads
wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh

echo "${green}Done! Installing Anaconda...${reset}"
bash Anaconda3-5.0.1-Linux-x86_64.sh -b
echo "${bg}                                       ${reset}"
echo "${bg}${black} Finishing running ${green}Anaconda${black} installer. ${reset}"
echo "${bg}                                       ${reset}"
echo ""
echo "${bg}                           ${reset}"
echo "${bg}${black} Downloading ${blue}fast.ai${black} v2... ${reset}"
echo "${bg}                           ${reset}"
cd ~
sudo rm -R fastai
git clone https://github.com/fastai/fastai.git
cd fastai/
echo "Setting path variable..."
echo 'export PATH=~/anaconda3/bin:$PATH' >> ~/.bashrc
export PATH=~/anaconda3/bin:$PATH
source ~/.bashrc
echo "Creating environment..."
conda env update
echo 'source activate fastai' >> ~/.bashrc
source activate fastai
source ~/.bashrc
echo "Done."
echo "${bg}                                 ${reset}"
echo "${bg}${black} Finished installing ${blue}fast.ai${black} v2. ${reset}"
echo "${bg}                                 ${reset}"
echo ""
echo "Downloading ${blue}dogscats dataset${reset}..."
cd ..
sudo rm -R data
mkdir data
cd data
wget http://files.fast.ai/data/dogscats.zip
echo "${green}Done!${reset}"

unzip -q dogscats.zip
cd ../fastai/courses/dl1/
echo "Creating symbolic links..."
ln -s ~/data ./
echo "Deleting any old Jupyter Notebook configurations..."
sudo rm ~/.jupyter
echo "Generating new Jupyter Notebook configuration..."
jupyter notebook --generate-config
echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "Enabling access through firewall (ufw) ..."
sudo ufw allow 8888/tcp

echo "${bg}                                          ${reset}"
echo "${bg}${black} Installing ${green}NVIDIA${black} drivers + ${green}CUDA${black} 9.0 ... ${reset}"
echo "${bg}                                          ${reset}"
sudo apt -y install qtdeclarative5-dev qml-module-qtquick-controls
echo "Adding ${green}NVIDIA repository...${reset}"
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
cd ~/downloads/
echo "Installing ${green}CUDA${reset} 9.0"
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
sudo apt update
sudo apt install cuda -y
echo "Installing ${green}cuDNN${reset} 9.1"
wget http://files.fast.ai/files/cudnn-9.1-linux-x64-v7.tgz
tar xf cudnn-9.1-linux-x64-v7.tgz
sudo cp cuda/include/*.* /usr/local/cuda/include/
sudo cp cuda/lib64/*.* /usr/local/cuda/lib64/

echo "Installing iPyWidgets for Jupyter Notebook"
pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix
echo "Done!"
echo ""
echo "${green}Installation has completed.${reset}"
echo "${red} SYSTEM REBOOTING NOW ${reset}"
echo "Connection will now close."
sudo reboot
