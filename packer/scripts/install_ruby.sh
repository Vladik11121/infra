set -e

# Install RVM and Ruby
sudo apt-get update
sudo apt-get install -y gnupg2 curl
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable

source /home/ubuntu/.rvm/scripts/rvm
rvm requirements
rvm install 2.4.1
rvm use 2.4.1 --default

# Install Bundler
gem install bundler -V --no-ri --no-rdoc
