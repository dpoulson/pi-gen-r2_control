#!/bin/bash -e

on_chroot << EOF
pip install --upgrade pip
pip install -r /home/pi/r2_control/requirements.txt
EOF