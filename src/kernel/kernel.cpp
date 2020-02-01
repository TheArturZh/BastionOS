#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "vga/vga.h"
#include "vga/terminal.h"
#include "interrupts/idt.h"

extern "C" void kmain(void){
	//another one test
	Terminal test_terminal;

	idt::setup_exceptions();
	idt::load_idt();

	//print pepe
	test_terminal.setBackgroundColor((unsigned char) vga::COLOR::BLACK);
	test_terminal.setTextColor((unsigned char) vga::COLOR::GREEN);
	test_terminal.write("                          .(((//////////(((      ((((/////////.                 ");
	test_terminal.write("                         ((////////////////(,   (///////////////                ");
	test_terminal.write("                      (///////////////////////**/***************//              ");
	test_terminal.write("                    ((///////////*************//*///////////////**/             ");
	test_terminal.write("                  ((////////////////////******///**///////***********///        ");
	test_terminal.write("                 .((////////////////****//////*****//***/////////////***//      ");
	test_terminal.write("             .(((//////////////////*************///**//////***************/,    ");
	test_terminal.write("            (//////////////////****@@@@@@@@@@@@@***********@@@@@@@@@@@@@@@*.    ");
	test_terminal.write("          ((///////////////******@@@@@     @/ @@@@@**///**@@@@@@     @@ @@@%*   ");
	test_terminal.write("         .((///////////////////****&&&  &     &&&**///////*&&&&&  &     &&,.    ");
	test_terminal.write("         (//////////////////////////////////////////////////////////////        ");
	test_terminal.write("       ((//////////////////////////***********////////////********///           ");
	test_terminal.write("     ((////////////////////////////////////////////////////////////             ");
	test_terminal.write("     ((////////////////////////////////////////////////////////////////         ");
	test_terminal.write("     ((////////////////////////////////////////////////////////////////         ");
	test_terminal.write("     ((//////////////////**/////////////////////////////////////////////        ");
	test_terminal.write("     ((////////////////**/////.............////////////////////////////.        ");
	test_terminal.write("       /////////////////////..***........*******..................********      ");
	test_terminal.write("       /////////////////////..***********.....*********************.....        ");
	test_terminal.write("          /////////////////////////........****************************         ");
	test_terminal.write("             ,/////////////////////////////.......................              ");
	test_terminal.write("                  /////////////////////////////////*******///                   ");
	test_terminal.write("                         /////////////////////////////****                      ");


	test_terminal.setTextColor((unsigned char) vga::COLOR::WHITE);
	test_terminal.write("                                                            Feels bad, man.\n");

	test_terminal.setCursorPos(35,7);
	test_terminal.write("@@@@@@@@@@@@@");
	test_terminal.setCursorPos(59,7);
	test_terminal.write("@@@@@@@@@@@@@@@");

	test_terminal.setCursorPos(33,8);
	test_terminal.write("@@@@@     @/ @@@@@");
	test_terminal.setCursorPos(58,8);
	test_terminal.write("@@@@@@     @@ @@@");

	test_terminal.setCursorPos(35,9);
	test_terminal.write("&&&  &     &&&");
	test_terminal.setCursorPos(59,9);
	test_terminal.write("&&&&&  &     &&");

	test_terminal.setTextColor((unsigned char) vga::COLOR::LIGHT_RED);
	test_terminal.setCursorPos(30,16);
	test_terminal.write(".............");
	test_terminal.setCursorPos(28,17);
	test_terminal.write("..***........*******..................********      ");
	test_terminal.setCursorPos(28,18);
	test_terminal.write("..***********.....*********************.....        ");
	test_terminal.setCursorPos(35,19);
	test_terminal.write("........****************************         ");
	test_terminal.setCursorPos(43,20);
	test_terminal.write(".......................");
	test_terminal.setCursorPos(0,24);
}
