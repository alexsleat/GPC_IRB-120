#include <stdio.h>
#include <stdlib.h>

#include "ros/ros.h"

#include "std_msgs/Float32.h"

int main(int argc, char **argv)
{
    
	//init this
	ros::init(argc, argv, "injectPoints");
	
	//Set up node handle
	ros::NodeHandle n;

	//Publish
	ros::Publisher pointXMsg = n.advertise<std_msgs::Float32>("pointX", 100);	//X pose
	ros::Publisher pointYMsg = n.advertise<std_msgs::Float32>("pointY", 100);	//Y pose
	ros::Publisher pointZMsg = n.advertise<std_msgs::Float32>("pointZ", 100);	//Z pose
	ros::Publisher pointAMsg = n.advertise<std_msgs::Float32>("pointA", 100);	//alpha

	//set up variables to be published

	std_msgs::Float32 pointX;
	std_msgs::Float32 pointY;
	std_msgs::Float32 pointZ;
	std_msgs::Float32 pointA;

	//get all cmd line arguments, seems to need to be int can't do float :(
	
	int x, y, z, a;

	//some reason, this seems to need a new nodehandle with the squiggly?
	ros::NodeHandle nh("~");
	nh.getParam("X", x);
	nh.getParam("Y", y);
	nh.getParam("Z", z);
	nh.getParam("A", a);

	//since it's only taking in int, divide by 100, so 100 = 1.0, 10 = 0.1, 1 = 0.01.

	pointX.data = float(x) / 100;
	pointY.data = float(y) / 100;
	pointZ.data = float(z) / 100;
	pointA.data = float(a) / 100;

	//publish all the things!

	pointXMsg.publish(pointX);
	pointYMsg.publish(pointY);
	pointZMsg.publish(pointZ);
	pointAMsg.publish(pointA);

	//Let the world know
	ROS_INFO("X: %f, Y: %f, Z: %f, A: %f", pointX.data, pointY.data, pointZ.data, pointA.data);
	//Do this.
	ros::spinOnce();
	//}

}
