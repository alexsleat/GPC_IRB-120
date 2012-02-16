#include <stdio.h>
#include "cv.h"
#include "highgui.h"

int PxCount(IplImage *PxC);
 
int main( int argc, char** argv )
{
  /* data structure for the image */
	IplImage *img = 0;
	IplImage *Right = 0;
	IplImage *Left = 0;
	IplImage* src = 0, * res = 0, * roi = 0;
	int aX0 = 0, aY0 = 0, aX1 = 0, aY1 = 0;
	int bX0 = 0, bY0 = 0, bX1 = 0, bY1 = 0;
	
	/* check for supplied argument */
	if( argc < 2 ) {
		fprintf( stderr, "Usage: loading <filename>\n" );
	return 1;
	}
   
	/* load the image,
	 use CV_LOAD_IMAGE_GRAYSCALE to load the image in grayscale */
	img = cvLoadImage( argv[1], CV_LOAD_IMAGE_GRAYSCALE );
	cvThreshold(img, img, 110, 120, CV_THRESH_BINARY);	//Threshold image
   
	/* always check */
	if( img == 0 ) {
		fprintf( stderr, "Cannot load file %s!\n", argv[1] );
	return 1;
	}
   
	cvNamedWindow( "image", CV_WINDOW_AUTOSIZE ); 	//create a window 
	cvShowImage( "image", img );	//display the image 
   
   	/*src = cvCloneImage(img);
	res = cvCreateImage(cvGetSize(src), 8, 1); //last arg was 3
	roi = cvCreateImage(cvGetSize(src), 8, 1);
	cvZero(roi);	//prepare the 'ROI' image 
	*/
	
	//set the rectangle ROI's
	aX0 = (img->width/2);
	printf("aX0 = %d\n", aX0);
	aY0 = ((img->height/2)+0)-40;
	printf("aY0 = %d\n", aY0);	
	aX1 = (img->width/2)+120;
	printf("aX1 = %d\n", aX1);
	aY1 = ((img->height/2)+0)+40;		
	printf("aY1 = %d\n", aY1);
	
	printf("aX1-aX0 = %d\n",(aX1-aX0));
	printf("aY1-aY0 = %d\n",(aY1-aY0));
	
	bX0 = (img->width/2)-120;
	printf("bX0 = %d\n", bX0);
	bY0 = ((img->height/2)+0)-40;
	printf("bY0 = %d\n", bY0);	
	bX1 = (img->width/2);
	printf("bX1 = %d\n", bX1);
	bY1 = ((img->height/2)+0)+40;		
	printf("bY1 = %d\n", bY1);

	printf("bX1-bX0 = %d\n",(bX1-bX0));
	printf("bY1-bY0 = %d\n",(bY1-bY0));


	IplImage* newImage2 = 0;
	cvSetImageROI(img, cvRect(aX0, aY0, aX1-aX0, aY1-aY0));	

	newImage2 = cvCreateImage(cvGetSize(img), img->depth, img->nChannels);
	cvSetImageROI(img, cvRect(bX0, bY0, bX1-bX0, bY1-aY0));	
	cvCopy(img, newImage2, NULL);
	cvResetImageROI(img);
	Left = cvCloneImage(newImage2);
	
	printf("The pixel count on the Left is %d\n",PxCount(Left));

	IplImage* newImage = 0;
	cvSetImageROI(img, cvRect(aX0, aY0, aX1-aX0, aY1-aY0));	

	newImage = cvCreateImage(cvGetSize(img), img->depth, img->nChannels);
	cvCopy(img, newImage, NULL);
	cvResetImageROI(img);
	Right = cvCloneImage(newImage);
	
	printf("The pixel count on the Right is %d\n",PxCount(Right));

	   	
   	//draw the rectangle on the original image for reference
	CvPoint pt1, pt2;
	pt1.x = aX0;
	pt1.y = aY0;
	pt2.x = aX1;
	pt2.y = aY1;
	cvRectangle(img, pt1, pt2, CV_RGB(255,0,0),2, 8,0); 
	
	CvPoint bpt1, bpt2;
	bpt1.x = bX0;
	bpt1.y = bY0;
	bpt2.x = bX1;
	bpt2.y = bY1;
	cvRectangle(img, bpt1, bpt2, CV_RGB(255,0,0),2, 8,0); 
	
	//cvThreshold(Right, Right, 110, 120, CV_THRESH_BINARY);	//Threshold image
	cvNamedWindow( "image", CV_WINDOW_AUTOSIZE ); 	//create a window 
	cvShowImage( "image", img );	//display the image 
	cvNamedWindow( "Left", CV_WINDOW_AUTOSIZE );
	cvShowImage( "Left", Left );
	cvNamedWindow( "Right", CV_WINDOW_AUTOSIZE );
	cvShowImage( "Right", Right );
   
   
	/* wait until user press a key */
	cvWaitKey(0);
   
	/* free memory */
	cvDestroyWindow( "image" );
	cvReleaseImage( &img );
	cvDestroyWindow( "Right" );
	cvReleaseImage( &Right );
	cvDestroyWindow( "Left" );
	cvReleaseImage( &Left );


   
	return 0;
	}

int PxCount(IplImage *PxC)
{
	int whitePixels = 0;
	int value;

	for ( int i=0 ; i < PxC->height ; i++ )
	{
		uchar* ptr = (uchar*) (PxC->imageData + i * PxC->widthStep );
		for ( int j=0 ; j < PxC->width ; j++ )
		{
			value = ptr[j];
			if ( value == 120 )
			whitePixels++;	
		}
	}
	
	
	return whitePixels;

}


