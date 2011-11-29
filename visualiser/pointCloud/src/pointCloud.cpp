#include <ros/ros.h>
#include <visualization_msgs/Marker.h>

#include "std_msgs/Float32.h"

void pointXCallback(const std_msgs::Float32::ConstPtr& pointX);
void pointYCallback(const std_msgs::Float32::ConstPtr& pointY);
void pointZCallback(const std_msgs::Float32::ConstPtr& pointZ);
void pointACallback(const std_msgs::Float32::ConstPtr& pointA);

float x = 0.0, y = 0.0, z = 0.0, a = 0.0;

int main( int argc, char** argv )
{
	ros::init(argc, argv, "pointCloud");
	ros::NodeHandle n;

	//Publish
	ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 10);
	//Subscribe
	ros::Subscriber pointX = n.subscribe("pointX", 100, pointXCallback);
	ros::Subscriber pointY = n.subscribe("pointY", 100, pointYCallback);
	ros::Subscriber pointZ = n.subscribe("pointZ", 100, pointZCallback);
	ros::Subscriber pointA = n.subscribe("pointA", 100, pointACallback);

	ros::Rate r(30);

	visualization_msgs::Marker points;
	points.header.frame_id = "/my_frame";
	points.header.stamp = ros::Time::now();
	points.ns = "points";
	points.action = visualization_msgs::Marker::ADD;
	points.pose.orientation.w = 1.0;

	points.id = 0;

	points.type = visualization_msgs::Marker::POINTS;


	// POINTS markers use x and y scale for width/height respectively
	points.scale.x = 0.2;
	points.scale.y = 0.2;

	// Points are green
	points.color.g = 1.0;
	points.color.a = 1.0;

	//make a thing called p, it's a point holder
	geometry_msgs::Point p;

	while (ros::ok())
	{

		ros::spinOnce();

		p.x = x;
		p.y = y;
		p.z = z;

		points.points.push_back(p);

		marker_pub.publish(points);

		r.sleep();
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
