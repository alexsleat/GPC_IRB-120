MODULE MainModule
	VAR socketdev temp_socket;
	VAR socketdev client_socket;
	VAR string received_string;
	VAR string send_string;
	VAR bool keep_listening := TRUE;
	VAR bool main_loop := TRUE;

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
			!IF received_string = "sysInfo"
			!	send_string := IsSysId();
			!	SocketSend client_socket \Str:= send_string;	
	

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
