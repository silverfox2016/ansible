#!/bin/bash

cat /proc/diskstats | awk "{print $1"此块设备的主设备号"$1}"
