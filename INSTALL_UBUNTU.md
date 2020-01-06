# Install OpenConnect 8.x on Ubuntu 18.04
OpenConnect 7.x is available as part of `apt get` in Ubuntu 18.04. In order to install 8.x we need to download the source and compile it. Follow the below steps to download and install OpenConnect 8.0:

*  Download the latest version, 8.05 from [here](ftp://ftp.infradead.org/pub/openconnect/openconnect-8.05.tar.gz) and extract to folder.
*  Download `vpnc` script (required during OpenConnect Configure) from [here](http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script) and copy it to `/etc/vpnc` folder.
*  Install the required packages using:
`sudo apt-get install build-essential libssl-dev libxml2 libxml2-dev zlib1g-dev`
*  Go into OpenConnect folder and run `./configure`. Look for any errors and missing dependencies and fix them.
*  Once `configure` is successful, run `make check` to generate `openconnect` application.
*  Install openconnect application using `sudo make install` followed by `sudo ldconfig` (required to setup library path to run openconnect)

OpenConnect 8.x is successfully installed on Ubuntu 18.04
