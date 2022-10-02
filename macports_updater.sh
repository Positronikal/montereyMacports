#! /bin/sh
# macports_updater.sh
# Hoyt Harness, 2021
#
# A shell script for macOS to update an existing MacPorts installation,
# including ports.
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

sudo port -v selfupdate
sudo port upgrade outdated
sudo port uninstall inactive
sudo port uninstall rleaves

exit
