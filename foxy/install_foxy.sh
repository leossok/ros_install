#!/bin/bash
# Copyright 2021, Sirawat Soksawatmakin 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo ""
echo "[Note] Target OS version  >>> Ubuntu 20.04 (focal)"
echo "[Note] Target ROS version >>> ROS 2 Foxy Fitzroy"
echo ""
echo "PRESS [ENTER] TO CONTINUE THE INSTALLATION"
echo "IF YOU WANT TO CANCEL, PRESS [CTRL] + [C]"
read

echo "[Set the target OS, ROS 2 version]"
name_os_version=${name_os_version:="focal"}
name_ros_version=${name_ros_version:="foxy"}

echo "[Set locale UTF-8]"
sudo apt update && sudo apt install -y locales curl gnupg2 lsb-release build-essential wget
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

echo "[Install additional]"
sudo apt install -y locales curl gnupg2 lsb-release build-essential git wget python3-pip vim
pip3 install -U argcomplete

echo "[Add the ROS 2 repository]"
if [ ! -e /etc/apt/sources.list.d/ros2-lastest.list ]; then
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
fi

echo "[Install ROS 2 packages]"
sudo apt update
sudo apt install -y ros-foxy-ros-base python3-rosdep2
sudo apt install -y python3-colcon-common-extensions

echo "[Environment setup and getting rosinstall]"
sh -c "source /opt/ros/$name_ros_version/setup.bash"

echo "[Initialize rosdep]"
if [ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    sudo sh -c "rosdep init"
fi
rosdep update


echo "[Set the ROS evironment]"
sh -c "echo \"source /opt/ros/$name_ros_version/setup.bash\" >> ~/.bashrc"
sh -c "echo \"export ROS_DOMAIN_ID=10\" >> ~/.bashrc"

source $HOME/.bashrc
echo "[Complete!!!]"
exit 0