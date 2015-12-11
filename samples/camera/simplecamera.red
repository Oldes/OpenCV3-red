Red [
	Title:		"OpenCV Camera Test with objects"
	Author:		"F. Jouen"
	Rights:		"Copyright (c) 2015 F. Jouen. All rights reserved."
	License:    "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

; we use some Red/System code to access opencv as external lib

#system [
	; OpenCV functions we need
	#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
	#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures`
	#include %../../libs/core/core.reds             ; OpenCV core functions
	#include %../../libs/highgui/highgui.reds       ; highgui functions
	#include %../../libs/videoio/videoio.reds       ; to play with camera
]

; create red routines calling Red/System code

; use webcam
createCam: routine [device [integer!] return: [integer!]] [
	&capture: declare dbptr!
	capture: cvCreateCameraCapture device
	either (capture <> null) [
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 640.00
		cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 480.00
		cvSetCaptureProperty capture CV_CAP_PROP_FPS 25.00
		cvNamedWindow "Test Window" CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO
		&capture/ptr: capture
		return 0] [return 1]
]

;play movies
createMovie: routine [device [string!] return: [integer!]] [
  &capture: declare dbptr!
  cvNamedWindow "Playing with Movies with Red" CV_WND_PROP_AUTOSIZE OR CV_WND_PROP_ASPECTRATIO ;1
  capture: cvCreateFileCapture as c-string! string/rs-head device
  either (capture <> null) [
			&capture/ptr: capture
			return 0
  ][return 1]
]

; render either webcam or movie
render: routine [return: [integer!]] [
	image: cvQueryFrame capture
	cvShowImage "Playing with Camera with Red" as byte-ptr! image
	return cvWaitKey 1
]

; free memory used by OpenCV
freeOpenCV: routine [return: [integer!]] [
	cvDestroyAllWindows
	&image: declare dbptr! ; we need a double pointer
	&image/ptr: as byte-ptr! image
	cvReleaseImage &image
	&capture/ptr: null
	cvReleaseCapture &capture
	return 1
]


; now create an object with 3 methods that call red/S routines


videoCapture: object [
    open: func [device] [
		either type? device = integer! [createCam device] [createMovie device]
   ]
   read: does [render]
   release: does [freeOpenCV]
]

cam: 0 ; access to default camera
videoCapture/open cam  
rep: 0
until [
	rep: videoCapture/read ; read images from camera until esc key is pressed
rep = escape
]

videoCapture/release










