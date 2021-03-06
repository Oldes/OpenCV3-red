Red/System [
	Title:		"OpenCV 3.0.0 Binding: imgproc"
	Author:		"F.Jouen"
	Rights:		"Copyright (c) 2015 F.Jouen. All rights reserved."
	License:        "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]


#include %../../libs/red/types_r.reds           ; some specific structures for Red/S 
#include %../../libs/core/types_c.reds          ; basic OpenCV types and structures
#include %../../libs/imgproc/types_c.reds       ; image processing types and structures


; OpenCV ImgProc C Functions
;#define imgproc "/usr/local/lib32/opencv3/libopencv_imgproc.dylib"

#switch OS [
    MacOSX  [#define imgproc "/usr/local/lib32/opencv3/libopencv_world.3.0.0.dylib" #define importMode cdecl]
    Windows [#define imgproc "c:\opencv3\build\x86\vc12\bin\opencv_world300.dll"#define importMode cdecl] ;stdcall in case of
    Linux   [#define imgproc "/usr/local/lib32/opencv3/libopencv_world.so.3.0.0" #define importMode cdecl]
]

#define CvContourScanner! byte-ptr!
#define CV_RGB (r g b)  [(cvScalar  (b) (g) (r) 0.0 )]
CV_FILLED: -1
CV_AA: 16

#define cvDrawRect cvRectangle
#define cvDrawLine cvLine
#define cvDrawCircle cvCircle
#define cvDrawEllipse cvEllipse
#define cvDrawPolyLine cvPolyLine

CV_FONT_HERSHEY_SIMPLEX:         0
CV_FONT_HERSHEY_PLAIN:           1
CV_FONT_HERSHEY_DUPLEX:          2
CV_FONT_HERSHEY_COMPLEX:         3
CV_FONT_HERSHEY_TRIPLEX:         4
CV_FONT_HERSHEY_COMPLEX_SMALL:   5
CV_FONT_HERSHEY_SCRIPT_SIMPLEX:  6
CV_FONT_HERSHEY_SCRIPT_COMPLEX:  7
CV_FONT_ITALIC:                 16
CV_FONT_VECTOR0:                CV_FONT_HERSHEY_SIMPLEX

CvFont!: alias struct! [
    nameFont        [c-string!]
    v0              [float!]    ;CvScalar 
    v1              [float!]
    v2              [float!]
    v3              [float!]
    font_face       [integer!]
    ascii           [int-ptr!]           
    greek           [int-ptr!] 
    cyrillic        [int-ptr!]
    hscale          [float!]
    shear           [float!]
    thickness       [integer!]
    dx              [float!]
    line_type       [integer!]
]


#import [
    imgproc importMode [
        cvAcc: "cvAcc" [
        "Adds image to accumulator"
            image                   [cvArr!]
            sum                     [cvArr!]
            mask                    [cvArr!] ; CV_DEFAULT(NULL))
        ]
        
        cvSquareAcc: "cvSquareAcc" [
        "Adds squared image to accumulator"
            image                   [cvArr!]
            sqsum                   [cvArr!]
            mask                    [cvArr!] ; CV_DEFAULT(NULL))
        ]
        
         cvMultiplyAcc: "cvMultiplyAcc" [
        "Adds a product of two images to accumulator"
            image1                  [cvArr!]
            image2                  [cvArr!]
            acc                     [cvArr!]
            mask                    [cvArr!] ; CV_DEFAULT(NULL))
        ]
        
        cvRunningAvg: "cvRunningAvg" [
        "Adds image to accumulator with weights: acc = acc*(1-alpha) + image*alpha "
            image                   [cvArr!]
            acc                     [cvArr!]
            alpha                   [float!]
            mask                    [cvArr!] ; CV_DEFAULT(NULL))
        ]
        
        cvCopyMakeBorder: "cvCopyMakeBorder" [
        "Copies source 2D array inside of the larger destination array and makes a border of the specified type (IPL_BORDER_*) around the copied area."
            src 	                [CvArr!]
            dst 	                [CvArr!]
            x  		                [integer!] ; in fact CvPoint
            y		                [integer!]
            bordertype                  [integer!]
            v0                          [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0))
            v1                          [float!]
            v2                          [float!]
            v3                          [float!]
        ]
        
        cvSmooth: "cvSmooth" [
        "Smoothes array (removes noise)"
            src 		        [CvArr!]
            dst 		        [CvArr!]
            smoothtype 	                [integer!] ; CV_DEFAULT(CV_GAUSSIAN)
            param1		        [integer!] ; CV_DEFAULT(3)
            param2		        [integer!] ; CV_DEFAULT(0)
            param3		        [float!] ; CV_DEFAULT(0)
            param4		        [float!] ; CV_DEFAULT(0)	
        ]
        
        cvFilter2D: "cvFilter2D" [
        "Convolves the image with the kernel"
            src 		        [CvArr!]
            dst 		        [CvArr!]
            kernel		        [CvMat!]
            x  			        [integer!] ; in fact CvPoint 
            y			        [integer!] ;CV_DEFAULT(cvPoint(-1,-1))
        ]
        
        cvIntegral: "cvIntegral" [
        "Finds integral image: SUM(X,Y) = sum(x<X,y<Y)I(x,y)"
            image 		        [CvArr!]
            sum 		        [CvArr!]
            sqsum		        [CvArr!] ;CV_DEFAULT(NULL) none
            tilted_sum	                [CvArr!] ;CV_DEFAULT(NULL) none	
        ]
        
        ;dst_width = floor(src_width/2)[+1], dst_height = floor(src_height/2)[+1]   
        cvPyrDown: "cvPyrDown" [
        "Smoothes the input image with gaussian kernel and then down-samples it."
            src 		        [CvArr!]
            dst 		        [CvArr!]
            filter		        [integer!]; CV_DEFAULT(CV_GAUSSIAN_5x5)
        ]
        
         ;dst_width = src_width*2, dst_height = src_height*2
        cvPyrUp: "cvPyrUp" [
        "Up-samples image and smoothes the result with gaussian kernel."
            src 		        [CvArr!]
            dst 		        [CvArr!]
            filter		        [integer!]; CV_DEFAULT(CV_GAUSSIAN_5x5)
        ]
        
        cvCreatePyramid: "cvCreatePyramid" [
        "Builds pyramid for an image" 
            img 			[CvArr!]
            extra_layers	        [integer!]
            rate			[float!]
            layer_sizes		        [CvSize!]; pointer to CvSize ; CV_DEFAULT(0), use an array of 2 integer with red/S
            bufarr 			[integer!] ; CV_DEFAULT(0)
            calc			[integer!]; CV_DEFAULT(1)
            filter			[integer!]; CV_DEFAULT(CV_GAUSSIAN_5x5)
            return 			[double-byte-ptr!] ;a double pointer CvMat**
        ]
        
        cvReleasePyramid: "cvReleasePyramid" [
            ***pyramid	        [struct! [ptr [double-byte-ptr!]]] ; pointer CvMat***; triple pointer (to be tested )
            extra_layers	[integer!]
        ]
        
        cvPyrMeanShiftFiltering: "cvPyrMeanShiftFiltering" [
        "Filters image using meanshift algorithm"
            src 		        [CvArr!]
            dst 		        [CvArr!]
            sp			        [float!]
            sr			        [float!]
            max_level	                [integer!] ;  CV_DEFAULT(1)
            termcrit	                [CvTermCriteria!] ; CV_DEFAULT(cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS,5,1)))
        ]
        
        cvWatershed: "cvWatershed" [
        "Segments image using seed markers"
            src 		        [CvArr!]
            markers 	                [CvArr!]
        ]
        
        cvSobel: "cvSobel" [
        {Calculates an image derivative using generalized Sobel (aperture_size = 1,3,5,7) or Scharr (aperture_size = -1) operator.
        Scharr can be used only for the first dx or dy derivative}
            src 			[CvArr!]
            dst 			[CvArr!]
            xorder			[integer!]
            yorder			[integer!]
            aperture_size	[integer!];  CV_DEFAULT(3)
        ]
        
        cvLaplace: "cvLaplace" [
        "Calculates the image Laplacian: (d2/dx + d2/dy)I"
            src 			[CvArr!]
            dst 			[CvArr!]
            aperture_size	        [integer!];  CV_DEFAULT(3)
        ]
        
        cvCvtColor: "cvCvtColor" [
        "Converts input array pixels from one color space to another "
            src 			[CvArr!]
            dst 			[CvArr!]
            code			[integer!]
        ]
        
        cvResize: "cvResize" [
        "Resizes image (input array is resized to fit the destination array) "
            src 			    [CvArr!]
            dst 			    [CvArr!]
            interpolation	            [integer!] ;CV_DEFAULT( CV_INTER_LINEAR ))
        ]
        
        cvWarpAffine: "cvWarpAffine"[
        "Warps image with affine transform"
            src 			[CvArr!]
            dst 			[CvArr!]
            map_matrix		        [CvMat!]
            flags			[integer!] ;CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
            b				[float!]  ; a CvScalar
            g				[float!]
            r				[float!]
            a				[float!] ;CV_DEFAULT(cvScalarAll(0))
        ]
        
        cvGetAffineTransform: "cvGetAffineTransform" [
        "computes affine transform matrix for mapping src[i] to dst[i] (i=0,1,2) "
            *src 			[CvPoint2D32f!] ; pointer
            *dst 			[CvPoint2D32f!] ; idem
            map_matrix		        [CvMat!]
            return:			[CvMat!]
        ]
        
         cv2DRotationMatrix: "cv2DRotationMatrix" [
        "Computes rotation_matrix matrix"
            x                           [float32!] ;CvPoint2D32f! x
            y                           [float32!] ;CvPoint2D32f! y
            angle 			[float!]
            scale			[float!]
            map_matrix		        [CvMat!]
            return:			[CvMat!]
        ]
        
         cvWarpPerspective: "cvWarpPerspective" [
        "Warps image with perspective (projective) transform"
            src 			[CvArr!]
            dst 			[CvArr!]
            map_matrix		        [CvMat!]
            flags			[integer!] ;CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
            b				[float!]  ;  fillval a CvScalar CV_DEFAULT(cvScalarAll(0))
            g				[float!]
            r				[float!]
            a				[float!]
        ]
        
        cvGetPerspectiveTransform: "cvGetPerspectiveTransform" [
        "Computes perspective transform matrix for mapping src[i] to dst[i] (i=0,1,2,3)"
            src 			[CvPoint2D32f!]
            dest 			[CvPoint2D32f!]
            map_matrix		        [CvMat!]
            return:			[CvMat!]
        ]
        
        cvRemap: "cvRemap" [
        "Performs generic geometric transformation using the specified coordinate maps "
            src 			[CvArr!]
            dst 			[CvArr!]
            mapx			[CvArr!]
            mapy			[CvArr!]
            flags			[integer!] ;CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
            b				[float!]  ;  fillval a CvScalar CV_DEFAULT(cvScalarAll(0))
            g				[float!]
            r				[float!]
            a				[float!]
        ]
        
        cvConvertMaps: "cvConvertMaps" [
        "Converts mapx & mapy from floating-point to integer formats for cvRemap"
            mapx			[CvArr!]
            mapy			[CvArr!]
            mapxy			[CvArr!]
            mapalpha			[CvArr!]
        ]
        
        cvLogPolar: "cvLogPolar" [
        "Performs forward or inverse log-polar image transform"
            src 			[CvArr!]
            dest 			[CvArr!]
            x                           [integer!] ;CvPoint2D32f! x center
            y                           [integer!] ;CvPoint2D32f! y center
            m				[float!]
            flags			[integer!] ;CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS)
        ]
        
        cvLinearPolar: "cvLinearPolar" [
        "Performs forward or inverse linear-polar image transform"
            src 			[CvArr!]
            dst 			[CvArr!]
            x                           [float32!] ;CvPoint2D32f! x
            y                           [float32!] ;CvPoint2D32f! y
            maxRadius                   [float!]
            flags                       [integer!]
        ]
        
        cvUndistort2: "cvUndistort2" [
        "transforms the input image to compensate lens distortion"
            src                     [CvArr!]
            dst                     [CvArr!]
            intrinsic_matrix        [CvMat!]
            distortion_coeffs       [CvMat!]
        ]
        
        cvInitUndistortMap: "cvInitUndistortMap" [
        "computes transformation map from intrinsic camera parameters that can used by cvRemap"
            intrinsic_matrix        [CvMat!]
            distortion_coeffs       [CvMat!]
            mapx                    [CvArr!]
            mapy                    [CvArr!]
        ]
        
        cvInitUndistortRectifyMap: "cvInitUndistortRectifyMap" [
        "Computes undistortion+rectification map for a head of stereo camera"
            camera_matrix           [CvMat!]
            dist_coeffs             [CvMat!]
            R                       [CvMat!]
            new_camera_matrix       [CvMat!]
            mapx                    [CvArr!]
            mapy                    [CvArr!]
        ]
        
        cvUndistortPoints: "cvUndistortPoints" [
        "Computes the original (undistorted) feature coordinates"
            src                     [CvArr!]
            dst                     [CvArr!]
            camera_matrix           [CvMat!]
            dist_coeffs             [CvMat!]
            R                       [CvMat!] ;CV_DEFAULT(0)
            P                       [CvMat!] ;CV_DEFAULT(0)
        ]
        
        cvCreateStructuringElementEx: "cvCreateStructuringElementEx" [
        "creates structuring element used for morphological operations"
            cols		        [integer!]
            rows		        [integer!]
            anchor_x	                [integer!]
            anchor_y	                [integer!]
            shapes		        [integer!]
            *values		        [int-ptr!] ; pointer to values CV_DEFAULT(NULL)
            return:		        [IplConvKernel!]
        ]
        
        cvReleaseStructuringElement: "cvReleaseStructuringElement" [
        "releases structuring element"
            **element		[double-byte-ptr!] ; double pointer IplConvKernel
        ]
        
        cvErode: "cvErode" [
        "erodes input image (applies minimum filter) one or more times. If element pointer is NULL, 3x3 rectangular element is used"
            src 			[CvArr!]
            dest 			[CvArr!]
            *element			[IplConvKernel!] ;CV_DEFAULT(NULL)
            iterations		        [integer!] ;CV_DEFAULT(1)
        ]
        
        cvDilate: "cvDilate" [
        "dilates input image (applies maximum filter) one or more times. If element pointer is NULL, 3x3 rectangular element is used "
            src 			[CvArr!]
            dest 			[CvArr!]
            *element			[IplConvKernel!] ;pointer CV_DEFAULT(NULL)
            iterations		        [integer!] ;CV_DEFAULT(1)
        ]
        
        cvMorphologyEx: "cvMorphologyEx" [
        "Performs complex morphological transformation"
            src 			[CvArr!]
            dest 			[CvArr!]
            temp 			[CvArr!]
            *element			[IplConvKernel!] ;pointer CV_DEFAULT(NULL)
            operation		        [integer!] ;CV_DEFAULT(1)
            iterations		        [integer!] ;CV_DEFAULT(1)
        ]
        
        cvMoments: "cvMoments" [
        "Calculates all spatial and central moments up to the 3rd order"
            arr 			[CvArr!]
            moments 		        [CvMoments!]
            binary			[integer!] ;CV_DEFAULT(0)
        ]
        
         cvGetSpatialMoment: "cvGetSpatialMoment" [
        "Retrieve particular spatial moments "
            moments 		        [CvMoments!]
            x_order			[integer!] 
            y_order			[integer!] 
            return:			[float!]
        ]
        
        cvGetCentralMoment: "cvGetCentralMoment" [
        "Retrieve particular central moments "
            moments 		        [CvMoments!]
            x_order			[integer!] 
            y_order			[integer!] 
            return:			[float!]
        ]
        cvGetNormalizedCentralMoment: "cvGetNormalizedCentralMoment" [
        "Retrieve particular normalized central moments  "
            moments 		        [CvMoments!]
            x_order			[integer!] 
            y_order			[integer!] 
            return:			[float!]
        ]
        
        cvGetHuMoments: "cvGetHuMoments" [
        "Calculates 7 Hu's invariants from precalculated spatial and central moments"
            moments 		    [CvMoments!]
            hu_moments 		    [CvMoments!]
        ]
        
        cvSampleLine: "cvSampleLine" [
        "Fetches pixels that belong to the specified line segment and stores them to the buffer. Returns the number of retrieved points."
            image 			[CvArr!]
            pt1_x	 		[integer!];CvPoint
            pt1_y	 		[integer!];CvPoint
            pt2_x	 		[integer!];CvPoint
            pt2_y	 		[integer!];CvPoint
            void*	 		[byte-ptr!] ; pointer
            connectivity	        [integer!] ;CV_DEFAULT(8)
            return:			[integer!]
        ]
        
        cvGetRectSubPix: "cvGetRectSubPix" [
        {Retrieves the rectangular image region with specified center from the input array.
        dst(x,y) <- src(x + center.x - dst_width/2, y + center.y - dst_height/2).
        Values of pixels with fractional coordinates are retrieved using bilinear interpolation}
            src 			[CvArr!]
            dst 			[CvArr!]
            x                           [float32!] ;CvPoint2D32f! x center
            y                           [float32!] ;CvPoint2D32f! y center
        ]
        
        cvGetQuadrangleSubPix: "cvGetQuadrangleSubPix" [
        {Retrieves quadrangle from the input array. matrixarr = ( a11  a12 | b1 )   dst(x,y) <- src(A[x y]' + b)
        ( a21  a22 | b2 )   (bilinear interpolation is used to retrieve pixels with fractional coordinates)}
            src 			[CvArr!]
            dst 			[CvArr!]
            map_matrix 		        [CvArr!]
        ]
        
        cvMatchTemplate: "cvMatchTemplate" [
        "Measures similarity between template and overlapped windows in the source image and fills the resultant image with the measurements "
            image 			[CvArr!]
            temp1 			[CvArr!]
            result	 		[CvArr!]
            method			[integer!]
        ]
        
         cvCalcEMD2: "cvCalcEMD2" [
        "Computes earth mover distance between two weighted point sets (called signatures)"
            signature1 			[CvArr!]
            signature2 			[CvArr!]
            distance_type		[integer!]
            distance_func 		[byte-ptr!] ; pointer CV_DEFAULT(NULL) to CvDistanceFunction
            cost_matrix	 		[CvArr!]; CV_DEFAULT(NULL)
            flow			[CvArr!]; CV_DEFAULT(NULL)
            lower_bound			[float!];  CV_DEFAULT(NULL)
            *userdata			[byte-ptr!]; null pointer CV_DEFAULT(NULL));
        ]
        
        cvFindContours:"cvFindContours" [
        "Retrieves outer and optionally inner boundaries of white (non-zero) connected components in the black (zero) background"
            image 			[CvArr!]
            storage 		        [CvMemStorage!]
            first_contour	        [struct! [seq [CvSeq!]]] ; double pointer to CvSeq
            header_size		        [integer!];CV_DEFAULT(sizeof(CvContour))
            mode			[integer!];CV_DEFAULT(CV_RETR_LIST)
            method			[integer!];CV_DEFAULT(CV_CHAIN_APPROX_SIMPLE)
            offset_x		        [integer!]; cvPoint CV_DEFAULT(cvPoint(0,0))
            offset_y		        [integer!];cvPoint CV_DEFAULT(cvPoint(0,0))
            return: 		        [integer!]
        ]
        
        cvStartFindContours: "cvStartFindContours" [
        {Initalizes contour retrieving process. Calls cvStartFindContours.
        Calls cvFindNextContour until null pointer is returned or some other condition becomes true.
        Calls cvEndFindContours at the end.}
            image 			[CvArr!]
            storage 		        [CvMemStorage!]
            header_size		        [integer!];CV_DEFAULT(sizeof(CvContour))
            mode			[integer!];CV_DEFAULT(CV_RETR_LIST)
            method			[integer!];CV_DEFAULT(CV_CHAIN_APPROX_SIMPLE)
            offset_x		        [integer!]; cvPoint CV_DEFAULT(cvPoint(0,0))
            offset_y		        [integer!];cvPoint CV_DEFAULT(cvPoint(0,0))
            return: 		        [integer!]; pointer to CvContourScanner
        ]
        
        cvFindNextContour: "cvFindNextContour" [
        "Retrieves next contour"
	    scanner                     [CvContourScanner!]; CvContourScanner
	    return:                     [CvSeq!]	
        ]
         cvSubstituteContour: "cvSubstituteContour" [
        "Substitutes the last retrieved contour with the new one  (if the substitutor is null, the last retrieved contour is removed from the tree)"
	    scanner                     [CvContourScanner!]; CvContourScanner
	    new_contour                 [CvSeq!]	
        ]
        
        cvEndFindContours: "cvEndFindContours"  [
        "Releases contour scanner and returns pointer to the first outer contour"
	    scanner                     [CvContourScanner!]; CvContourScanner
	    return:                     [CvSeq!]	
        ]
        
        cvApproxChains: "cvApproxChains" [
        "Approximates a single Freeman chain or a tree of chains to polygonal curves"
            src_seq			[CvSeq!]
            storage			[CvMemStorage!]
            method			[integer!];CV_DEFAULT(0)
            parameter			[float!];CV_DEFAULT(0)
            minimal_perimeter	        [integer!];CV_DEFAULT(0)
            recursive			[integer!];CV_DEFAULT(0)
            return:                     [CvSeq!]	
        ]
        
        cvStartReadChainPoints: "cvStartReadChainPoints"  [
        {Initalizes Freeman chain reader.
        The reader is used to iteratively get coordinates of all the chain points.
        If the Freeman codes should be read as is, a simple sequence reader should be used}
            chain		        [CvChain!]
            reader		        [CvChainPtReader!]
        ]
        
        cvReadChainPoint: "cvReadChainPoint" [
        "Retrieves the next chain point"
            reader		    [CvChainPtReader!]
            return		    [CvPoint!]
        ]
        
        cvApproxPoly: "cvApproxPoly" [
        "Approximates a single polygonal curve (contour) or a tree of polygonal curves (contours)"
            src_seq                     [byte-ptr!] ;void*
            header_size                 [integer!]
            storage                     [CvMemStorage!]
            method                      [integer!]
            parameter                   [float!]
            parameter2                  [integer!] ;CV_DEFAULT(0)
            return:                     [CvSeq!]
        ]
       cvArcLength: "cvArcLength" [
        "Calculates perimeter of a contour or length of a part of contour"
            curve                       [byte-ptr!] ;void*
            slice_start_index           [integer!]; _CvSlice  ;CV_DEFAULT(CV_WHOLE_SEQ)
            slice_end_index             [integer!]
            is_closed                   [integer!]   ; CV_DEFAULT(-1)
            return:                     [float!]
        ]
        
        cvBoundingRect: "cvBoundingRect" [
        "Calculates contour boundning rectangle (update=1) or just retrieves pre-calculated rectangle (update=0)"
            points                      [CvArr!]
            update                      [integer!] ;CV_DEFAULT(0)
            return:                     [CvRect!] ; may be problematic 
        ]
        cvContourArea: "cvContourArea" [
        "Calculates area of a contour or contour segment"
            points                      [CvArr!]
            slice_start_index           [integer!] ;_CvSlice CV_DEFAULT(CV_WHOLE_SEQ))
            slice_end_index             [integer!] ;_CvSlice CV_DEFAULT(CV_WHOLE_SEQ))
            return:                     [float!]
        ]
        cvMinAreaRect2: "cvMinAreaRect2" [
        "Finds minimum area rotated rectangle bounding a set of points"
             points                      [CvArr!]
             storage                     [CvMemStorage!] ;CV_DEFAULT(NULL)
             return:                     [CvBox2D!]
        ]
        
        cvMinEnclosingCircle: "cvMinEnclosingCircle" [
        "Finds minimum enclosing circle for a set of points"
            points                      [CvArr!]
            center                      [CvPoint2D32f!] ;* pointer
            radius                      [float-ptr!]
            return:                     [integer!]
        ]
        
        cvMatchShapes: "cvMatchShapes" [
        "Compares two contours by matching their moments"
            object1                     [byte-ptr!]
            object2                     [byte-ptr!]
            method                      [integer!]
            parameter                   [float!]
            return:                     [float!]
        ]
        
        cvConvexHull2: "cvConvexHull2" [
        "Calculates exact convex hull of 2d point set"
            input                       [CvArr!]
            hull_storage                [byte-ptr!] ; void * ;CV_DEFAULT(NULL)
            orientation                 [integer!]  ;CV_DEFAULT(CV_CLOCKWISE)
            return_points               [integer!]   ;CV_DEFAULT(0)
            return:                     [CvSeq!]
        ]
        
        cvCheckContourConvexity: "cvCheckContourConvexity" [
        "Checks whether the contour is convex or not (returns 1 if convex, 0 if not)"
            contour                       [CvArr!]
            return:                       [integer!]
        ]
        
        cvConvexityDefects: "cvConvexityDefects" [
            contour                       [CvArr!]
            convexhull                    [CvArr!]
            storage                       [CvMemStorage!] ;CV_DEFAULT(NULL)
            return:                       [CvSeq!]
        ]
        
        cvFitEllipse2: "cvFitEllipse2" [
        "Fits ellipse into a set of 2d points"
            points                       [CvArr!]
            return:                      [CvBox2D!] ; may be problematic
        ]
        
        cvMaxRect: "cvMaxRect" [
            rect1                       [CvRect!]
            rect2                       [CvRect!]
            return:                     [CvRect!] ; may be problematic
        ]
        
        cvBoxPoints: "cvBoxPoints" [
        "Finds coordinates of the box vertices "
            box_center_x                    [float32!]  ;CvBox2D
            box_center_y                    [float32!]  ;CvBox2D
            box_size_width                  [float32!]  ;CvBox2D
            box_size_height                 [float32!]  ;CvBox2D
            box_angle                       [float32!]  ;CvBox2D
            pt_4                            [pointer! [float32!]] ; pointeur array 4 float32
        ]
        
        cvPointSeqFromMat: "cvPointSeqFromMat" [
        "Initializes sequence header for a matrix (column or row vector) of points - a wrapper for cvMakeSeqHeaderForArray (it does not initialize bounding rectangle!!!)"
            seq_kind                        [integer!]
            mat                             [CvArr!]
            contour_header                  [CvContour!]
            block                           [CvSeqBlock!]
            return:                         [CvSeq!]
        ]
        
         cvPointPolygonTest: "cvPointPolygonTest" [
            contour                         [CvArr!]
            pt_x                            [float32!]
            pt_y                            [float32!]
            measure_dist                    [integer!]
            return:                         [float!]
        ]
        
        cvCreateHist: "cvCreateHist" [
        "Creates new histogram"
            dims                            [integer!]
            sizes                           [pointer![integer!]]
            type                            [integer!]
            ranges                          [double-float-ptr!] ; ** float CV_DEFAULT(NULL)
            uniform                         [integer!]          ;CV_DEFAULT(1)
            return:                         [CvHistogram!]
        ]
        
        cvSetHistBinRanges: "cvSetHistBinRanges" [
        "Assignes histogram bin ranges"
            hist                            [CvHistogram!]
            ranges                          [double-float-ptr!] ; **float
            uniform                         [integer!]          ;CV_DEFAULT(1)
        ]
        
        cvMakeHistHeaderForArray: "cvMakeHistHeaderForArray" [
        "Creates histogram header for array"
            dims                            [integer!]
            sizes                           [int-ptr!]
            data                            [float-ptr!]
            ranges                          [double-float-ptr!] ; ** float CV_DEFAULT(NULL)
            uniform                         [integer!]
            return:                         [CvHistogram!]
        ]
        
        cvReleaseHist: "cvReleaseHist" [
        "Releases histogram"
            CvHistogram                     [double-byte-ptr!]
        ]
        
        cvClearHist: "cvClearHist" [
            hist                            [CvHistogram!]
        ]
        
        cvGetMinMaxHistValue: "cvGetMinMaxHistValue" [
        "Finds indices and values of minimum and maximum histogram bins"
            hist                            [CvHistogram!]
            min_value                       [float-ptr!]
            max_value                       [float-ptr!]
            min_idx                         [int-ptr!] ;CV_DEFAULT(NULL)
            max_idx                         [int-ptr!] ;CV_DEFAULT(NULL)
        ]
        
        cvNormalizeHist: "cvNormalizeHist" [
        "Normalizes histogram by dividing all bins by sum of the bins, multiplied by <factor>. After that sum of histogram bins is equal to <factor>"
            hist                            [CvHistogram!]
            factor                          [float!]
        ]
        
        cvThreshHist: "cvThreshHist" [
        "Clear all histogram bins that are below the threshold"
            hist                            [CvHistogram!]
            threshold                       [float!]
            
        ]
        
        cvCompareHist: "cvCompareHist" [
        "Compares two histogram"
            hist1                          [CvHistogram!]
            hist2                          [CvHistogram!]
            method                         [integer!]
            return:                        [float!]
        ]
        
        cvCopyHist: "cvCopyHist" [
        "Copies one histogram to another. Destination histogram is created if the destination pointer is NULL"
            src                          [CvHistogram!]
            dst                          [struct! [hist [CvHistogram!]]] ;CvHistogram**
        ]
        
        cvCalcBayesianProb: "cvCalcBayesianProb" [
        "Calculates bayesian probabilistic histograms (each or src and dst is an array of <number> histograms"
            src                         [struct! [hist [CvHistogram!]]] ;CvHistogram**
            number                      [integer!]
            dst                         [struct! [hist [CvHistogram!]]] ;CvHistogram**
        ]
        
        cvCalcArrHist: "cvCalcArrHist" [
            arr                         [struct! [arr [CvArr!]]] ; ** CvArr
            hist                        [CvHistogram!]
            accumulate                  [integer!]          ; CV_DEFAULT(0)
            mask                        [CvArr!]            ;CV_DEFAULT(NULL)
        ]
        
        cvCalcArrBackProject: "cvCalcArrBackProject" [
        "Calculates back project"
            image                       [struct! [arr [CvArr!]]] ; ** CvArr
            dst                         [Cvarr!] ; * CvArr
            hist                        [CvHistogram!]
        ]
        
        cvCalcArrBackProjectPatch: "cvCalcArrBackProjectPatch" [
        "Does some sort of template matching but compares histograms of template and each window location"
            image                       [struct! [arr [CvArr!]]] ; ** CvArr
            dst                         [Cvarr!] ; * CvArr
            range_w                     [integer!] ; _CvSize
            range_h                     [integer!] ; _CvSize
            hist                        [CvHistogram!]
            method                      [integer!]
            factor                      [float!]
        ]
        
        cvCalcProbDensity: "cvCalcProbDensity" [
        "calculates probabilistic density (divides one histogram by another)"
            hist1                          [CvHistogram!]
            hist2                          [CvHistogram!]
            dst_hist                       [CvHistogram!]
            scale                          [float!]
        ]
        
        cvEqualizeHist: "cvEqualizeHist" [
        "equalizes histogram of 8-bit single-channel image"
            src                             [CvArr!]
            dst                             [CvArr!]
        ]
        
        cvDistTransform: "cvDistTransform" [
        "Applies distance transform to binary image"
            src                 [CvArr!]
            dst                 [CvArr!]
            distance_type       [integer!] ; CV_DEFAULT(CV_DIST_L2)
            mask_size           [integer!] ; CV_DEFAULT(3)
            mask                [float-ptr!] ; CV_DEFAULT(NULL)
            labels              [CvArr!] ; CV_DEFAULT(NULL) 
        ]
        
         cvThreshold: "cvThreshold" [
            src                 [CvArr!]
            dst                 [CvArr!]
            threshold           [float!]
            max_value           [float!]
            threshold_type      [integer!]
            return:             [float!] 
        ]
        
        cvAdaptiveThreshold: "cvAdaptiveThreshold" [
        "Applies adaptive threshold to grayscale image."
            src                 [CvArr!]
            dst                 [CvArr!]
            max_value           [float!]
            adaptive_method     [integer!]  ;CV_DEFAULT(CV_ADAPTIVE_THRESH_MEAN_C)
            threshold_type      [integer!]  ; CV_DEFAULT(CV_THRESH_BINARY)
            block_size          [integer!]  ; CV_DEFAULT(3)
            param1              [float!]    ; CV_DEFAULT(5))
        ]
        
        cvFloodFill: "cvFloodFill" [
        "Fills the connected component until the color difference gets large enough"
            image               [CvArr!]
            seed_point_x        [integer!]
            seed_point_y        [integer!]
            new_val0            [float!]    ;CvScalar
            new_val1            [float!]    ;CvScalar
            new_val2            [float!]    ;CvScalar
            new_val3            [float!]    ;CvScalar
            lo_diff0            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0))
            lo_diff1            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            lo_diff2            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            lo_diff3            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            up_diff0            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0))
            up_diff1            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            up_diff2            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            up_diff3            [float!]    ;CvScalar CV_DEFAULT(cvScalarAll(0)
            comp                [CvConnectedComp!]
            flags               [integer!]  ;CV_DEFAULT(4)
            mask                [CvArr!]    ; CV_DEFAULT(NULL)  
        ]
        
        cvCanny: "cvCanny" [
            image               [CvArr!]
            edges               [CvArr!]
            threshold1          [float!]
            threshold2          [float!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
        ]
        
        cvPreCornerDetect: "cvPreCornerDetect" [
        "Calculates constraint image for corner detection Dx^2 * Dyy + Dxx * Dy^2 - 2 * Dx * Dy * Dxy."
            image               [CvArr!]
            edges               [CvArr!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
        ]
        
        cvCornerEigenValsAndVecs: "cvCornerEigenValsAndVecs" [
        "Calculates eigen values and vectors of 2x2 gradient covariation matrix at every image pixel"
            image               [CvArr!]
            eigenvv             [CvArr!]
            block_size          [integer!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
        ]
        cvCornerMinEigenVal: "cvCornerMinEigenVal" [
        "Calculates minimal eigenvalue for 2x2 gradient covariation matrix at every image pixel"
            image               [CvArr!]
            eigenval            [CvArr!]
            block_size          [integer!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
        ]
        
         cvCornerHarris: "cvCornerHarris" [
        "Harris corner detector: Calculates det(M) - k*(trace(M)^2), where M is 2x2 gradient covariation matrix for each pixel"    
            image               [CvArr!]
            harris_responce     [CvArr!]
            block_size          [integer!]
            aperture_size       [integer!] ; CV_DEFAULT(3)
            k                   [float!]   ; CV_DEFAULT(0.04)
        ]
        
        cvFindCornerSubPix: "cvFindCornerSubPix" [
        "Adjust corner position using some sort of gradient search"
            image               [CvArr!]
            corners             [CvPoint2D32f!]
            count               [integer!]
            win_w               [integer!] ; CvSize
            win_h               [integer!] ; CvSize
            zero_zone_w         [integer!] ; CvSize
            zero_zone_h         [integer!] ; CvSize
            criteria            [CvTermCriteria!] 
        ]
        
        cvGoodFeaturesToTrack: "cvGoodFeaturesToTrack" [
        "Finds a sparse set of points within the selected region that seem to be easy to track"
            image               [CvArr!]
            eig_image           [CvArr!]
            temp_image          [CvArr!]
            corners             [CvPoint2D32f!]
            corner_count        [int-ptr!]
            quality_level       [float!]
            min_distance        [float!]
            mask                [CvArr!]   ;CV_DEFAULT(NULL)
            block_size          [integer!] ;CV_DEFAULT(3)
            use_harris          [integer!] ; CV_DEFAULT(0)
            k                   [float!]   ; CV_DEFAULT(0.04)
        ]
        
        cvHoughLines2: "cvHoughLines2" [
        "Finds lines on binary image using one of several methods"
            image               [CvArr!]
            line_storage        [byte-ptr!] ;*void
            method              [integer!]
            rho                 [float!]
            theta               [float!]
            threshold           [integer!]
            param1              [float!] ; CV_DEFAULT(0)
            param2              [float!] ; CV_DEFAULT(0)
            return:             [CvSeq!]
        ]
        
        cvHoughCircles: "cvHoughCircles" [
        "Finds circles in the image"
            image               [CvArr!]
            circle_storage      [byte-ptr!] ;*void
            method              [integer!]
            dp                  [float!]
            min_dist            [float!]
            param1              [float!] ; CV_DEFAULT(100)
            param2              [float!] ; CV_DEFAULT(100)
            min_radius          [integer!] ; CV_DEFAULT(0)
            max_radius          [integer!]
            return:             [CvSeq!]
        ]
        
        cvFitLine: "cvFitLine" [
        "Fits a line into set of 2d or 3d points in a robust way (M-estimator technique)"
            points              [CvArr!]
            dist_type           [integer!]
            param               [float!]
            reps                [float!]
            aeps                [float!]
            line                [float-ptr!]
        ]
        
        cvLine: "cvLine" [
        "Draws 4-connected, 8-connected or antialiased line segment connecting two points "
            img				[CvArr!]
            pt1_x			[integer!] ; normally CvPoint
            pt1_y 			[integer!]
            pt2_x 			[integer!] ; normally CvPoint
            pt2_y 			[integer!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!] ;
            line_type		        [integer!] ;CV_DEFAULT(8)
            shift			[integer!] ;CV_DEFAULT(0)
        ]
        
        cvRectangle: "cvRectangle" [
        "Draws a rectangle given two opposite corners of the rectangle (pt1 & pt2),if thickness<0 (e.g. thickness == CV_FILLED), the filled box is drawn" 
            img				[CvArr!]
            pt1_x			[integer!]
            pt1_y 			[integer!]
            pt2_x 			[integer!]
            pt2_y 			[integer!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!]
            line_type		        [integer!];CV_DEFAULT(8)
            shift			[integer!];CV_DEFAULT(0)
        ]
        
        cvRectangleR: "cvRectangleR" [
        "Draws a rectangle given two opposite corners of the rectangle (pt1 & pt2),if thickness<0 (e.g. thickness == CV_FILLED), the filled box is drawn" 
            img				[CvArr!]
            r_x			        [integer!] ; CvRect structure
            r_y 			[integer!]
            r_w 			[integer!]
            r_h 			[integer!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!]
            line_type		        [integer!];CV_DEFAULT(8)
            shift			[integer!];CV_DEFAULT(0)
        ]
        
        cvCircle: "cvCircle" [
        "Draws a circle with specified center and radius. Thickness works in the same way as with cvRectangle"
            img				[CvArr!]
            center_x		        [integer!] ; CvPoint Structure
            center_y 		        [integer!]
            radius			[integer!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!];CV_DEFAULT(1)
            line_type		        [integer!];CV_DEFAULT(8)
            shift			[integer!];CV_DEFAULT(0)
        ]
        
        cvEllipse: "cvEllipse" [
            img				[CvArr!]
            center_x		        [integer!] ; CvPoint Structure
            center_y 		        [integer!]
            width			[integer!]
            height			[integer!]
            angle			[float!]
            start_angle		        [float!]
            end_angle		        [float!]
            b				[float!]
            g				[float!]
            r				[float!]
            a				[float!]
            thickness		        [integer!];CV_DEFAULT(1)
            line_type		        [integer!];CV_DEFAULT(8)
            shift			[integer!];CV_DEFAULT(0)
        ]
        
        cvFillConvexPoly: "cvFillConvexPoly" [
        "Fills convex or monotonous polygon"
			img				[CvArr!]
			pts				[int-ptr!]  ; * CvPoint! pointer to array of points
			npts			[integer!] ; nb of vertices
			b				[float!]
			g				[float!]
			r				[float!]
			a				[float!]
			line_type		        [integer!];CV_DEFAULT(8)
			shift			        [integer!];CV_DEFAULT(0)
    ]
    
    cvFillPoly: "cvFillPoly" [
    ";Fills an area bounded by one or more arbitrary polygons"
		img					[CvArr!]
		pts					[double-int-ptr!];  ** CvPoints pointer to array of CvPoints
		npts			    [int-ptr!] ;pointer nb of points by polygons
		contours		    [integer!] ; nb of polygons to draw
		b					[float!]
		g					[float!]
		r					[float!]
		a					[float!]
		line_type		    [integer!];CV_DEFAULT(8)
		shift			    [integer!];CV_DEFAULT(0)
    ]
    
    cvPolyLine: "cvPolyLine" [
    "Draws one or more polygonal curves"
        img             [CvArr!]
        pts				[double-int-ptr!];  ** CvPoints pointer to array of CvPoints ;Array of pointers to polylines.
        npts			[int-ptr!] ; pointer to int array ; Array of polyline vertex counters
        contours		[integer!] ;  Array of polyline vertex counters
        is_closed       [integer!] ; closed or not
        b				[float!]
        g				[float!]
        r				[float!]
        a				[float!]
        thickness       [integer!];CV_DEFAULT(1)
		line_type		[integer!];CV_DEFAULT(8)
		shift			[integer!];CV_DEFAULT(0)
    ]
    
    cvClipLine: "cvClipLine" [
    "Clips the line segment connecting *pt1 and *pt2 by the rectangular window (0<=x<img_size.width, 0<=y<img_size.height)."
	width 		[integer!]; x CvSize
	height 		[integer!]; y CvSize
	*pt1		[CvPoint!]; pointer to cvPoint
	*pt2		[CvPoint!] ; pointer to cvPoint
	return:		[integer!]
    ]
    
    cvInitLineIterator: "cvInitLineIterator" [
    {Initializes line iterator. Initially, line_iterator->ptr will point
    to pt1 (or pt2, see left_to_right description) location in the image.
    Returns the number of pixels on the line between the ending points}
	img			[CvArr!]
	pt1_x			[integer!]
	pt1_y 			[integer!]
	pt2_x 			[integer!]
	pt2_y 			[integer!]
	line_iterator           [CvLineIterator!] ; pointer 
	connectivity	        [integer!] ;CV_DEFAULT(8)
	left_to_right	        [integer!] ;CV_DEFAULT(0)
	return:			[integer!]
    ]
    
    cvInitFont: "cvInitFont" [
    "Initializes font structure used further in cvPutText"
	font				[CvFont!] ; pointer to fonts CvFont!
	font_face			[integer!]
	hscale				[float!]
	vscale				[float!]
	shear				[float!]; CV_DEFAULT(0) ;italic
	thickness			[integer!]; CV_DEFAULT(1)
	line_type			[integer!];CV_DEFAULT(8))
    ]
    
    cvPutText: "cvPutText" [
    "Renders text stroke with specified font and color at specified location. CvFont should be initialized with cvInitFont"
	img				[CvArr!]
	text			        [c-string!]
	orgx			        [integer!]
	orgy			        [integer!]
	font			        [CvFont!]; & CvFont!font pointer 
	b				[float!]
	g				[float!]
	r				[float!]
	a				[float!]
    ]
    
    cvGetTextSize: "cvGetTextSize" [
    "Calculates bounding box of text stroke (useful for alignment)"
	text			[c-string!]
	font			[CvFont!]               ; pointer to CvFont
        text_size               [CvSize!]               ; pointer to CvSize is updated by the routine ;
	baseline		[int-ptr!]   ; pointer updated by the routine  (byte-ptr can be also used )
    ]
    
    cvColorToScalar: "cvColorToScalar" [
    { Unpacks color value, if arrtype is CV_8UC?, <color> is treated as
     packed color value, otherwise the first channels (depending on arrtype)
    of destination scalar are set to the same value = <color> }
	packed_color	        [float!]
	arrtype			[integer!]
	return: 		[CvScalar!] ; not a pointer 		
    ]
    
    cvEllipse2Poly: "cvEllipse2Poly" [
    {Returns the polygon points which make up the given ellipse.  The ellipse is define by
    the box of size 'axes' rotated 'angle' around the 'center'.  A partial sweep
    of the ellipse arc can be done by spcifying arc_start and arc_end to be something
    other than 0 and 360, respectively.  The input array 'pts' must be large enough to
    hold the result.  The total number of points stored into 'pts' is returned by this function.}

	center_x			[integer!];_cvPoint
	center_y			[integer!];cvPoint
	axe_x				[integer!];cvSize
	axe_y				[integer!];cvSize
	angle				[integer!]
	arc_start			[integer!]
	arc_end				[integer!]
        *pts                            [int-ptr!] ; pointeur to array CvPoints
	delta				[integer!]; 
	return:				[integer!]
    ]
    
    cvDrawContours: "cvDrawContours" [
    "Draws contour outlines or filled interiors on the image"
	img			        [CvArr!]
	contour		                [CvSeq!]
	eb				[float!]
	eg				[float!]
	er				[float!]
	ea				[float!]
	hb				[float!]
	hg				[float!]
	hr				[float!]
	ha				[float!]
	thickness 		        [integer!];CV_DEFAULT(1)
	line_type		        [integer!];CV_DEFAULT(8)
	offset_x		        [integer!];CV_DEFAULT(0)
	offset_y		        [integer!];CV_DEFAULT(0)
    ]
        
    ]; end imgproc
]; end import

;Inline macros and functions

#define cvContourPerimeter (contour) [cvArcLength contour CV_WHOLE_SEQ 1]
#define  cvCalcBackProject(image dst hist) [(cvCalcArrBackProject image dst hist)]
#define  cvCalcBackProjectPatch (image dst range hist method factor) [
            (cvCalcArrBackProjectPatch image dst range hist method factor)]
            
#define CV_NEXT_LINE_POINT( line_iterator ) [
        _line_iterator_mask: declare cvInitLineIterator!
        either line_iterator/err < 0 [_line_iterator_mask: -1] [_line_iterator_mask: 0]
        line_iterator/err: line_iterator/err + line_iterator/delta + (line_iterator/plus_delta AND _line_iterator_mask)
        line_iterator/ptr: line_iterator/ptr + line_iterator/minus_step + (line_iterator/plus_step AND _line_iterator_mask)
]

cvEllipseBox: func [img [CvArr!] box [CvBox2D!] color [CvScalar!]thickness [integer!] line_type [integer!] shift [integer!]
/local axes x y]
[ 
  axes: declare CvSize!
  axes/width:  0 + (box/height * 0.5)
  axes/height: 0 + (box/width * 0.5)
  x: 0 + box/x
  y: 0 + box/y
  cvEllipse img x y axes/width  axes/height (0.0 + box/angle) 0.0 360.0 color/v2 color/v1 color/v0 color/v3 thickness line_type shift
]

cvFont: func [scale [float!] thickness [integer!] return: [CvFont!] /local font]
[
    font: declare CvFont!
    cvInitFont font CV_FONT_HERSHEY_PLAIN scale scale 0.0 thickness CV_AA
    font
]
        