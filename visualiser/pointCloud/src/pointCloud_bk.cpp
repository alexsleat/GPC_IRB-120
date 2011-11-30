#include <ros/ros.h>
#include <visualization_msgs/Marker.h>
#include <pcl_ros/point_cloud.h>
#include <pcl/point_types.h>

#include "std_msgs/Float32.h"

typedef pcl::PointCloud<pcl::PointXYZ> PointCloud;

void pointXCallback(const std_msgs::Float32::ConstPtr& pointX);
void pointYCallback(const std_msgs::Float32::ConstPtr& pointY);
void pointZCallback(const std_msgs::Float32::ConstPtr& pointZ);
void pointACallback(const std_msgs::Float32::ConstPtr& pointA);

float x = 0.0, y = 0.0, z = 0.0, a = 0.0;
float lock_x = 0.0, lock_y = 0.0, lock_z = 0.0, lock_a = 0.0;

int main( int argc, char** argv )
{
	ros::init(argc, argv, "pointCloud");
	ros::NodeHandle n;

	//Publish
	//ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 10);
	ros::Publisher pub = n.advertise<PointCloud> ("tactip", 100);	

	//Subscribe
	ros::Subscriber pointX = n.subscribe("pointX", 100, pointXCallback);
	ros::Subscriber pointY = n.subscribe("pointY", 100, pointYCallback);
	ros::Subscriber pointZ = n.subscribe("pointZ", 100, pointZCallback);
	ros::Subscriber pointA = n.subscribe("pointA", 100, pointACallback);

	//Set loop rate (times per second)
	ros::Rate r(30);

	PointCloud::Ptr msg (new PointCloud);
	msg->header.frame_id = "gpc_frame";
	msg->height = 100;
	msg->width = 100;
	
	msg->points.push_back (pcl::PointXYZ(x, y, z));	
	msg->header.stamp = ros::Time::now ();
	pub.publish(msg);

	ros::spinOnce();

	int counter = 0;

	while (ros::ok())
	{

		if(x != lock_x)
		{
			ROS_INFO("x: %f, y: %f, z: %f", x, y, z);

			msg->points.push_back (pcl::PointXYZ(x, y, z));	
			lock_x = x;
			lock_y = y;
			lock_z = z;

			msg->header.stamp = ros::Time::now ();
			pub.publish(msg);	 //el problem. the beef you're having, what is it?
			counter ++;
		}
		
		ros::spinOnce();
		r.sleep();

		if(counter >= 99)
		{
	
			return 0;
		}


	}
}

/*************************************************
** Returns the X Pose				**
*************************************************/

void pointXCallback(const std_msgs::Float32::ConstPtr& pointX)
{
	x = pointX->data;
	return;
}

/*************************************************
** Returns the Y Pose				**
*************************************************/

void pointYCallback(const std_msgs::Float32::ConstPtr& pointY)
{
	y = pointY->data;
	return;
}

/*************************************************
** Returns the Z Pose				**
*************************************************/

void pointZCallback(const std_msgs::Float32::ConstPtr& pointZ)
{
	z = pointZ->data;
	return;
}

/*************************************************
** Returns the A Pose				**
*************************************************/

void pointACallback(const std_msgs::Float32::ConstPtr& pointA)
{
	a = pointA->data;
	return;
}
