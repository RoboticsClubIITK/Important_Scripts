#!/bin/bash
sudo apt-get install git build-essential cmake
# Checking for the shell being used.
shell="$SHELL"
shell=$(echo $shell | rev)
shell="${shell:0:4}"
shell=$(echo $shell | rev | cut -d'/' -f 2)
echo $shell
shellrc=$shell"rc"
# Checking for the Ubuntu version
p="$(lsb_release -r)"
p="${p#*1}"
if [ "$p" == "4.04" ]; then
    ubuntu_distro="trusty"
    ros_distro="indigo"
elif [ "$p" == "6.04" ]; then
    ubuntu_distro="xenial"
    ros_distro="kinetic"
else echo "\033[31m Sorry! This was meant only for Ubuntu 14.04 or 16.04. You can try searching the web though."
fi
# Proceeding with the normal install
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu \
            $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver \
    hkp://ha.pool.sks-keyservers.net --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get upgrade
sudo apt-get update
sudo apt-get install ros-$ros_distro-desktop-full
sudo rosdep init
rosdep update
echo "source /opt/ros/$ros_distro/setup.$shell" >> ~/.$shellrc
source ~/.$shellrc
sudo apt-get install python-rosinstall
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make
echo "source $(pwd)/devel/setup.$shell" >> ~/.$shellrc
source ~/.$shellrc
echo "Done"
