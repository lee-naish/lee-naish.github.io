/* not needed if #!/bin/sh is put at start of executable shell script
*/
main(){

	execl("/usr/local/lib/prolog/nuprolog/bin.10604/nep",
		"htmlform",
		"-R", "/local/dept/wwwd/cgi-bin/nptest.save",
		"-P", "htmlform", "-a", 0);
}
