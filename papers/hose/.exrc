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
map !b bi<strong>ea</strong>
map !i bi<em>ea</em>
map !e :s/^.*$/&&/i</A>-i<A}>a
ab	htM http://www.cs.mu.OZ.AU/
ab	aH <A HREF=""></A>
ab	veR <PRE>\</PRE>
ab	itE <UL><LI></UL>
ab	enU <OL><LI></OL>
ab	\I <LI> 
ab	dL <DL><DT><DD></DL>
