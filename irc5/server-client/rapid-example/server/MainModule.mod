MODULE MainModule
	VAR socketdev temp_socket;
	VAR socketdev client_socket;
	VAR string received_string;
	VAR bool keep_listening := TRUE;
	PROC main()
		SocketCreate temp_socket;
		SocketBind temp_socket, "192.168.125.1", 1025;
		SocketListen temp_socket;
		WHILE keep_listening DO
			!Wait for a connection request
			SocketAccept temp_socket, client_socket;

			WHILE keep_listening DO

				!Comm
				SocketReceive client_socket \Str:=received_string;
				TPWrite "Client wrote - " + received_string;
				SocketSend client_socket \Str:="ACK: " + received_string;
				received_string:= "";
			ENDWHILE

		ENDWHILE

		!Shutdown
		SocketReceive client_socket \Str:=received_string;
		TPWrite "Client wrote - " + received_string;
		SocketSend client_socket \Str:="Shutting Down, Goodbye";
		SocketClose client_socket;

		SocketClose temp_socket;
		
	ENDPROC
ENDMODULE
