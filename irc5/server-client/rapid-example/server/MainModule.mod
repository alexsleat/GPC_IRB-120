MODULE MainModule
	VAR socketdev temp_socket;
	VAR socketdev client_socket;
	VAR string received_string;
	VAR string send_string;
	VAR bool keep_listening := TRUE;
	VAR bool main_loop := TRUE;
	VAR bool stest := FALSE;
	
	VAR orient Ori;
	VAR string q1;
	VAR string q2;
	VAR string q3;
	VAR string q4;

	VAR string s_func{8};
	VAR num done_flag;

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
			
			done_flag := parser();
			SocketSend client_socket \Str:=s_func{2};

			!fix this yo.
			IF s_func{1} = "trans"
				
				send_string := trans();
				SocketSend client_socket \Str:= send_string;
				
			IF s_func{1} = "movej"
			
				
				
				SocketSend client_socket \Str:= "movej";
								
			!IF received_string = "orient"
			!	p1 := CRobT(\Tool:=tool0 \WObj:=wobj0 ); !tool0 and WObj should be the current setting, they might not always be these!
			!	Ori:= p1.rot;
			!	q1:= NumToStr(Ori.q1, 4);
			!	q2:= NumToStr(Ori.q2, 4);
			!	q3:= NumToStr(Ori.q3, 4);
			!	q4:= NumToStr(Ori.q4, 4);
			!	SocketSend client_socket \Str:= "orient," + q1 + "," + q2 + "," + q3 + q4 + " " ;

			IF s_func{1} = "closeSocket"
				main_loop := FALSE;
				
				
			!Clear received_string for the next pass.
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
		
			IF temp = "," THEN	
				var_pos := var_pos + 1;			
			ELSE
				s_func{var_pos} := s_func{var_pos} + temp;		!probs not corret synatx
				
			ENDIF
			
			string_pos := string_pos + 1;

		ENDFOR
		
		!RETURN s_func{1};		! Return the split string (as an array)
		RETURN 1;
		
	ENDFUNC
	
	
	FUNC string trans()
	
		VAR robtarget p1;
		VAR pos pp1;
		VAR string x;
		VAR string y;
		VAR string z;
		
		VAR string trans_string;
	
		p1 := CRobT(\Tool:=tool0 \WObj:=wobj0 ); !tool0 and WObj should be the current setting, they might not always be these!
		pp1:= p1.trans; !trans is the translation of the current position
		x:= NumToStr(pp1.x, 4);
		y:= NumToStr(pp1.y, 4);
		z:= NumToStr(pp1.z, 4);
		
		!SocketSend client_socket \Str:= 
		trans_string := "trans," + x + "," + y + "," + z + " " ;
		RETURN trans_string;
		
	ENDFUNC
		
ENDMODULE
