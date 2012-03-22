#include <stdio.h>
#include <stdlib.h>
#include "ros/ros.h"
#include "std_msgs/Int32.h"
#include "commands.hpp"

//Defs
#define 	TIPTHRESH 	100
//Globals
int tipval = 0;
int sendFlag = 1;

//Function Declerations
void tipCallback(const std_msgs::Int32::ConstPtr& tip);
void sendFlagCallback(const std_msgs::Int32::ConstPtr& sendFlagPtr);
//Functions
int main(int argc, char **argv)
{

	ros::init(argc, argv, "arraySubscriber");

	ros::NodeHandle n;	
	//Subscriptions
	ros::Subscriber sub1 = n.subscribe("tactipReading", 100, tipCallback);
	ros::Subscriber sub2 = n.subscribe("sendFlag", 100, sendFlagCallback);
	//Publishing 
	ros::Publisher pubXYZ = n.advertise<std_msgs::Float32MultiArray>("armXYZArr", 100);
	ros::Publisher pubROT = n.advertise<std_msgs::Float32MultiArray>("armRotArr", 100);
	ros::Publisher pubMOV = n.advertise<std_msgs::Int32>("armMoveFlag", 100);
	
	ros::Rate loop_rate(1);

	//Send Start XZY, ROT etc:
	// Home? 377.4536,-1.0300,377.4536
	double X = 377.4536, Y = -1.0300, Z = 377.4536;
	
	setArmXYZ(pubXYZ, 	X, Y, Z);	
	setArmROT(pubROT,	0.55, -0.02, 0.83, -0.02,
				0.0, 0.0, 0.0, 0.0,
				0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	sendArmMove(pubMOV);
	
	while(ros::ok())
	{
		ros::spinOnce();
		loop_rate.sleep();
		//Check that we are able to send data, if we are go ahead, if not loop and check again.
		//if(sendFlag == 1)
		//{
			//Check the tactip reading for a hit, if so stop sending movement commands.
			if(tipval > TIPTHRESH)
			{
				printf("Tactip hit (%d)\n",tipval);
				//sendArmStop();
			}
			//If there is no hit on the tactip, reduce the Z position and move the arm.
			else
			{
				printf("%d\n", tipval);
				
				Z = Z - 1.5;
				
				setArmXYZ(pubXYZ, X, Y, Z);
				setArmROT(pubROT,	0.55, -0.02, 0.83, -0.02,
							0.0, 0.0, 0.0, 0.0,
							0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
				sendArmMove(pubMOV);
			}
		//}
	}
	return 0;
}
//!  tipCallback 
/*!
 *A function callback to get the current reading of the tactip from its published rosmsg.
 * 
 *@param const std_msgs::Int32::ConstPtr& pointer to the tip data.
 *
 *@return void.
*/
void tipCallback(const std_msgs::Int32::ConstPtr& tip)
{
	// print all the remaining numbers

	tipval = tip->data;

	//return i;
	return;
}
//!  sendFlagCallback 
/*!
 *A function callback to get the current sendFlag status.
 *0 = Paused.
 *1 = Running. 
 *@param const std_msgs::Int32::ConstPtr& pointer to the tip data.
 *
 *@return void.
*/
void sendFlagCallback(const std_msgs::Int32::ConstPtr& sendFlagPtr)
{

	sendFlag = sendFlagPtr->data;
	
	return;
}
