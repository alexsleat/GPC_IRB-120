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

	std_msgs::Float32 pointX;
	std_msgs::Float32 pointY;
	std_msgs::Float32 pointZ;
	std_msgs::Float32 pointA;

	//ros::Rate loop_rate(1); //how many times a second ros should loop

	//while (ros::ok())
	//{

		ROS_INFO("Enter X: ");
		scanf("%f", &pointX.data);
		ROS_INFO("Enter Y: ");
		scanf("%f", &pointY.data);
		ROS_INFO("Enter Z: ");
		scanf("%f", &pointZ.data);
		ROS_INFO("Enter A: ");
		scanf("%f", &pointA.data);

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
