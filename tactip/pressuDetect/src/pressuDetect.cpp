#include <ros/ros.h>
#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

namespace enc = sensor_msgs::image_encodings;

static const char WINDOW[] = "Image window";
cv::Mat mImage;
//*ImageConverter Class 
/**ImageConverter Class does:
* 1. Handle Image transportation
* 2. Setup the gscam image and convert it to a ROS image
* 3. Opens a window named WINDOW
* 4. Contains the destructor - which only closes the open image window
*/
class ImageConverter
{
	ros::NodeHandle nh_;
	image_transport::ImageTransport it_;
	image_transport::Subscriber image_sub_;
	image_transport::Publisher image_pub_;
  
public:
	/*!
	 * \subscribes to the raw image from gscam
	 */
	ImageConverter()
	: it_(nh_)
	{
		image_pub_ = it_.advertise("out", 1);
		image_sub_ = it_.subscribe("/gscam/image_raw", 1, &ImageConverter::imageCb, this);

		cv::namedWindow(WINDOW);
	}

	~ImageConverter() /** <ImageConverter Deconstructor*/
	{
		cv::destroyWindow(WINDOW);
	}

void imageCb(const sensor_msgs::ImageConstPtr& msg)
{
	cv_bridge::CvImagePtr cv_ptr;
	try
	{
		cv_ptr = cv_bridge::toCvCopy(msg, enc::BGR8);
	}
	catch (cv_bridge::Exception& e)
	{
		ROS_ERROR("cv_bridge exception: %s", e.what());
		return;
	}

	//if (cv_ptr->image.rows > 60 && cv_ptr->image.cols > 60)
		//cv::circle(cv_ptr->image, cv::Point(50, 50), 10, CV_RGB(255,0,0));
		
		//pressure detection code
		cv::cvtColor(cv_ptr->image,cv_ptr->image, CV_BGR2GRAY);
		cv::threshold(cv_ptr->image, mImage, 110, 130, CV_THRESH_BINARY);
		
		IplImage ipl_img = mImage;
		int count = 0;
		int x, y = 0;
		cv::Scalar s;
		//start x at something like 120 then do to 300 rather than img.height
		for(x=200; x<400; x++){ //for(x=0; x<ipl_img.height; x++){
			for(y=100; y<300; y++){ //for(y=0; y<ipl_img.width; y++){
				s = cvGet2D(&ipl_img,x,y);
				if(s.val[0] == 130){		//if we have found a black pixel
					count++;		//increase counters
									}
			}
		}
		//count = count - 9000;
		printf("%d\n",count);

		cv::imshow(WINDOW, mImage);
		cv::waitKey(3);
    
		image_pub_.publish(cv_ptr->toImageMsg());
}
};

int main(int argc, char** argv)
{
	ros::init(argc, argv, "image_converter");
	//ros::NodeHandle tacPressure;		//this is what ROS uses to connect to a node
	ImageConverter ic;
	ros::spin();
	//ros::Publisher tacPresMsg = tacPressure.advertise<std_msgs::Float32>("tacPressure", 100);
	//std_msgs::Float32 tacPressure; 
	//tacPressure.data = count;
	//tacPresMsg.publish(tacPressure);
	return 0;
}

