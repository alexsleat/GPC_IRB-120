#include "commands.hpp"


int setArmXYZ(ros::Publisher pub, double X, double Y, double Z)
{

	//Set up array
	std_msgs::Float32MultiArray armXYZArr;
	//Clear array
	armXYZArr.data.clear();
	//Put functions args into temp array
	double temp_armXYZArr[3] = {X, Y, Z};
	
	for (int i = 0; i < 3; i++)
	{
		//put temp array in to rosmsg array
		armXYZArr.data.push_back(temp_armXYZArr[i]);
	}	
		
	//Publish array
	pub.publish(armXYZArr);
	//Let the world know
	ROS_INFO("Arm XYZ Position Updated.");

	return 0;

}

int setArmROT(ros::Publisher pub, double r1, double r2, double r3, double r4, 
		double r5, double r6, double r7, double r8, 
		double r9, double r10, double r11, double r12, double r13, double r14)
{

	

	//Set up array
	std_msgs::Float32MultiArray armRotArr;
	//Clear array
	armRotArr.data.clear();
	//Put functions args into temp array
	double temp_armRotArr[14] = {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r4};
	
	for (int i = 0; i < 14; i++)
	{
		//put temp array in to rosmsg array
		armRotArr.data.push_back(temp_armRotArr[i]);
	}	
		
	//Publish array
	pub.publish(armRotArr);
	//Let the world know
	ROS_INFO("Arm Rotation Matrix Updated.");

	return 0;
}

int sendArmMove(ros::Publisher pub)
{

	//Set up array
	std_msgs::Int32 armMoveFlag;
	
	armMoveFlag.data = 1;
		
	//Publish array
	pub.publish(armMoveFlag);
	//Let the world know
	ROS_INFO("Arm Move Command Sent.");

	return 0;
}
