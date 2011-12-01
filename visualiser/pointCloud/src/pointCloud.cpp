#include <ros/ros.h>
#include <visualization_msgs/Marker.h>
#include <pcl_ros/point_cloud.h>
#include <pcl/point_types.h>

#include "std_msgs/MultiArrayLayout.h"
#include "std_msgs/MultiArrayDimension.h"
#include "std_msgs/Float32MultiArray.h"

#define MAX_POINTS 999

typedef pcl::PointCloud<pcl::PointXYZRGB> PointCloud;

float Arr[6];

void arrayCallback(const std_msgs::Float32MultiArray::ConstPtr& array);

float x = 0.0, y = 0.0, z = 0.0;
float lock_x = 0.0, lock_y = 0.0, lock_z = 3.0;

int main( int argc, char** argv )
{
	ros::init(argc, argv, "pointCloud");
	ros::NodeHandle n;

	//Publish
	//ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 10);
	ros::Publisher pub = n.advertise<PointCloud> ("tactip", 100);	

	//Subscribe
	ros::Subscriber sub3 = n.subscribe("array", 100, arrayCallback);

	//Set loop rate (times per second)
	ros::Rate r(30);

	PointCloud::Ptr msg (new PointCloud);
	msg->header.frame_id = "gpc_frame";
	msg->height = 1;
	msg->width = MAX_POINTS;
	msg->points.resize (msg->width * msg->height);

	ros::spinOnce();

	int counter = 0;

	while (ros::ok())
	{

		x = Arr[0];
		y = Arr[1];
		z = Arr[2];
		//don't add another point if it's the same as the last one. This should reduce the amount of memory wasted.
		if(x != lock_x || y != lock_y || z != lock_z)
		{
			ROS_INFO("%d = x: %f, y: %f, z: %f, r: %d, g: %d, b: %d",counter, x, y, z, int(Arr[3]), int(Arr[4]), int(Arr[5]));

			msg->points[counter].x = lock_x = x;	
			msg->points[counter].y = lock_y = y;	
			msg->points[counter].z = lock_z = z;
	
			msg->points[counter].r = int(Arr[3]);
			msg->points[counter].g = int(Arr[4]);
			msg->points[counter].b = int(Arr[5]);

			msg->header.stamp = ros::Time::now ();
			pub.publish(msg);

			counter ++;
		}


		
		ros::spinOnce();
		r.sleep();

		if(counter >= MAX_POINTS)
		{
	
			return 0;
		}


	}
}

/*************************************************
** Returns the X Pose				**
*************************************************/

void arrayCallback(const std_msgs::Float32MultiArray::ConstPtr& array)
{

	int i = 0;
	// print all the remaining numbers
	for(std::vector<float>::const_iterator it = array->data.begin(); it != array->data.end(); ++it)
	{
		Arr[i] = *it;
		i++;
	}

	

	return;
}
