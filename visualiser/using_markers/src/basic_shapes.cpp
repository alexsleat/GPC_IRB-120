#include <ros/ros.h>
#include <visualization_msgs/Marker.h>

#include <cmath>

int main( int argc, char** argv )
{
  ros::init(argc, argv, "points_and_lines");
  ros::NodeHandle n;
  ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 10);

  ros::Rate r(30);
	

  float x = 0.1, y = 0.1, z = 0.1;

  float f = 0.0;

 


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

   geometry_msgs::Point p;
  while (ros::ok())
  {
    p.x = x;
    p.y = y;
    p.z = z;

	x = x + 0.01;
	y = y + 0.01;
	z = z + 0.01;

    points.points.push_back(p);


    marker_pub.publish(points);

    r.sleep();

    f += 0.04;
  }
}
