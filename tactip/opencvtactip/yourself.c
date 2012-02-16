#include <cv.h>
#include <highgui.h>
#include <stdio.h>

#define DELAY 2

int quit = 0;
CvCapture *capture = 0;
IplImage *frame = 0;
IplImage* img = 0; 
IplImage* threshold = 0;
IplImage* grays = 0;
IplImage* src = 0, * res = 0, * roi = 0;
FILE *pypipe = popen("gnuplot -persist","w");


int main( int argc, char** argv )
{

  //Set up GNU PLOT
	fprintf(pypipe, "set isosamples 40\n");
	fprintf(pypipe, "set hidden3d\n");
	fprintf(pypipe, "set xrange [-8.000:8.000]\n");
	fprintf(pypipe, "set yrange [-8.000:8.000]\n");
	fprintf(pypipe, "set zrange [-2.000:2.000]\n");
	fprintf(pypipe, "set terminal png\n");
	fprintf(pypipe, "set output 'graph.png'\n");
	fprintf(pypipe, "set title 'We are plotting from C'\n");
	fprintf(pypipe, "set xlabel 'Label X'\n");
	fprintf(pypipe, "set ylabel 'Label Y'\n");

	capture = cvCaptureFromCAM(0);
	frame = cvQueryFrame(capture);

	while(quit != 1048689)
	{
	
		frame = cvQueryFrame(capture);
		//if (!frame) break;
		img = cvCreateImage(cvGetSize(frame), IPL_DEPTH_8U, 1);
		grays = cvCreateImage(cvGetSize(frame), IPL_DEPTH_8U, 1);
		img = cvCloneImage(frame);
		cvCvtColor(frame, grays, CV_BGR2GRAY);
		img = cvCloneImage(grays);
		
		//Threshold image
		threshold = cvCloneImage(img);
		cvThreshold(img, threshold, 110, 120, CV_THRESH_BINARY);
		img = cvCloneImage(threshold);
		
		src = cvCloneImage(img);
		res = cvCreateImage(cvGetSize(src), 8, 1); //last arg was 3
		roi = cvCreateImage(cvGetSize(src), 8, 1);

		/* prepare the 'ROI' image */
		cvZero(roi);
		cvCircle(roi, cvPoint(310,250), 120, CV_RGB(255, 255, 255), -1, 8, 0); /* Note that you can use any shape for the ROI */
		cvAnd(src, src, res, roi); /* extract a subimage smaller than the borders of the sensor */
	
		img = cvCloneImage(res);
		
		int whitePixels = 0;
		int value;

		for ( int i=0 ; i < img->height ; i++ )
		{
			uchar* ptr = (uchar*) (img->imageData + i * img->widthStep );
			for ( int j=0 ; j < img->width ; j++ )
			{
				value = ptr[j];
				if ( value == 120 )
				whitePixels++;	
			}
		}
		
		whitePixels = whitePixels - 5000;
		printf("White pixels = %d\n", whitePixels);
		fprintf(pypipe, "plot '%d' using 1:2\n", whitePixels); //print to the pipes

		//uchar* ptr = (uchar*) (img->imageData + i * img->widthStep );
		cvNamedWindow( "Source", 1 );
		cvShowImage( "Source", img );
		cvNamedWindow( "RAW", 1 );
		cvShowImage( "RAW", grays );
	
		//check for q to quit
		quit = cvWaitKey(1);
 	   	cvWaitKey(DELAY); // delay for a moment, delay is under 2 it doesn't seem to work
 	   	cvReleaseImage(&src);
 	   	cvReleaseImage(&threshold);	
    	}
    	return 0;
}

