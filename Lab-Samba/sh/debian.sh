#!/bin/bash
apt update
apt upgrade -y
apt install net-tools htop vim
apt purge nano -y