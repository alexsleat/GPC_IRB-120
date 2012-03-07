MODULE MainModule

! *********************************************************
! Global variables:
!	
	
	VAR socketdev temp_socket;
	VAR socketdev client_socket;
	VAR string received_string;
	VAR string send_string;
	VAR string temp_string;
	VAR bool keep_listening := TRUE;
	VAR bool main_loop := TRUE;
	VAR bool stest := FALSE;
	
	! Danger ZOne!

	VAR string s_func{8};			! output by parser()
	VAR string subParserArray{8};		! output subParser()
	VAR string robt_parserArr{17};		! output robt_parser()
	
	VAR num done_flag;

	!joint rotations
	VAR string rj1;
	VAR string rj2;
	VAR string rj3;
	VAR string rj4;
	VAR string rj5;
	VAR string rj6;
	
	!endpont translation
	VAR string tranx;
	VAR string trany;
	VAR string tranz;
	
	!motorangles
	var string motorA1;
	var string motorA2;
	var string motorA3;
	var string motorA4;
	var string motorA5;
	var string motorA6;
	
	!endpoint rotation
	VAR string q1;
	VAR string q2;
	VAR string q3;
	VAR string q4;
	
	VAR num glob_XYZ{3};
	VAR num glob_ROT1{4};
	VAR num glob_ROT2{4};
	VAR num glob_ROT3{6};
	
	!this is used for some return functins (didnt know how to return void)
	VAR num ok := 0;

! *********************************************************
! Main process.	
!
!
	PROC main()
	
		! Create socket for the server:
		SocketCreate temp_socket;
		SocketBind temp_socket, "164.11.73.252", 1025;
		SocketListen temp_socket;

		!Wait for a connection request
		SocketAccept temp_socket, client_socket;

		! main loop, while a client is connected. set main_loop to FALSE to close.
		WHILE main_loop DO

			!Comms
			received_string := "";
			SocketReceive client_socket \Str:=received_string;		! receive a string
			TPWrite "Client wrote - " + received_string;			! write it to the pendent
			SocketSend client_socket \Str:="ACK:#" + received_string;	! return (with "ACK:#" attatched to the start).
			
			done_flag := parser();				! parse the string into an array of strings (global s_func{}) (seperated with '#')
			SocketSend client_socket \Str:=" ";		! send a blank msg.

			TPWrite "Client wrote - " + s_func{1};

! *********************************************************
! Function selection IF ELSEIF mess:
!
! s_func{1} is the first string in the array which should contain the function call name as below, 
!	the remaining array elements contain arguments for each function.
	
	! *********************************************************
	! Trans func
			IF s_func{1} = "trans" THEN
				
				send_string := trans();
				SocketSend client_socket \Str:= send_string;
	! *********************************************************
	! MoveJ func		
			ELSEIF s_func{1} = "MoveJ_fc" THEN
			
				send_string := MoveJ_fc();
				SocketSend client_socket \Str:= send_string;

	! *********************************************************
	! CRobT func
			ELSEIF s_func{1} = "CRobT_fc" THEN
	
				ok := CRobT_fc();
				
				!xyz coordinates
				TPWrite "Coordinates: x = " + tranx + ", y = " + trany + ", z = " + tranz + ". ";
				!Also send it back over the socket
				send_string := "CurrentXYZ#" + tranx + "," + trany + "," + tranx + "#0";
				SocketSend client_socket \Str:= send_string;
				!qunationlkasfja;lskdghslfjhs
				TPWrite "q1 = : " + q1 + ", " + "q2 = : " + q2 + ", " + "q3 = : " + q3 + ", " + "q4 = : " + q4;

	! *********************************************************
	! CJointT func
			ELSEIF s_func{1} = "CJointT_fc" THEN
					
				!new method
				ok := CJointT_fc();
				!print to the pendant
				TPWrite "Axis vals: " + rj1 + " " + rj2 + " " + rj3 + " " + rj4 + " " + rj5 + " " + rj6;
				!Send back over the socket:
				send_string := "CurrentJoints#" + rj1 + "," + rj2 + "," + rj3 + "," + rj4 + "," + rj5 + "," + rj6;
				SocketSend client_socket \Str:= send_string;
				
	! *********************************************************
	! ReadMotor func
			ELSEIF s_func{1} = "ReadMotor_fc" THEN
	
				ok := ReadMotor_fc();
				TPWrite "Motor Angles 1-6: " + motorA1 + " " + motorA2 + " " + motorA3 + " " + motorA4 + " " + motorA5 + " " + motorA6;
				send_string := "CurrentJoints#" + motorA1 + "," + motorA2 + "," + motorA3 + "," + motorA4 + "," + motorA5 + "," + motorA6;
				SocketSend client_socket \Str:= send_string;
	! *********************************************************
	! VelSet func				
			ELSEIF s_func{1} = "VelSet_fc" THEN
	
				send_string := VelSet_fc();
				SocketSend client_socket \Str:= send_string;
				TPWrite "Max. TCP speed in mm/s for the robot is: "\Num:=MaxRobSpeed();
	! *********************************************************
	! AccSet func				
			ELSEIF s_func{1} = "AccSet_fc" THEN
	
				send_string := AccSet_fc();
				SocketSend client_socket \Str:= send_string;
	! *********************************************************
	! GripLoad func	
				
			ELSEIF s_func{1} = "GripLoad_fc" THEN
	
				send_string := GripLoad_fc();
				SocketSend client_socket \Str:= send_string;	
				
	! *********************************************************
	! Function calls for setting XYZ and Rotation matrix:
	!
			ELSEIF s_func{1} = "setXYZ" THEN
				done_flag := subParser(s_func{2}, "XYZ");

				TPWrite "Client wrote - " + NumToStr(glob_XYZ{1}, 4) + " " + NumToStr(glob_XYZ{2}, 4) + " " + NumToStr(glob_XYZ{3}, 4);
				
			ELSEIF s_func{1} = "setROT1" THEN
				done_flag := subParser(s_func{2}, "ROT1");
				
				TPWrite "Client wrote - " + NumToStr(glob_ROT1{1}, 4) + " " + NumToStr(glob_ROT1{2}, 4) + " " + NumToStr(glob_ROT1{3}, 4) + " " + NumToStr(glob_ROT1{4}, 4);
				
			ELSEIF s_func{1} = "setROT2" THEN
				done_flag := subParser(s_func{2}, "ROT2");
				
				TPWrite "Client wrote - " + NumToStr(glob_ROT2{1}, 4) + " " + NumToStr(glob_ROT2{2}, 4) + " " + NumToStr(glob_ROT2{3}, 4) + " " + NumToStr(glob_ROT2{4}, 4);
				
			ELSEIF s_func{1} = "setROT3" THEN
				done_flag := subParser(s_func{2}, "ROT3");
				
				!TPWrite "Client wrote - " + NumToStr(glob_ROT3{1}, 4) + " " + NumToStr(glob_ROT3{2}, 4) + " " + NumToStr(glob_ROT3{3}, 4) + " " + NumToStr(glob_ROT3{4}, 4) + " " + NumToStr(glob_ROT3{5}, 4) + " " + NumToStr(glob_ROT3{6}, 4);
						
	! *********************************************************
	! close down the server when closeSocket is received.
	!
			ELSEIF s_func{1} = "closeSocket" THEN
				main_loop := FALSE;
		! Else Error.			
			ELSE
				SocketSend client_socket \Str:= "Failed, function " + s_func{1} + " not declared.";	
				
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
! # parser for dolla signs
!
!	We use # to seperate command lists in the TCP/IP string sent from the client, this splits them up.
!	
	FUNC num parser()
	
		!VAR string s_func{8};
		VAR num received_string_len;

		VAR num var_pos	:= 1;		! Which is the current variable we're using.		
		VAR num string_pos := 1;	! Where in the string of the current var it is
		
		VAR string temp;
		
		!loop string by each char
		received_string_len := StrLen(received_string);
		
		s_func{1} := "";
		s_func{2} := "";
		s_func{3} := "";
		s_func{4} := "";
		s_func{5} := "";
		s_func{6} := "";
		s_func{7} := "";
		s_func{8} := "";
		
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
	FUNC num subParser(string inString, string type)
	
		!VAR string s_func{8};
		VAR num inString_len;
		
		VAR num var_pos	:= 1;		! Which is the current variable we're using.		
		VAR num string_pos := 1;	! Where in the string of the current var it is
		
		VAR string temp;
		
		VAR string temp_XYZ{3};
		VAR string temp_ROT1{4};
		VAR string temp_ROT2{4};
		VAR string temp_ROT3{6};
		VAR bool goodstuff;
		
		!loop string by each char
		inString_len := StrLen(inString);
		
		FOR looper FROM 1 TO inString_len DO			! Loop each character in the string
		
			IF string_pos = inString_len
				string_pos := string_pos - 1;
		
			temp := StrPart(inString, string_pos, 1);		! Set temp to the current posistion in the string
		
			IF temp = "," THEN	
				var_pos := var_pos + 1;			
			ELSE
			
				IF type = "XYZ" THEN
					temp_XYZ{var_pos} := temp_XYZ{var_pos} + temp;	!build up a new array
				ELSEIF type = "ROT1" THEN
					temp_ROT1{var_pos} := temp_ROT1{var_pos} + temp;	!build up a new array
				ELSEIF type = "ROT2" THEN
					temp_ROT2{var_pos} := temp_ROT2{var_pos} + temp;	!build up a new array
				ELSEIF type = "ROT3" THEN
					temp_ROT3{var_pos} := temp_ROT3{var_pos} + temp;	!build up a new array
				ELSE
					TPWrite "subParser failed at ";
					
				ENDIF
			ENDIF
			
			string_pos := string_pos + 1;

		ENDFOR
		
		! Pass temps to globals
		
		IF type = "XYZ" THEN
			goodstuff := StrToVal(temp_XYZ{1}, glob_XYZ{1});
			goodstuff := StrToVal(temp_XYZ{2}, glob_XYZ{2});
			goodstuff := StrToVal(temp_XYZ{3}, glob_XYZ{3});
		ELSEIF type = "ROT1" THEN
			goodstuff := StrToVal(temp_ROT1{1}, glob_ROT1{1});
			goodstuff := StrToVal(temp_ROT1{2}, glob_ROT1{2});
			goodstuff := StrToVal(temp_ROT1{3}, glob_ROT1{3});
			goodstuff := StrToVal(temp_ROT1{4}, glob_ROT1{4});
		ELSEIF type = "ROT2" THEN
			goodstuff := StrToVal(temp_ROT2{1}, glob_ROT2{1});
			goodstuff := StrToVal(temp_ROT2{2}, glob_ROT2{2});
			goodstuff := StrToVal(temp_ROT2{3}, glob_ROT2{3});
			goodstuff := StrToVal(temp_ROT2{4}, glob_ROT2{4});
		ELSEIF type = "ROT3" THEN
			goodstuff := StrToVal(temp_ROT3{1}, glob_ROT3{1});
			goodstuff := StrToVal(temp_ROT3{2}, glob_ROT3{2});
			goodstuff := StrToVal(temp_ROT3{3}, glob_ROT3{3});
			goodstuff := StrToVal(temp_ROT3{4}, glob_ROT3{4});
			goodstuff := StrToVal(temp_ROT3{5}, glob_ROT3{5});
			goodstuff := StrToVal(temp_ROT3{6}, glob_ROT3{6});
		ELSE
			TPWrite "subParser Failed at passing temp to globals.";
			
		ENDIF
							
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
!Moves the robot by joint movement
!want it to take in x,y,z

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
		
		!rP_flag := robtParser(s_func{2});
		
	!
	! Convert string to robtarget, for the position data
	!
		
		
		
		! Convert from string to num.
		!FOR this FROM 1 TO 17 DO
		
			!done := StrToVal(robt_parserArr{this}, temp_rob{this});
			
			! something failed, should exit with an error.
			!IF done = FALSE
				!temp_string := "MoveJ_fc failed at itteration : " + ValToStr(this) + " of StrToVal";
				!RETURN temp_string;
		!ENDFOR

		! blast in those lovely new nums in to robtarget ;)
		pose	:= [ 	[glob_XYZ{1}, glob_XYZ{2}, glob_XYZ{3}] ,						
				[glob_ROT1{1}, glob_ROT1{2}, glob_ROT1{3}, glob_ROT1{4}] ,					
				[glob_ROT2{1}, glob_ROT2{2}, glob_ROT2{3}, glob_ROT2{4}] ,				
				[glob_ROT3{1}, glob_ROT3{2}, glob_ROT3{3}, glob_ROT3{4}, glob_ROT3{5}, glob_ROT3{6}] ];	
		
	
	!
	! Convert string to zonedata, ?
	!
		
		
		!done := StrToVal(s_func{4}, zd_temp);
		!IF done = FALSE
			!temp_string := "MoveJ_fc failed at StrToVal for zonedata";
			!RETURN temp_string;
		 !mj_zone := zd_temp;
			
	!
	! Do the function call with all this lovely new data
	!
		
		MoveJ ToPoint:=pose, Speed:=v500, Zone:=z50, Tool:=tool0;
		
		temp_string := "MoveJ-ing";
		
		RETURN temp_string;
		
	ENDFUNC

! **********************************************************************************************************************************
! CRobT Function
!

	FUNC num CRobT_fc()
	
		VAR robtarget p1;
		p1 := CRobT();
		
		tranx := NumToStr(p1.trans.x,4);
		trany := NumToStr(p1.trans.y,4);
		tranz := NumToStr(p1.trans.z,4);
		
		q1 := NumToStr(p1.rot.q1,4);
		q2 := NumToStr(p1.rot.q2,4);
		q3 := NumToStr(p1.rot.q3,4);
		q4 := NumToStr(p1.rot.q4,4);
		
		RETURN 1;
		
		
		
	ENDFUNC
	
! **********************************************************************************************************************************
! CJointT function:
! read the current angles of the robot axes and external axes. 
!
	FUNC num CJointT_fc()
	
		VAR robtarget p1;
		VAR jointtarget joints;
		VAR robjoint rjoint;
		VAR string Cpos_string;
		
		joints := CJointT();
		rjoint := joints.robax;
		
		rj1 := NumToStr(rjoint.rax_1,4);
		rj2 := NumToStr(rjoint.rax_2,4);
		rj3 := NumToStr(rjoint.rax_3,4);
		rj4 := NumToStr(rjoint.rax_4,4);
		rj5 := NumToStr(rjoint.rax_5,4);
		rj6 := NumToStr(rjoint.rax_6,4);

	
	!	joints:= CJointT(\TaskRef:=T_ROB1Id);
	!	rjoint:= joints.robjoint;
		
	!	pp1:= p1.trans; !trans is the translation of the current position
	!	x:= NumToStr(pp1.x, 4);
	!	y:= NumToStr(pp1.y, 4);
	!	z:= NumToStr(pp1.z, 4);
		
		!SocketSend client_socket \Str:= 
	!	CPos_string := "CJointT," + x + "," + y + "," + z + " " ;
		RETURN 1;
		
	ENDFUNC
! **********************************************************************************************************************************
! ReadMotor function:
!	
	FUNC num ReadMotor_fc()

		
		motorA1 := NumToStr(ReadMotor(1),4);
		motorA2 := NumToStr(ReadMotor(2),4);
		motorA3 := NumToStr(ReadMotor(3),4);
		motorA4 := NumToStr(ReadMotor(4),4);
		motorA5 := NumToStr(ReadMotor(5),4);
		motorA6 := NumToStr(ReadMotor(6),4);
		
		RETURN 1;
	ENDFUNC
! **********************************************************************************************************************************
! VelSet function:	
!
! Changes programmed velocity
! Arg: VelSet Override(num) Max(num)
! eg. VelSet 50, 800;

	FUNC string VelSet_fc() 
	
		VAR string override;
		VAR string max;
		VAR bool done;
		
		VAR num overrideN;
		VAR num maxN;
		
		VAR string final_string;
		
		override := s_func{2};
		max := s_func{3};
		
		done:=StrToVal(override, overrideN);
		done:=StrToVal(max, maxN);
		
		!does the sting need ; at the end?
		final_string := "VelSet " + override + "," + max + ";";
		
		VelSet Override:=overrideN, Max:=maxN;
		
		RETURN final_string;
		
	ENDFUNC
! **********************************************************************************************************************************
! AccSet function:	
!
!Reduces the acceleration
!Arg: AccSet Acc(num) Ramp(num)
!eg. AccSet 50, 100;

	FUNC string AccSet_fc() 
	
		VAR string acc;
		VAR string ramp;
		VAR string final_string;
		VAR bool done;
		
		VAR num accN;
		VAR num rampN;
		
		acc := s_func{2};
		ramp := s_func{3};
		
		done:=StrToVal(acc, accN);
		done:=StrToVal(ramp, rampN);
		
		!does the sting need ; at the end?
		final_string := "AccSet " + acc + "," + ramp + ";";
		
		AccSet Acc:=accN, Ramp:=rampN;
		
		RETURN final_string;
		
	ENDFUNC
! **********************************************************************************************************************************
! GripLoad function:
!	
!Defines the payload for the robot
!Arg: GripLoad Load(loaddata)
!eg. GripLoad peice1;

	FUNC string GripLoad_fc() 
	
		!VAR loaddata load;
		
		!mass, cog, aom, toolload, payload, inertia x, inertia y, inertia z; 
		VAR string mass;
		
		VAR pos cog;
		VAR string cogx;
		VAR string cogy;
		VAR string cogz;
		VAR string cog_string;
		
		VAR orient aom;
		VAR string aomq1;
		VAR string aomq2;
		VAR string aomq3;
		VAR string aomq4;
		VAR string aom_string;
		
		VAR string ix;
		VAR string iy;
		VAR string iz;
		VAR string inertia_string;
		
		VAR string final_string;
		
		!5kg
		mass := NumToStr(5,4);
		
		!cog (x 50, y 0, z 50)
		cog.x := 50;
		cog.y := 0;
		cog.z := 50;
		
		cogx := NumToStr(cog.x,4);
		cogy := NumToStr(cog.y,4);
		cogz := NumToStr(cog.z,4);
		cog_string := "[" + cogx + ", " + cogy + ", " + cogz + "], ";
		
		aom.q1 := 1;
		aom.q2 := 0;
		aom.q3 := 0;
		aom.q4 := 0;
		
		aomq1 := NumToStr(aom.q1,4);
		aomq2 := NumToStr(aom.q2,4);
		aomq3 := NumToStr(aom.q3,4);
		aomq4 := NumToStr(aom.q4,4);
		aom_string := "[" + aomq1 + ", " + aomq2 + ", " + aomq3 + ", " + aomq4 + "], ";
		
		ix := "0";
		iy := "0";
		iz := "0";
		inertia_string := ix + ", " + iy + ", " + iz;
		
		!does the sting need ; at the end?
		final_string := "GripLoad [" + mass + "," + cog_string + aom_string + inertia_String + ";";
		
		RETURN final_string;
	ENDFUNC
	
ENDMODULE
