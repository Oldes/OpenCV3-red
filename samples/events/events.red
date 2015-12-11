Red [
	Title:		"Window with Events"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; import required OpenCV libraries
#system [
	; OpenCV functions we need
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures`
	#include %../../libs/core/core.reds             ; OpenCV core functions
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/imgcodecs/imgcodecs.reds   ; basic image functions
	#include %../../libs/imgproc/types_c.reds       ; image processing types and structures
	; accoding to OS 
	#switch OS [
		MacOSX  [image: "/Users/fjouen/Pictures/lena.tiff"]
		Windows [image: "c:\Users\palm\Pictures\lena.tiff"]
	]
	; code pointer for tracker
	trackEvent: func [[cdecl] pos [integer!]][
		cvGetTrackbarPos "Track" windowsName
		print ["Trackbar position is : " pos lf]
	]
	
	; pointer  to the function  called by mouse callback
	mouseEvent: func [
	[cdecl]
            event 		[integer!]
            x	        	[integer!]
            y	        	[integer!]
            flags		[integer!]
            param		[byte-ptr!]
	] [
        print ["Mouse Position xy : " x " " y lf]
]
]


makeWindow: routine [] [
	windowsName: "OpenCV Window [Any Key to close Window]"
	cvNamedWindow windowsName CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
	p: declare pointer! [integer!]  ; for trackbar position
	; for trackbar events 
	cvCreateTrackbar "Track" windowsName p 49 :trackEvent ; function as parameter
	cvSetTrackBarPos "Track" windowsName 0
	; set callback for mouse events
	cvSetMouseCallBack windowsName :mouseEvent null
	;load and show color image
	img: cvLoadImage image CV_LOAD_IMAGE_ANYCOLOR
	cvShowImage windowsName as byte-ptr! img
	cvMoveWindow windowsName 200 200
	cvWaitKey 0
]

; free memory used by OpenCV
freeOpenCV: routine [] [
	cvDestroyAllWindows
	&image: declare dbptr! ; we need a double pointer
	&image/ptr: as byte-ptr! img
	cvReleaseImage &image
]


; just red code :)
makeWindow
freeOpenCV
quit


