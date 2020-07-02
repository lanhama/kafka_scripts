#Watchman installation

If you use the container, it comes pre-installed with watchman.

Also, you should have node and npm installed on this machine if you're going to use
NodeJS to control watchman.

apt (Ubuntu, Debian)

1. sudo apt-get update
2. sudo apt-get upgrade
3. sudo apt-get install python-dev

________________________________________________________________________________

yum (centOS)

1. First, you'll need to install some tools that allow you to compile c++
source code. Run `sudo yum group install "Development Tools"`

2. yum install openssl-devel
3. yum install python-devel

________________________________________________________________________________


git clone https://github.com/facebook/watchman.git -b v4.9.0 --depth 1
cd watchman
./autogen.sh
./configure
make
sudo make install
