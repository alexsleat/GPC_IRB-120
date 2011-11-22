MODULE MainModule
	VAR socketdev socket1;
	VAR string received_string;
	PROC main()
		SocketCreate socket1;
		SocketConnect socket1, "192.168.125.2", 1025;
		SocketSend socket1 \Str:="Hello Server";
		SocketReceive socket1 \Str:=received_string;
		SocketClose socket1;
	ENDPROC
ENDMODULE
