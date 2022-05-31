
/* Echo name=value substrings posted from Form */
/* HTML utilities written by Rob McCool */


#include <stdio.h>
#include <stdlib.h>

#define LF 10
#define CR 13

#define MAX_ENTRIES 5       /* number of input fields */

typedef struct {
    char *name;
    char *val;
} entry;

char *makeword(char *line, char stop);
char *fmakeword(FILE *f, char stop, int *len);
void unescape_url(char *url);
char x2c(char *what);
void plustospace(char *str);


main() {
  entry entries[MAX_ENTRIES];          /* HTML name-val pairs */
  int x, cl, etnum;

  printf("Content-type: text/html%c%c",LF,LF);

  if(strcmp(getenv("REQUEST_METHOD"),"POST")) {
    printf("This script should be referenced with a METHOD of POST.\n");
    printf("If you don't understand this, read ");
    printf("<A HREF=\"http://www.ncsa.uiuc.edu/SDG/Software/Mosaic/Docs/fill-out-forms/overview.html\">forms overview</A>.%c",LF);
    exit(1);
  }
  if(strcmp(getenv("CONTENT_TYPE"),"application/x-www-form-urlencoded")) {
    printf("This script can only be used to decode form results. \n");
    exit(1);
  }
  cl = atoi(getenv("CONTENT_LENGTH"));

  printf("<H1>Query Results</H1>");
  printf("Stdin was<br>\n<pre>");
  etnum = 0;
  for(x=0;cl && (!feof(stdin));x++) {
    entries[x].val = fmakeword(stdin,'&',&cl);
    plustospace(entries[x].val);
    unescape_url(entries[x].val);
    entries[x].name = makeword(entries[x].val,'=');
    etnum++;
  }
  printf("\n</pre>\n");

  printf("You submitted the following name/value pairs:<p>%c",LF);
  printf("<ul>%c",LF);

  for(x=0; x < etnum; x++)
    printf("<li> <code>%s = %s</code>%c",entries[x].name,
               entries[x].val,LF);
  printf("</ul>%c",LF);
}



/* HTML utilities */

char *makeword(char *line, char stop) {
  int x = 0,y;
  char *word = (char *) malloc(sizeof(char) * (strlen(line) + 1));

  for(x=0;((line[x]) && (line[x] != stop));x++)
     word[x] = line[x];

  word[x] = '\0';
  if(line[x]) ++x;
  y=0;

  while(line[y++] = line[x++]);
  return word;
}

char *fmakeword(FILE *f, char stop, int *cl) {
  int wsize;
  char *word;
  int ll;

  wsize = 102400;
  ll=0;
  word = (char *) malloc(sizeof(char) * (wsize + 1));

  while(1) {
    word[ll] = (char)fgetc(f);
	/* */putchar(word[ll]);
    if(ll==wsize) {
       word[ll+1] = '\0';
       wsize+=102400;
       word = (char *)realloc(word,sizeof(char)*(wsize+1));
    }
    --(*cl);
    if((word[ll] == stop) || (feof(f)) || (!(*cl))) {
       if(word[ll] != stop) ll++;
       word[ll] = '\0';
       return word;
    }
    ++ll;
  }
}

void unescape_url(char *url) {
  register int x,y;

  for(x=0,y=0;url[y];++x,++y) {
    if((url[x] = url[y]) == '%') {
        url[x] = x2c(&url[y+1]);
        y+=2;
    }
  }
  url[x] = '\0';
}

char x2c(char *what) {
  register char digit;

  digit = (what[0] >= 'A' ? ((what[0] & 0xdf) - 'A')+10 : (what[0] - '0'));
  digit *= 16;
  digit += (what[1] >= 'A' ? ((what[1] & 0xdf) - 'A')+10 : (what[1] - '0'));
  return(digit);
}

void plustospace(char *str) {
  register int x;

  for(x=0;str[x];x++) 
    if(str[x] == '+') str[x] = ' ';
}

