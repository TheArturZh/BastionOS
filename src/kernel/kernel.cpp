#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include "vga/vga.h"
#include "vga/terminal.h"
#include "interrupts/idt.h"
#include "interrupts/pic.h"
#include "cpuid/cpuid.h"

extern "C" void kmain(void){
	//another one test
	Terminal test_terminal;

	//Setup IDT
	idt::setup_exceptions();
	idt::load_idt();

	//Disable the PIC
	pic::remap(32,40);
	pic::disable(MASTER_PIC_DATA);
	pic::disable(SLAVE_PIC_DATA);

	//print pepe
	test_terminal.setBackgroundColor(vga::COLOR::BLACK);
	test_terminal.setTextColor(vga::COLOR::GREEN);
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


	test_terminal.setTextColor(vga::COLOR::WHITE);
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

	test_terminal.setTextColor(vga::COLOR::LIGHT_RED);
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
