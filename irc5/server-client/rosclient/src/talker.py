#!/usr/bin/env python
import roslib; roslib.load_manifest('rosclient')
import rospy
from std_msgs.msg import String
def talker():
    pub = rospy.Publisher('server_spammer', String)
    rospy.init_node('talker')
    while not rospy.is_shutdown():
        str = "cmd" + "," + "var1" + "," + "var2"
        rospy.loginfo(str)
        pub.publish(String(str))
        rospy.sleep(1.0)
if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException: pass
