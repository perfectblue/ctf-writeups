SECTIONS {
	. = 0x7fbd8a4;
	. : {
		*(.text.poc_main); /* MAIN GOES FIRST!!! */
		*(*);
	}
}