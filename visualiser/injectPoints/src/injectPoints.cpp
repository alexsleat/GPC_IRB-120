#include <stdio.h>
#include <stdlib.h>

#include "ros/ros.h"

#include "std_msgs/MultiArrayLayout.h"
#include "std_msgs/MultiArrayDimension.h"

#include "std_msgs/Float32MultiArray.h"

float genRandFloat( float a, float b );

int main(int argc, char **argv)
{
    
	//init this
	ros::init(argc, argv, "injectPoints");

	//Set up node handle
	ros::NodeHandle n;

	//Publish
	ros::Publisher pub = n.advertise<std_msgs::Float32MultiArray>("array", 100);

	//set up variables to be published
	std_msgs::Float32MultiArray array;

	ros::Rate r(30);

	while (ros::ok())
	{

		//Clear array
		array.data.clear();

		array.data.push_back(genRandFloat(0.0, 3.0));	//x
		array.data.push_back(genRandFloat(0.0, 3.0));	//y
		array.data.push_back(genRandFloat(0.0, 3.0));	//z

		array.data.push_back(genRandFloat(0.0, 225.0));	//r
		array.data.push_back(genRandFloat(0.0, 255.0));	//g
		array.data.push_back(genRandFloat(0.0, 255.0));	//b
	
		//Publish array
		pub.publish(array);
		//Let the world know
		ROS_INFO("I published something!");
		//Do this.
		ros::spinOnce();
		//Added a delay so not to spam
		r.sleep();

	}

	sleep(1);	

}

float genRandFloat( float a, float b )
{
    return ( (b-a)*( (float)rand() / RAND_MAX ) )+a;
}

