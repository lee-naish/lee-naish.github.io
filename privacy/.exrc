set exrc
set wrapmargin=8
set wrapscan
map !w :set wrapmargin=0 nowrapscan
map q :wq
map N :w:n
map z :w
map !! :w:!echo huh
map %$ :'c,.s/^.*$/<!-- & -->/
map %^ :'c,.s/^<!-- \(.*\) -->$/\1/
map %t :%s/        /	/g
map , Ea,'
map !q Bi"Ea"
map !d :.! date
map !u :.! date -u
map !b bi<strong>ea</strong>
map !i bi<em>ea</em>
map !p Bi<code>Ea</code>
map !c Bi<code>Ea</code>
map !v Bi<pre>Ea</pre>
map !h1 0i<H1>$a</H1>
map !h2 0i<H2>$a</H2>
map !h3 0i<H3>$a</H3>
map !e :s/^.*$/&&/i</A>-i<A>a
map !r :s/^.*$/&&/A</A>-i<A HREF="A">+A
ab	htM http://www.cs.mu.OZ.AU/
ab	aH <A HREF=""></A>
ab	veR <PRE></PRE>
ab	taB <TABLE><tr><th> H</th></tr><tr><td>I</td></tr></TABLE>
ab	itE <UL><LI></UL>
ab	enU <OL><LI></OL>
ab	iT <LI> 
ab	dL <DL><DT><DD></DL>
