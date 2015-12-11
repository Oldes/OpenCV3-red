Red [
	Title:		"OpenCV Tests: Gaussian"
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
	
	element_shape: CV_SHAPE_RECT
	max_iters: 10;
	open_close_pos: max_iters + 1
	erode_dilate_pos: max_iters + 1
	;the address of variable which receives trackbar position update
	&open_close_pos: declare pointer![integer!] &open_close_pos: :open_close_pos
	&erode_dilate_pos: declare pointer![integer!] &erode_dilate_pos: :erode_dilate_pos
	
	;callback functions for open/close trackbar
	OpenClose: func [[importMode] pos [integer!] /local n an][
		n: &open_close_pos/value - max_iters
		either n > 0 [an: n] [an: 0 - n]
		element: cvCreateStructuringElementEx (an * 2) + 1 (an * 2) + 1 an an element_shape null ; 0
		&element: as byte-ptr! element
		&&element: declare double-byte-ptr!
		&&element/ptr: &element 
		either n < 0 [cvErode as byte-ptr! src as byte-ptr! dst element 1 cvDilate as byte-ptr!  dst as byte-ptr! dst element 1]
                     [cvDilate as byte-ptr! src as byte-ptr! dst element 1 cvErode as byte-ptr! dst  as byte-ptr! dst element 1]
		cvReleaseStructuringElement  &&element
		cvShowImage "Open/Close"  as byte-ptr! dst
]

	ErodeDilate: func [[importMode] pos [integer! ] /local n an][
		n: &erode_dilate_pos/value - max_iters
		either n > 0 [an: n] [an: 0 - n]
		element: cvCreateStructuringElementEx (an * 2) + 1 (an * 2) + 1 an an element_shape null ; 0
		&element: as byte-ptr! element
		&&element: declare double-byte-ptr!
		&&element/ptr: &element
		either n < 0 [cvErode  as byte-ptr!  src  as byte-ptr! dst element 1] [cvDilate  as byte-ptr! src  as byte-ptr! dst element 1 ]
		cvReleaseStructuringElement  &&element
		cvShowImage "Erode/Dilate"  as byte-ptr! dst
]
	
	src: declare IplImage!
	dst: declare IplImage!
	
]

morphology: routine [][
	src: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR
	dst: cvCloneImage src

	cvNamedWindow "Open/Close" CV_WINDOW_AUTOSIZE
	cvNamedWindow "Erode/Dilate" CV_WINDOW_AUTOSIZE
	cvMoveWindow "Open/Close" 30 100
	cvMoveWindow "Erode/Dilate" 630 100

	; trackbars
	cvCreateTrackbar  "Iterations" "Open/Close" &open_close_pos max_iters * 2 + 1 :OpenClose 
	cvCreateTrackbar "Iterations" "Erode/Dilate" &erode_dilate_pos max_iters * 2 + 1 :ErodeDilate

	cvShowImage "Open/Close" as byte-ptr! dst
	cvShowImage "Erode/Dilate" as byte-ptr! dst    

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

;*************************** Main Program*********************
morphology
freeOpenCV
quit