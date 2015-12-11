Red [
	Title:		"OpenCV Tests: Laplacian"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/imgproc/types_c.reds       ; image processing types and structures
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/imgproc.reds       ; OpenCV image  processing
	#include %../../libs/core/core.reds             ; OpenCV core functions

	; accoding to OS 
	#switch OS [
		MacOSX  [image: "/Users/fjouen/Pictures/baboon.jpg"]
		Windows [image: "c:\Users\palm\Pictures\baboon.jpg"]
	]
	depth: IPL_DEPTH_32F
]


laplacian: routine [] [
	srcWnd: "Source"
	dstWnd: "Laplacian"
	kernel: 11 ; up to 31 but always ODD !!!
	src: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR
	dst: cvCreateImage src/width src/height depth 3
	cvNamedWindow srcWnd CV_WINDOW_AUTOSIZE 
	cvNamedWindow dstWnd CV_WINDOW_AUTOSIZE
	cvMoveWindow dstWnd 620 100
	cvLaplace as byte-ptr! src  as byte-ptr! dst kernel 
	cvShowImage srcWnd as byte-ptr! src
	cvShowImage dstWnd as byte-ptr! dst
	cvWaitKey 0 ; until a key is pressed
]

; free memory used by OpenCV
freeOpenCV: routine [] [
	cvDestroyAllWindows
	&src: declare dbptr! ; we need a double pointer
	&src/ptr: as byte-ptr! src
	cvReleaseImage &src
	&dst: declare dbptr! ; we need a double pointer
	&dst/ptr: as byte-ptr! dst
	cvReleaseImage &dst
]


laplacian
freeOpenCV
quit
