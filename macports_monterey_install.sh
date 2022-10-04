#!/bin/sh

# macports_monterey_install.sh
# Hoyt Harness, 2021
#
# A shell script for macOS 12 Montery to automate the installation of
# MacPorts.
#
# Copyright (C) 2021 Hoyt Harness, hoyt.harness@gmail.com, Positronikal
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Run as root!

# Variables
rtusr=$(logname 2>/dev/null || echo $SUDO_USER)
rtusrgp=$(groups $rtusr | cut -d' ' -f 1)

# Check for and/or create MacPorts dir and set ~/bin path envar:
echo "Preparing your MacPorts directory..."
mkdir -p /Users/$rtusr/bin/MacPorts
cd /Users/$rtusr/bin/MacPorts
PATH="/Users/$rtusr/bin/MacPorts${PATH:+:$PATH}"
echo "Changed working directory to: /Users/$rtusr/bin/MacPorts"

# Install the latest version of the Xcode command-line tools:
echo "Installing the latest version of Xcode CLI tools..."
xcode-select --install
xcodebuild -license
echo "Done."

# Reinstall MacPorts base system:
echo "Installing the MacPorts base system for Monterey..."
curl --location --remote-name \
    https://github.com/macports/macports-base/releases/download/v2.7.1/\
        MacPorts-2.7.1-12-Monterey.pkg
sudo installer -pkg MacPorts-2.7.1-12-Monterey.pkg -target /
echo "Done."

# Uninstall your Catalina ports:
echo "Uninstalling your Catalina ports..."
port -qv installed > myports.txt
port echo requested | cut -d ' ' -f 1 | uniq > requested.txt
sudo port -f uninstall installed
sudo port reclaim
echo "Done."

# Install your Monterey ports:
echo "Installing your Monterey ports"
curl --location --remote-name https://github.com/macports/macports-contrib/\
    raw/master/restore_ports/restore_ports.tcl
chmod +x restore_ports.tcl
xattr -d com.apple.quarantine restore_ports.tcl
sudo ./restore_ports.tcl myports.txt
sudo port unsetrequested installed
xargs sudo port setrequested < requested.txt
echo "Done."

Echo "Setting up MacPorts update script..."
cd ..
if [ ! -e macports_updater.sh ]; then
    touch macports_updater.sh
    chown $rtusr:$rtusrgp macports_updater.sh
    chmod +x macports_updater.sh
    echo "#! /bin/sh" > macports_updater.sh
    echo >> macports_updater.sh
    echo "# macports_updater.sh" >> macports_updater.sh
    echo "# Hoyt Harness, 2021" >> macports_updater.sh
    echo "#" >> macports_updater.sh
    echo "# A shell script for macOS to update an existing MacPorts installation," >> macports_updater.sh
    echo "# including ports." >> macports_updater.sh
    echo "#" >> macports_updater.sh
    echo "# Copyright (C) 2021 Hoyt Harness, hoyt.harness@gmail.com, Positronikal" >> macports_updater.sh
    echo "#" >> macports_updater.sh
    echo "# This program is free software: you can redistribute it and/or modify" >> macports_updater.sh
    echo "# it under the terms of the GNU General Public License as published by" >> macports_updater.sh
    echo "# the Free Software Foundation, either version 3 of the License, or" >> macports_updater.sh
    echo "# (at your option) any later version." >> macports_updater.sh
    echo "#" >> macports_updater.sh
    echo "# This program is distributed in the hope that it will be useful," >> macports_updater.sh
    echo "# but WITHOUT ANY WARRANTY; without even the implied warranty of" >> macports_updater.sh
    echo "# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" >> macports_updater.sh
    echo "# GNU General Public License for more details." >> macports_updater.sh
    echo "#" >> macports_updater.sh
    echo "# You should have received a copy of the GNU General Public License" >> macports_updater.sh
    echo "# along with this program.  If not, see <http://www.gnu.org/licenses/>." >> macports_updater.sh
    echo >> macports_updater.sh >> macports_updater.sh
    echo "sudo port -v selfupdate" >> macports_updater.sh
    echo "sudo port upgrade outdated" >> macports_updater.sh
    echo "sudo port uninstall inactive" >> macports_updater.sh
    echo "sudo port uninstall rleaves" >> macports_updater.sh
    echo >> macports_updater.sh
    echo "exit" >> macports_updater.sh
    echo "MacPorts update script created. Run macports_updater.sh as root from terminal."
else
    echo "MacPorts update script already exists. Run macports_updater.sh as root from terminal."
fi

read -p "Press any key to exit..."

exit
