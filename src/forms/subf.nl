% Interface to ICLP'97 submission HTML form for NU-Prolog

	% top level
main(_) :-
	html_form_interface.

	% Outputs the required "Content-type:" line + blank line,
	% checks that the apropriate environment variables are set
	% correctly, reads chars from standard input, forms list of
	% name-value pairs, fixes escape sequences etc and passes list
	% to html_form/1, which is expected to write a HTML page to stdout.
	%
	% The argument to html_form/1 is a list of Name-Value pairs.
	% The Names are atoms which have *not* had escape sequences
	% processed.  They are the names of the form fields, so you
	% had better not use any funny characters in the names!  The
	% Values are strings which have had escape sequences processed.
	% I have no idea how non-ascii characters entered into a form
	% turn out.
html_form_interface :-
	putl("Content-type: text/html\n\n"),
	(getenv('REQUEST_METHOD', "POST") ->
		true
	;
		putl("This script should be referenced with a METHOD of POST.\n"),
		putl("If you don't understand this, read "),
		putl("<A HREF=\"http://www.ncsa.uiuc.edu/SDG/Software/Mosaic/Docs/fill-out-forms/overview.html\">forms overview</A>.\n"),
		exit(1)
	),
	(getenv('CONTENT_TYPE', "application/x-www-form-urlencoded") ->
		true
	;
		putl("This script can only be used to decode form results.\n"),
		exit(1)
	),
	getenv('CONTENT_LENGTH', CLS),
	intToString(CL, CLS),
	read_all(CL, Input),		% read whole input
	getsubnum(Input, Num),		% generate unique? number
	inp_to_nvs(Input, NEVs),	% convert to name-escaped_value pairs
	expand_esc_plus_nv(NEVs, NVs),
	html_form(NVs, Num).

	% Given list of Name-Value pairs from form,
	% output new HTML page
html_form(NVs, Num) :-
	putl("<html>\n"),
	(	member(title-Title, NVs), Title ~= "",
		member(authors-Auth, NVs), Auth ~= "",
		member(address-Addr, NVs), Addr ~= "",
		member(subtype-Type, NVs), Type ~= "" % should be ok
	->
		putl("<head>\n"),
		putl("<title>ICLP'97 submission letter</title>\n"),
		putl("</head>\n"),
		putl("<body>\n"),
		putl("Please enclose this letter with your hardcopy submission.<br>\n<hr>"),
		putl("<PRE>\n"),
		(	lines(Addr, AddrLs),
			member(L, AddrLs),
			tab(45),
			putl(L),
			nl,
			fail
		;
			putl("</PRE>\n")
		),
		putl("</justify>\n"),
		putl("ICLP'97 submissions<br>\n"),
		putl("Department of Computer Science<br>\n"),
		putl("University of Melbourne<br>\n"),
		putl("Parkville 3052<br>\n"),
		putl("Australia<br><br><br>\n"),
		putl("Dear Lee,<br>\n"),
		putl("Please find enclosed a submission for ICLP'97 entitled<br><br><strong>\n"),
		write(Title),
		putl("</strong><br><br>\nwritten by "),
		putl(Auth),
		putl(".\n"),
		( Type = "Hardcopy" ->
			putl("There are five copies, as requested.<P>\n")
		; Type = "Postscript" ->
			putl("There is one copy, as requested.\n"),
			putl("The Postscript will be e-mailed to iclp97ps@cs.mu.oz.au.\n<P>")
		; Type = "DVI" ->
			putl("There is one copy, as requested.\n"),
			putl("A uuencoded DVI file will be e-mailed to iclp97dvi@cs.mu.oz.au.\n<P>")
		;
			putl("<br>ERROR: Submission type not Hardcopy, Postscript or DVI!<P>\n")
		),
		putl("The above paper is not being\n"),
		putl("submitted for publication elsewhere concurrently.<br>\n"),
		putl("<br>Signed<br><br><br><br><br>\n"),
		putl("<hr>P.S. Your submission registration script output the following:<br>\n"),
		putl("<PRE>\n"),
		print_to_file(NVs, Num),
		putl("</PRE><hr><P>\n"),
		putl("</body>\n"),
		putl("</html>\n")
	;
		putl("<head>\n"),
		putl("<title>Error</title>\n"),
		putl("</head>\n"),
		putl("<body>\n"),
		putl("<H1>Error: incomplete information</H1>\n"),
		putl("You must fill in the title, authors and address fields.\n"),
		putl("Please return to the previous page and resubmit.<P>\n"),
		putl("E-mail iclp97@cs.mu.oz.au if there are more problems.<P>\n"),
		putl("</body>\n"),
		putl("</html>\n")
	).

% otherjunk(NVs, Num) :-
% 	getpid(I),
% 	write(pid(I)),
% 	write('<br>'),
% 	getenv(A, B),
% 	write(A),
% 	write('<br>'),
% 	write(B),
% 	write('<br>'),
% 	fail.
print_to_file(NVs, Num) :-
	getpid(I),
	intToString(I, Is),
	append("/local/dept/wwwd/cgi-bin/iclp97/sub", Is, Fs),
	atomToString(F, Fs),
	open(F, append, SF),
	currentOutput(SC),
	setOutput(SF),
	html_form_body(NVs, Num),
	close(SF),
	setOutput(SC),
        append("cd /local/dept/wwwd/cgi-bin/iclp97 ; ls -l *", Is, Cs),
	atomToString(C, Cs),
	system(C),
	!.
print_to_file(NVs, Num) :-
	writeln('Error: writing to file failed').

%otherjunk(NVs, Num) :-
%	system('/home/staff/lee/www_public/.iclpmail lee@unimelb.edu.au', E),
%	(E = 0 ->
%		writeln('E-mail sent ok')
%	;
%		writeln('E-mail send failed!')
%	).

	% generate (hopefully) unique number from input string and time
getsubnum(Cs, Num) :-
	time(T),
	member(second=S, T),
	hash(S.Cs, 0, Num).

hash([], H, H).
hash(C.Cs, H0, H) :-
	H1 is ((H0 /\ 8'17700000000) >> 24) ^ ((H0 /\ 8'77777777) << 7) ^ C,
	hash(Cs, H1, H).

	% prints details in NUOO-Prolog format
html_form_body(NVs, Num) :-
	putl("def_object p"),
	writev([base=32], Num),
	putl(" isa submission.\n"),
	getpid(I),
	write(subfilenum(I)),
	putl(".\n"),
	time_date_field,
	field(title, title, NVs),
	field(authors, authors, NVs),
	field(subtype, subtype, NVs),
	opt_field(abstract, abstract, NVs),
	yesno_field(pcmember, pcmember, NVs),
	opt_field(email, email, NVs),
	field(address, address, NVs),
	opt_field(fax, fax, NVs),
	opt_field(url, url, NVs),
	field(contact, contact, NVs),
	yesno_field(correction, correction, NVs),
	print_field,
	ack_field,
	putl("end_def p"),
	writev([base=32], Num),
	putl(".\n").

	% Get compulsary field and print fact with value as arg.
	% If a field has multiple values, multiple facts are printed.
	% (not used here)
	% Prints error if no (non-null) value of field exists.
field(FName, PName, NVs) :-
	(	(if some [Val] (member(FName - Val, NVs), Val ~= "") then
			format("~w(~w).\n", [PName, Val]),
			fail
		else
			error("missing field: ~w\n", [FName])
		),
		fail
	;
		true
	).

	% Get optional field and print fact with value as arg.
	% If a field has multiple values, multiple facts are printed.
opt_field(FName, PName, NVs) :-
	(	(if some [Val] (member(FName - Val, NVs), Val ~= "") then
			format("~w(~w).\n", [PName, Val]),
			fail
		else
			fail
		),
		fail
	;
		true
	).

	% Get yes/no field and print fact if it exists
yesno_field(FName, PName, NVs) :-
	((member(FName - Val, NVs), Val ~= "") ->
		format("~w.\n", [PName])
	;
		true
	).

	%prints the time and date that applicant registered
time_date_field:- time(Time), date(Time).

date(Ns):- (member(hour = Hour, Ns),
            member(minute = Minute, Ns),
            member(date = Date, Ns),
            member(month = Month, Ns)
        ->
            format("date(~w, ~w, ~w, ~w).\n", [Month, Date, Hour, Minute])
        ;
            fail).
							
										
print_field:- putl("%printed. \n").

ack_field:- format("%ack(~w).\n", ["ok"]). 

	% stub
error(A, B) :-
	format(A, B).

	% read N chars from input
	% (reading until EOF seems to just hang)
	% returns list of N+1 chars, including terminating "&"
read_all(N, Cs) :-
	(N == 0 ->
		Cs = "&"
	;
		get0(C),
		Cs = C.Cs1,
		N1 is N - 1,
		read_all(N1, Cs1)
	).

	% Converts string "name1=val1&name2=val2&" into
	% list of pairs [name1-"val1", name2="val2"] etc
	% Funny chars, eg = and & never occur in vals (they
	% appear as escape sequences)
inp_to_nvs(Cs, NVs) :-
	inp_to_nvs1(NVs, Cs, []).

	% as above using DCG
inp_to_nvs1([]) --> "".
inp_to_nvs1(N-V.NVs) -->
	non_eq(NS),
	{atomToString(N, NS)},
	[0'=],
	non_amp(V),
	[0'&],
	inp_to_nvs1(NVs).

	% massages string a bit - removes leading and trailing
	% whitespace, replaces funny newline sequences by single newline
	% etc
fix_string(Cs0, Cs) :-
	dropws(Cs0, Cs1),
	reverse(Cs1, Cs2),
	dropws(Cs2, Cs3),
	reverse(Cs3, Cs4),
	fixnl(Cs4, Cs).

	% drop leading white space
dropws([], []).
dropws(C.Cs0, Cs) :-
	(whitespace(C) ->
		dropws(Cs0, Cs)
	;
		Cs = C.Cs0
	).

whitespace(0' ).
whitespace(0'\t).
whitespace(0'\n).
whitespace(0'\r).
whitespace(0'\f).

fixnl([], []).
fixnl(C.Cs0, Cs) :-
	fixnl1(Cs0, C, Cs).

fixnl1([], C, [C]).
fixnl1(C.Cs0, C0, Cs) :-
	(newline(C), newline(C0) ->
		fixnl1(Cs0, 0'\n, Cs)
	;
		Cs = C0.Cs1,
		fixnl1(Cs0, C, Cs1)
	).

newline(0'\r).
newline(0'\n).
newline(0'\f).

        % convert string with newlines into list of lines
        % (each without newlines).  Tries to be portable!
lines([], []).
lines(C.Cs, L.Ls) :-
        line1(C.Cs, Cs1, L),
        lines(Cs1, Ls).

        % returns first line + rest of string
        % Looks for \n or \r\n or \r as line terminators
        % - possibly should look for other sequences?
        % (only used with \n here - conversion done earlier)
line1([], [], []).
line1(C.Cs0, Cs, LCs) :-
        (C == 0'\n ->
                LCs = [],
                Cs = Cs0
        ; C == 0'\r ->
                LCs = [],
                (Cs0 = 0'\n.Cs1 ->
                        Cs = Cs1
                ;
                        Cs = Cs0
                )
        ;
                LCs = C.LCs1,
                line1(Cs0, Cs, LCs1)
        ).

	% reads string not containing "="
non_eq([]) --> "".
non_eq(C.Cs) -->
	[C],
	{C ~= 0'=},
	non_eq(Cs).

	% reads string not containing "&"
non_amp([]) --> "".
non_amp(C.Cs) -->
	[C],
	{C ~= 0'&},
	non_amp(Cs).

	% expands escape sequences and converts "+" back into " "
	% in value strings of name-value pairs
	% Also removes leading and trailing whitespace + compresses
	% sequences of newline chars (could do this better)
	% (NOTE its assumed that names don't have any funny chars!)
expand_esc_plus_nv([], []).
expand_esc_plus_nv(N-EV.NEVs, N-V.NVs) :-
	expand_esc_plus(EV, V1),
	fix_string(V1, V),
	expand_esc_plus_nv(NEVs, NVs).

	% expand escape sequences and converts "+" back into " "
	% in a string
expand_esc_plus([], []).
expand_esc_plus(C0.Cs0, C.Cs) :-
	(C0 == 0'+ ->
		C = 0' ,
		expand_esc_plus(Cs0, Cs)
	; C0 == 0'% ->
		Cs0 = C1.C2.Cs1,
		expand_esc(C1, C2, C),
		expand_esc_plus(Cs1, Cs)
	;
		C = C0,
		expand_esc_plus(Cs0, Cs)
	).

	% expand escape sequence
	% translated from C code with no comments...
	% seems to work
expand_esc(C1, C2, C) :-
	(C1 >= 0'A ->
		Digit1 is ((C1 /\ 16'df) - 0'A) + 10
	;
		Digit1 is C1 - 0'0
	),
	(C2 >= 0'A ->
		Digit2 is ((C2 /\ 16'df) - 0'A) + 10
	;
		Digit2 is C2 - 0'0
	),
	C is Digit1 * 16 + Digit2.
