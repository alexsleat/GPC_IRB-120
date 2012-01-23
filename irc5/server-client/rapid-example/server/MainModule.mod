MODULE MainModule
	VAR socketdev temp_socket;
	VAR socketdev client_socket;
	VAR string received_string;
	VAR string send_string;
	VAR bool keep_listening := TRUE;
	VAR bool main_loop := TRUE;
	VAR bool stest := FALSE;
	
	VAR robtarget p1;
	VAR pos pp1;
	VAR string x;
	VAR string y;
	VAR string z;
	
	VAR orient Ori;
	VAR string q1;
	VAR string q2;
	VAR string q3;
	VAR string q4;

	PROC main()
	
		! Create socket for the server:
		SocketCreate temp_socket;
		SocketBind temp_socket, "192.168.125.1", 1025;
		SocketListen temp_socket;

		!Wait for a connection request
		SocketAccept temp_socket, client_socket;

		WHILE main_loop DO

			!Comm
			SocketReceive client_socket \Str:=received_string;
			TPWrite "Client wrote - " + received_string;
			SocketSend client_socket \Str:="ACK: " + received_string;

			!fix this yo.
			IF received_string = "trans"
				
				
				p1 := CRobT(\Tool:=tool0 \WObj:=wobj0 ); !tool0 and WObj should be the current setting, they might not always be these!
				pp1:= p1.trans; !trans is the translation of the current position
				x:= NumToStr(pp1.x, 4);
				y:= NumToStr(pp1.y, 4);
				z:= NumToStr(pp1.z, 4);
				SocketSend client_socket \Str:= "trans," + x + "," + y + "," + z + " " ;
				
			IF received_string = "orient"
				p1 := CRobT(\Tool:=tool0 \WObj:=wobj0 ); !tool0 and WObj should be the current setting, they might not always be these!
				Ori:= p1.rot;
				q1:= NumToStr(Ori.q1, 4);
				q2:= NumToStr(Ori.q2, 4);
				q3:= NumToStr(Ori.q3, 4);
				q4:= NumToStr(Ori.q4, 4);
				SocketSend client_socket \Str:= "orient," + q1 + "," + q2 + "," + q3 + q4 + " " ;

			IF received_string = "closeSocket"
				main_loop := FALSE;

			received_string:= "";

		ENDWHILE

		TPWrite "Shutting down client socket";
		!Shutdown
			!SocketReceive client_socket \Str:=received_string;
			!TPWrite "Client wrote - " + received_string;
		SocketSend client_socket \Str:="Shutting Down, Goodbye";
		SocketClose client_socket;
		SocketClose temp_socket;
		
	ENDPROC
ENDMODULE
