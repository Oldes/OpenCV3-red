Red [
	Title:		"OpenCV Tests: Core Image Processing"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2012-2105 F. Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
	#include %../../libs/core/core.reds             ; OpenCV core functions

	; according to OS 
	#switch OS [
		MacOSX  [picture: "/Users/fjouen/Pictures/lena.tiff"]
		Windows [picture: "c:\Users\palm\Pictures\lena.tiff"]
	]
	delay: 1000
	wName1: "Image 1 "
	wName2: "Image 1 Clone "
	wName3: "Result"
	
]

; playing with some basic operators 

loadImages: routine [] [
	tmp: cvLoadImage picture CV_LOAD_IMAGE_ANYCOLOR ; to get structure values
	clone: as byte-ptr! cvCreateImage tmp/width tmp/height tmp/depth tmp/nChannels 
	sum:  as byte-ptr! cvCreateImage tmp/width tmp/height tmp/depth tmp/nChannels
	src: as byte-ptr! tmp
	tmp: null
	cvCopy src clone null
	cvNamedWindow wName1 CV_WINDOW_AUTOSIZE 
	;cvNamedWindow wName2 CV_WINDOW_AUTOSIZE
	cvNamedWindow wName3 CV_WINDOW_AUTOSIZE
	cvShowImage wName1 src 
	;cvShowImage wName2 clone 
	cvShowImage wName3 sum 
	cvMoveWindow wName1  100 40
	cvMoveWindow wName3  640 40
	print ["Please wait! " lf]
	cvWaitKey delay
]

addImages: routine [][
	print ["cvAdd" lf]
	cvAdd src clone sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]


subImages: routine [][
	print ["cvSub" lf]
	cvSub sum clone sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

addScalar: routine [][
	print ["cvAddS" lf]
	v: cvScalar 255.0 0.0 0.0 0.0
	cvAddS src v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]


subScalar: routine [][
	print ["cvSubS" lf]
	v: cvScalar 255.0 255.0 0.0 0.0
	cvSubS src v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

subRScalar: routine [][
	print ["cvSubRS" lf]
	v: cvScalar 255.0 0.0 0.0 0.0
	cvSubRS src v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

multiplication: routine [][
	print ["cvMul" lf]
	cvMul  src clone sum 0.25
	cvShowImage wName3 sum
	cvWaitKey delay
]
; better with 1-channel image!
division: routine [][
	print ["cvDiv" lf]
	cvDiv clone src sum 0.25
	cvShowImage wName3 sum
	cvWaitKey delay
]

scaleAdd: routine [] [
	print ["cvScaleAdd" lf]
	cvScaleAdd src 1.0 0.0 0.0 0.0 clone sum
	cvShowImage wName3 sum
	cvWaitKey delay
]

AXPY: routine [] [
	print ["AXPY" lf]
	cvAXPY src 1.0 1.0 1.0 0.0 clone sum
	cvShowImage wName3 sum
	cvWaitKey delay
]


addWeighted: routine [] [
	print ["cvAddWeighted" lf]
	cvAddWeighted src 1.0 / 3.0  clone 1.0 / 3.0 0.0 sum
	cvShowImage wName3 sum
	cvWaitKey delay
]

andOperator: routine [] [
	print ["cvAnd" lf]
	cvAnd src sum sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

andSOperator: routine [] [
	print ["cvAndS" lf]
	v: cvScalar 127.0 127.0 127.0 0.0
	cvAndS clone  v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

orOperator: routine [] [
	print ["cvOr" lf]
	cvOr src sum sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

orSOperator: routine [] [
	print ["cvOrS" lf]
	v: cvScalar 0.0 255.0 0.0 0.0
	cvOrS clone v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

xorOperator: routine [] [
	print ["cvXor" lf]
	cvXor sum clone sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

xorSOperator: routine [] [
	print ["cvXorS" lf]
	v: cvScalar 0.0 255.0 0.0 0.0
	cvXorS clone v/v0 v/v1 v/v2 v/v3 sum null
	cvShowImage wName3 sum
	cvWaitKey delay
]

notOperator: routine [][
	print ["cvNot" lf]
	cvNot src sum
	cvShowImage wName3 sum
	cvWaitKey delay
]




dotProduct: routine [][
	print ["cvDotProduct : "  cvDotProduct src clone  lf]
	print ["All tests done. Bye..." lf]
	cvWaitKey 2000
	
]



freeOpenCV: routine [] [
	cvDestroyAllWindows
	&src: declare dbptr! ; we need a double pointer
	&src/ptr: src
	cvReleaseImage &src
	&clone: declare dbptr! ; we need a double pointer
	&clone/ptr: clone
	cvReleaseImage &clone
	&sum: declare dbptr! ; we need a double pointer
	&sum/ptr: sum
	cvReleaseImage &sum
]


;************ MAIN PROGRAM **************
loadImages
addImages
subImages
addScalar
subScalar
subRScalar
multiplication
division
scaleAdd
AXPY
addWeighted
andOperator
andSOperator
orOperator
orSOperator
xorOperator
xorSOperator
notOperator
dotProduct
freeOpenCV
Quit

