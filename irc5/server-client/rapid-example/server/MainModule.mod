MODULE MainModule
	VAR socketdev temp_socket;
	VAR socketdev client_socket;
	VAR string received_string;
	VAR string send_string;
	VAR string temp_string;
	VAR bool keep_listening := TRUE;
	VAR bool main_loop := TRUE;
	VAR bool stest := FALSE;
	
	VAR orient Ori;
	VAR string q1;
	VAR string q2;
	VAR string q3;
	VAR string q4;
	
	! Danger ZOne!

	VAR string s_func{8};			! output by parser()
	VAR string subParserArray{8};		! output subParser()
	VAR string robt_parserArr{17};		! output robt_parser()
	
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
			FOR rcv FROM 1 TO 3 DO
				SocketReceive client_socket \Str:=temp_string;
				TPWrite "Client wrote - " + temp_string;
				SocketSend client_socket \Str:="ACK: " + temp_string;
				
				received_string := received_string + temp_string;
				
			ENDFOR
			
			SocketSend client_socket \Str:=received_string;
			
			done_flag := parser();
			SocketSend client_socket \Str:=" ";

			!fix this yo.
			IF s_func{1} = "trans" THEN
				
				send_string := trans();
				SocketSend client_socket \Str:= send_string;
				
			ELSEIF s_func{1} = "MoveJ_fc" THEN
			
				send_string := MoveJ_fc();
				SocketSend client_socket \Str:= send_string;
				
				FOR this FROM 1 TO 17 DO
					SocketSend client_socket \Str:= ValToStr(robt_parserArr{this})  + " ";
				ENDFOR
					
				FOR this FROM 1 TO 4 DO
					SocketSend client_socket \Str:= ValToStr(subParserArray{8})  + " ";
				ENDFOR	
					
				SocketSend client_socket \Str:= "END";

			ELSEIF s_func{1} = "CRobT_fc" THEN
	
				send_string := CRobT_fc();
				SocketSend client_socket \Str:= send_string;

			ELSEIF s_func{1} = "CPos_fc" THEN
	
				send_string := CPos_fc();
				SocketSend client_socket \Str:= send_string;

			ELSEIF s_func{1} = "CJointT_fc" THEN
	
				send_string := CJointT_fc();
				SocketSend client_socket \Str:= send_string;

			ELSEIF s_func{1} = "ReadMotor_fc" THEN
	
				send_string := ReadMotor_fc();
				SocketSend client_socket \Str:= send_string;

			ELSEIF s_func{1} = "closeSocket" THEN
				main_loop := FALSE;
				
			ELSE
				SocketSend client_socket \Str:= "Fail";	
				
			!Clear received_string for the next pass.
			received_string:= "";
			
			ENDIF

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

! **********************************************************************************************************************************
! , parser for commas
!
!	Will usually be for strings which contain a bunch of values seperated by commas
!
	FUNC num subParser(string inString)
	
		!VAR string s_func{8};
		VAR num inString_len;
		
		VAR num var_pos	:= 1;		! Which is the current variable we're using.		
		VAR num string_pos := 1;	! Where in the string of the current var it is
		
		VAR string temp;
		
		!loop string by each char
		inString_len := StrLen(inString);
		
		FOR looper FROM 1 TO inString_len DO			! Loop each character in the string
		
			IF string_pos = inString_len
				string_pos := string_pos - 1;
		
			temp := StrPart(inString, string_pos, 1);		! Set temp to the current posistion in the string
		
			IF temp = "," THEN	
				var_pos := var_pos + 1;			
			ELSE
				subParserArray{var_pos} := subParserArray{var_pos} + temp;		!build up a new array of seperated commands
				
			ENDIF
			
			string_pos := string_pos + 1;

		ENDFOR
		
		!RETURN subParserArray{1};		! Return the split string (as an array)
		RETURN 1;
		
	ENDFUNC	
	
! **********************************************************************************************************************************
! , parser for robtarget
!
!	Will usually be for strings which contain a bunch of values seperated by commas
!
!	will come in "[x,y,z][-,-,-,-][-,-,-,-][-,-,-,-,-,-]"
!	want them seperated
!
	FUNC num robtParser(string inString)
	
		!VAR string s_func{8};
		VAR num inString_len;

		VAR num var_pos	:= 1;		! Which is the current variable we're using.		
		VAR num string_pos := 1;	! Where in the string of the current var it is
		
		VAR string temp;
		
		!loop string by each char
		inString_len := StrLen(inString);
		
		FOR looper FROM 1 TO inString_len DO			! Loop each character in the string
		
			IF string_pos = inString_len
				string_pos := string_pos - 1;
		
			temp := StrPart(inString, string_pos, 1);		! Set temp to the current posistion in the string
		
			IF temp = "," THEN	
				var_pos := var_pos + 1;	
			ELSEIF temp = "[" THEN
				var_pos := var_pos + 1;
			ELSEIF temp = "]" THEN
				var_pos := var_pos + 1;		
			ELSE
				robt_parserArr{var_pos} := robt_parserArr{var_pos} + temp;		!build up a new array of seperated commands
				
			ENDIF
			
			string_pos := string_pos + 1;

		ENDFOR
		
		!RETURN robt_parserArr{1};		! Return the split string (as an array)
		RETURN 1;
		
	ENDFUNC	
	
! **********************************************************************************************************************************
! trans function:
!
!		
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
! **********************************************************************************************************************************
! MoveJ function:
!
!	
	FUNC string MoveJ_fc()
	
		VAR string temp_string;	
		VAR bool done;
		VAR num temp_rob{17};
		VAR robtarget pose;
		VAR speeddata mj_speed;
		VAR num zd_temp;
		VAR zonedata mj_zone;
		VAR num td_temp;
		VAR tooldata mj_tool;
		VAR num rP_flag;
		VAR num temp_speed1;
		VAR num temp_speed2;
		VAR num temp_speed3;
		VAR num temp_speed4;
		
		rP_flag := robtParser(s_func{2});
		
	!
	! Convert string to robtarget, for the position data
	!
		
		
		
		! Convert from string to num.
		FOR this FROM 1 TO 17 DO
		
			done := StrToVal(robt_parserArr{this}, temp_rob{this});
			
			! something failed, should exit with an error.
			IF done = FALSE
				temp_string := "MoveJ_fc failed at itteration : " + ValToStr(this) + " of StrToVal";
				RETURN temp_string;
		ENDFOR
		
		! blast in those lovely new nums in to robtarget ;)
		pose	:= [ 	[temp_rob{1}, temp_rob{2}, temp_rob{3}] ,						
				[temp_rob{4}, temp_rob{5}, temp_rob{6}, temp_rob{7}] ,					
				[temp_rob{8}, temp_rob{9}, temp_rob{10}, temp_rob{11}] 	,				
				[temp_rob{12}, temp_rob{13}, temp_rob{14}, temp_rob{15}, temp_rob{16}, temp_rob{17}] ];	
		
	!
	! Convert string to speeddata, does what it says on the tin.
	!
		
		rP_flag := subParser(s_func{3});
		
		done := StrToVal(subParserArray{1}, temp_speed1);
		done := StrToVal(subParserArray{2}, temp_speed2);
		done := StrToVal(subParserArray{3}, temp_speed3);
		done := StrToVal(subParserArray{4}, temp_speed4);
		
		mj_speed := [temp_speed1, temp_speed2, temp_speed3, temp_speed4];
		
	!
	! Convert string to zonedata, ?
	!
		
		
		!done := StrToVal(s_func{4}, zd_temp);
		!IF done = FALSE
			!temp_string := "MoveJ_fc failed at StrToVal for zonedata";
			!RETURN temp_string;
		 !mj_zone := zd_temp;
		
	!
	! Convert string to tooldata, info about the tool
	!		
		
		
		!done := StrToVal(s_func{4}, td_temp);
		!IF done = FALSE
			!temp_string := "MoveJ_fc failed at StrToVal for tooldata";
			!RETURN temp_string;
		 !mj_tool := td_temp;
		
	!
	! Do the function call with all this lovely new data
	!
		
		!MoveJ(mj_toPoint, mj_speed, mj_zone, mj_tool);
		
		temp_string := "MoveJ func: ";
		
		RETURN temp_string;
		
	ENDFUNC
!
!CRobT Function
!
	FUNC string CRobT_fc()
	
		VAR robtarget p1;
		VAR pos pp1;
		VAR string x;
		VAR string y;
		VAR string z;
		
		VAR string CRobT_string;
	
		p1 := CRobT(\Tool:=tool0 \WObj:=wobj0 ); !tool0 and WObj should be the current setting, they might not always be these!
		pp1:= p1.trans; !trans is the translation of the current position
		x:= NumToStr(pp1.x, 4);
		y:= NumToStr(pp1.y, 4);
		z:= NumToStr(pp1.z, 4);
		
		!SocketSend client_socket \Str:= 
		CRobT_string := "trans," + x + "," + y + "," + z + " " ;
		RETURN CRobT_string;
		
	ENDFUNC
	
!
!CPos Function
!

	FUNC string CPos_fc()
	
		VAR robtarget p1;
		VAR pos pp1;
		VAR string x;
		VAR string y;
		VAR string z;
	
		VAR string CPos_string;
	
		pp1 := CPos(\Tool:=tool0 \WObj:=wobj0 );
		
		x:= NumToStr(pp1.x, 4);
		y:= NumToStr(pp1.y, 4);
		z:= NumToStr(pp1.z, 4);
		
		!SocketSend client_socket \Str:= 
		CPos_string := "Cpos," + x + "," + y + "," + z + " " ;
	
	RETURN CPos_string;
		
	ENDFUNC
	
!
!CJointT function
!

	FUNC string CJointT_fc()
	
		VAR robtarget p1;
		VAR jointtarget joints;
		VAR pos pp1;
		VAR robjoint rjoint;
		VAR extjoint ejoint;
		VAR string t;
		VAR string CPos_string;
	
		joints:= CJointT(\TaskRef:=T_ROB2Id);
		rjoint:= joints.robjoint;
		
		pp1:= p1.trans; !trans is the translation of the current position
		x:= NumToStr(pp1.x, 4);
		y:= NumToStr(pp1.y, 4);
		z:= NumToStr(pp1.z, 4);
		
		!SocketSend client_socket \Str:= 
		CPos_string := "Cpos," + x + "," + y + "," + z + " " ;
	
	RETURN CPos_string;
		
	ENDFUNC
	
	FUNC string ReadMotor_fc()
		
		VAR string motor_angle1;
		VAR string motor_angle2;
		VAR string motor_angle3;
		VAR string motor_angle4;
		VAR string motor_angle5;
		VAR string motor_angle6;
		
		VAR string ReadMotor_string;
		
		motor_angle1 := NumToStr(ReadMotor(1),4);
		motor_angle2 := NumToStr(ReadMotor(2),4);
		motor_angle3 := NumToStr(ReadMotor(3),4);
		motor_angle4 := NumToStr(ReadMotor(4),4);
		motor_angle5 := NumToStr(ReadMotor(5),4);
		motor_angle6 := NumToStr(ReadMotor(6),4);
		
		ReadMotor_string := "ReadMotor, " + motor_angle1 + "," + motor_angle2 + "," + motor_angle3 + "," + motor_angle4 + "," + motor_angle5 + motor_angle6 + " ";
		
	RETURN ReadMotor_string;
	ENDFUNC
ENDMODULE
