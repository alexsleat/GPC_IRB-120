#include "commands.hpp"

//!  setArmXYZ 
/*!
 *A function call to set and publish the XYZ array of the arm, listened to by rosclient to send the set command to the server.
 * 
 *@param pub a ros::Publisher assosiated with the XYZ array in the main function.
 *@param X a double representing the X position to set the arm to.
 *@param Y a double representing the Y position to set the arm to.
 *@param Z a double representing the Z position to set the arm to.
 *
 *@return int 0 if correct, -1 if failed.
*/
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
//!  setArmROT
/*!
 *A function call to set and publish the rotation array of the arm, listened to by rosclient to send the set command to the server.
 * 
 *@param pub a ros::Publisher assosiated with the rotation array in the main function.
 *@param r1 a double representing the r1 position to set the arm to.
 *@param r2 a double representing the r2 position to set the arm to.
 *@param r3 a double representing the r3 position to set the arm to.
 *@param r4 a double representing the r4 position to set the arm to.
 *@param r5 a double representing the r5 position to set the arm to.
 *@param r6 a double representing the r6 position to set the arm to.
 *@param r7 a double representing the r7 position to set the arm to.
 *@param r8 a double representing the r8 position to set the arm to.
 *@param r9 a double representing the r9 position to set the arm to.
 *@param r10 a double representing the r10 position to set the arm to.
 *@param r11 a double representing the r11 position to set the arm to.
 *@param r12 a double representing the r12 position to set the arm to.
 *@param r13 a double representing the r13 position to set the arm to.
 *@param r14 a double representing the r14 position to set the arm to.
 *
 *@return int 0 if correct, -1 if failed.
*/
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
//!  sendArmMove 
/*!
 *A function call to set the move flag high in order for rosclient to tell the IRC5 to move to the positions set via setArmROT() and setArmXYZ().
 * 
 *@param pub a ros::Publisher assosiated with the MoveFlag in the main function.
 *
 *@return int 0 if correct, -1 if failed.
*/
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
