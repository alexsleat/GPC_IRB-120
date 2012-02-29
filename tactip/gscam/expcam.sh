#!/bin/bash

export GSCAM_CONFIG="v4l2src device=/dev/video0 ! video/x-raw-rgb ! ffmpegcolorspace"
