Red/System [
	Title:		"OpenCV 3.0.0 Binding: photo"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structuresñ


#define tphoto "libopencv_photo.dylib"
print [tphoto newline]

; OpenCV photo C Functions
#switch OS [
    MacOSX  [#define photo "/usr/local/lib32/opencv3/libopencv_world.3.0.0.dylib" #define importMode cdecl]
    Windows [#define photo "c:\opencv3\build\x86\vc12\bin\opencv_world300.dll" #define importMode cdecl] ;stdcall in case of
    Linux   [#define photo "/usr/local/lib32/opencv3/libopencv_world.so.3.0.0" #define importMode cdecl]
]

#enum InpaintingModes [
    CV_INPAINT_NS:      0
    CV_INPAINT_TELEA:   1
]
 
#import [
    photo importMode [
        cvInpaint: "cvInpaint" [
        "Inpaints the selected region in the image "
            src             [byte-ptr!]
            inpaint_mask    [byte-ptr!]
            dst             [byte-ptr!]
            inpaintRange    [float!]
            flags           [integer!]
        ]
    ]; end photo
] ;end import

