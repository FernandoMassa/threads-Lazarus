Program ThreadTest;

uses
 sysutils;

const
  threadcount = 10;
  stringlen = 1000;

var
   finished : longint;

threadvar
   thri : ptrint;

function f(p : pointer) : ptrint;
var
  s : ansistring;
begin
  Writeln('thread ',longint(p),' started');
  thri:=0;
  while (thri<stringlen) do begin
    s:=s+'1'; { create a delay }
    writeln('thread ',longint(p),' thri ',thri,' Len(S)= ',length(s));
	inc(thri);
  end;
  Writeln('thread ',longint(p),' finished');
  InterLockedIncrement(finished);
  f:=0;
end;


var
   i : longint;

Begin
   finished:=0;
   for i:=1 to threadcount do
     BeginThread(@f,pointer(i));
   while finished<threadcount do ;
   Writeln(finished);
End.
