MODULE MainModule
	VAR socketdev temp_socket;
	VAR socketdev client_socket;
	VAR string received_string;
	VAR string send_string;
	VAR string temp_string;
	VAR bool keep_listening := TRUE;
	VAR bool main_loop := TRUE;
	VAR bool stest := FALSE;
	
	VAR num done_flag;
	
	
	! Danger ZOne!

	VAR string s_func{8};			! output by parser()

	
	!this is used for some return functins (didnt know how to return void)
	VAR num ok := 0;
	VAR num length;

	PROC main()
	
		! Create socket for the server:
		SocketCreate temp_socket;
		SocketBind temp_socket, "192.168.125.1", 1025;
		SocketListen temp_socket;

		!Wait for a connection request
		SocketAccept temp_socket, client_socket;

		WHILE main_loop DO

			SocketReceive client_socket \Str:=temp_string;
			received_string := temp_string;
			done_flag := parser();
			
			TPWrite "Client wrote - " + s_func{1};
			TPWrite "Client wrote - " + s_func{2};
			
			stest := StrToVal(s_func{2}, length);
		
			!Comm
			FOR rcv FROM 1 TO length DO
				SocketReceive client_socket \Str:=temp_string;
				TPWrite "Client wrote - " + temp_string;
				SocketSend client_socket \Str:="ACK: " + temp_string;
				
				!s_func{rcv+2} = temp_string;
				
				!received_string := received_string + temp_string;
				
			ENDFOR
			
			SocketSend client_socket \Str:=received_string;
			
			done_flag := parser();
			SocketSend client_socket \Str:=" ";


		ENDWHILE

		TPWrite "Shutting down client socket";
		!Shutdown
			!SocketReceive client_socket \Str:=received_string;
			!TPWrite "Client wrote - " + received_string;
		SocketSend client_socket \Str:="Shutting Down, Goodbye";
		SocketClose client_socket;
		SocketClose temp_socket;
		
	ENDPROC
! **********************************************************************************************************************************
! $ parser for dolla signs
!
!	We use $ to seperate command lists in the TCP/IP string sent from the client, this splits them up.
!	
	FUNC num parser()
	
		!VAR string s_func{8};
		VAR num received_string_len;

		VAR num var_pos	:= 1;		! Which is the current variable we're using.		
		VAR num string_pos := 1;	! Where in the string of the current var it is
		
		VAR string temp;
		
		!loop string by each char
		received_string_len := StrLen(received_string);
		
		FOR looper FROM 1 TO received_string_len DO			! Loop each character in the string
		
			IF string_pos = received_string_len
				string_pos := string_pos - 1;
		
			temp := StrPart(received_string, string_pos, 1);		! Set temp to the current posistion in the string
		
			IF temp = "#" THEN	
				var_pos := var_pos + 1;			
			ELSE
				s_func{var_pos} := s_func{var_pos} + temp;		!probs not corret synatx
				
			ENDIF
			
			string_pos := string_pos + 1;

		ENDFOR
		
		!RETURN s_func{1};		! Return the split string (as an array)
		RETURN 1;
		
	ENDFUNC
	
ENDMODULE
