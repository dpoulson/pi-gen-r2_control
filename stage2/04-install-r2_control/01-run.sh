#!/bin/bash -e

cd ${ROOTFS_DIR}/home/pi
if [ ! -d "r2_control" ]
then
	git clone https://github.com/dpoulson/r2_control.git
else
	cd r2_control
	git pull
	cd ..
fi
	

cd r2_control

sudo cp r2_control.service ${ROOTFS_DIR}/lib/systemd/system/
on_chroot << EOF
systemctl enable r2_control.service
EOF

sudo cp controllers/r2_joy.service ${ROOTFS_DIR}/lib/systemd/system/
on_chroot << EOF
systemctl enable r2_joy.service
EOF

mkdir -p ${ROOTFS_DIR}/home/pi/.r2_config/
echo ps3 > ${ROOTFS_DIR}/home/pi/.r2_config/current_joy

chown -R 1000:1000 ${ROOTFS_DIR}/home/pi/.r2_config/

# Configure web interface
sudo rm -f ${ROOTFS_DIR}/etc/apache2/sites-enabled/000-default.conf

on_chroot << EOF
sudo ln -fs /home/pi/r2_control/controllers/www/apache.conf /etc/apache2/sites-enabled/000-r2.conf
EOF