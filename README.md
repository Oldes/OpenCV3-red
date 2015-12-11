# Red Binding for OpenCV 3.0 
## see http://www.red-lang.org and http://opencv.org


### This binding has been tested with Mac OSX 10.11.2 and Windows 10.

### This binding allows access about 600 basic OpenCV functions.
### This binding can be only used with 3.0 and higher version of opencv library.

###You must use 32-bit version of dynamically linked libraries. 

## Warning
The code is still under development and unstable. This software is provided 'as-is', without any express or implied warranty.

## Directories
### opencv3.0
This directory includes 32-bit compiled dynamic libraries for OSX and Windows. Linux version ASAP.
### libs
This directory includes different red/system files that are required to access opencv libs. You'll also find orginal C_Functions.

### samples
Several scripts which demonstrate how to use OpenCV with Red. Please adapt paths according to your needs. More samples to come :)


These scripts allow to play with camera and images.
All scrpits were compiled with Red 0.5.4 compiler and are fully functional under OSX and Windows. Linux will be added ASAP.

Windows 10 users: there is a unresolved problem with webcams.Cams are recognized and activated but we can't get images. To be tested!


### Red and Red/System code 
All scripts are Red scripts and intensively use routines to access Red/System code.

### required includes 

libs/red/types_r.reds           ; some specific structures for Red/S 

libs/core/types_c.reds          ; basic OpenCV types and structures

libs/core/core.reds             ; OpenCV core functions

### optional includes

libs/calib3d/calib3D.reds		 ; for using different cameras

libs/highgui/highgui.reds       ; highgui functions

libs/imgcodecs/imgcodecs.reds   ; basic image functions

libs/imgproc/imgproc.reds		 ; image processing functions

libs/objdetect/objdetect.reds	 ; object detection with classifiers

libs/photo/photo.reds			 ; photo impainting

libs/video/video.reds       	 ; Motion Analysis and Motion Tracking 

libs/videoio/videoio.reds       ; Video and Movies functions

##enjoy:)
