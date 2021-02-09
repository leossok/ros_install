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
echo "[Note] Target ROS version >>> ROS 2 Noetic Ninjemys"
echo ""
echo "PRESS [ENTER] TO CONTINUE THE INSTALLATION"
echo "IF YOU WANT TO CANCEL, PRESS [CTRL] + [C]"
read

echo "[Set the target OS, ROS version]"
name_os_version=${name_os_version:="focal"}
name_ros_version=${name_ros_version:="noetic"}

echo "[Add the ROS repository]"
if [ ! -e /etc/apt/sources.list.d/ros-lastest.list ]; then
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
fi

echo "[Install ROS packages]"
sudo apt update
PS3='Please enter ros-noetic install option: '
options=("desktop-full" "desktop" "base")
select opt in "${options[@]}"
do
    case $opt in
        "desktop-full")
            echo "Install ros-noetic-desktop-full"
            sudo apt install ros-noetic-desktop-full
            break
            ;;
        "desktop")
            echo "Install ros-noetic-desktop"
            sudo apt install ros-noetic-desktop
            break
            ;;
        "base")
            echo "Install ros-noetic-ros-base"
            sudo apt install ros-noetic-ros-base
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

echo "[Environment setup and getting rosinstall]"
sh -c "source /opt/ros/$name_ros_version/setup.bash"

echo "[Initialize rosdep]"
if [ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    sudo sh -c "rosdep init"
fi
rosdep update


echo "[Set the ROS evironment]"
sh -c "echo \"source /opt/ros/$name_ros_version/setup.bash\" >> ~/.bashrc"
sh -c "echo \"export ROS_MASTER_URI=http://localhost:11311\" >> ~/.bashrc"
sh -c "echo \"export ROS_HOSTNAME=localhost\" >> ~/.bashrc"

source $HOME/.bashrc
echo "[Complete!!!]"
exit 0