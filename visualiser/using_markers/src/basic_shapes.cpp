#include <ros/ros.h>
#include <visualization_msgs/Marker.h>

#include <cmath>

int main( int argc, char** argv )
{
  ros::init(argc, argv, "points_and_lines");
  ros::NodeHandle n;
  ros::Publisher marker_pub = n.advertise<visualization_msgs::Marker>("visualization_marker", 10);

  ros::Rate r(30);

  uint32_t i = 0;
  float f = 0.0;
  while (ros::ok())
  {

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
    points.color.g = 1.0f;
    points.color.a = 1.0;

    // Create the vertices for the points and lines
  //  for (uint32_t i = 0; i < 1000; ++i)
  //  {
      float y = 5 * sin(f + i / 100.0f * 2 * M_PI);
      float z = 5 * cos(f + i / 100.0f * 2 * M_PI);

      geometry_msgs::Point p;
      p.x = (int32_t)i / 10;
      p.y = y;
      p.z = z;

      points.points.push_back(p);

      if( i == 500){
	i = 0;
}

      // The line list needs two points for each line
      //p.z += 1.0;
      i++;

   // }


    marker_pub.publish(points);

    //r.sleep();

    f += 0.04;
  }
}
