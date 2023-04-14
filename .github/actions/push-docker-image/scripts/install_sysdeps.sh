# Hash map of system deps
declare -A pkgs_to_install

pkgs_to_install="\
qpdf \
libxt-dev \
"

# Set env vars
export DEBIAN_FRONTEND=noninteractive
export ACCEPT_EULA=Y

# Update
apt-get update -y

apt-get install -q -y ${pkgs_to_install}

# Clean up
apt-get autoremove -y
apt-get autoclean -y