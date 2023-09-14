unit thrd01;

{$mode objfpc}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
   Spin, Buttons, JvMovableBevel, Interfaces;

type

   { TMinhaThread }
   TMinhaThread = class(TThread)
   private
      FProgBar: TProgressBar;
      i, FMax, FStep, FSleep: integer;
   protected
      procedure Execute; override;
      procedure AtualizaCaptForm;
   public
      constructor Create(CreateSuspended: boolean; aStep, aSleep, aMax: integer;
         aProgBar: TProgressBar);
   end;

   { TForm1 }
   TForm1 = class(TForm)
			btnNorm: TBitBtn;
      Button1: TButton;
      Button2: TButton;
      Button3: TButton;
		JvMovablePanel1: TJvMovablePanel;
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      ProgressBar1: TProgressBar;
      ProgressBar2: TProgressBar;
      rbtTh01: TRadioButton;
      rbtTh02: TRadioButton;
      edtTempo: TSpinEdit;
      edtInc: TSpinEdit;
      edtMax: TSpinEdit;

		procedure btnNormClick(Sender: TObject);
      procedure btnThdSinc(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);

   private
      thr1, thr2: TMinhaThread;
      procedure ThreadFinalizada(Sender: TObject);
   public

   end;

var
   Form1: TForm1;


implementation

{$R *.lfm}

{ TMinhaThread }

procedure TMinhaThread.AtualizaCaptForm;
begin
   FProgBar.Position := i;
   Application.ProcessMessages;
end;

procedure TMinhaThread.Execute;
begin
   i := 0;
   FProgBar.Max := FMax;

   while not Terminated do
   begin
      Inc(i, FStep);
      //Synchronize(@AtualizaCaptForm);   Para threads sincronizadas (como diz o nome)
      Queue(@AtualizaCaptForm);
      sleep(FSleep);
      if i >= FMax then Terminate;
   end;

end;

constructor TMinhaThread.Create(CreateSuspended: boolean;
   aStep, aSleep, aMax: integer; aProgBar: TProgressBar);
begin
   inherited Create(CreateSuspended);
   FStep := aStep;
   FSleep := aSleep;
   FProgBar := aProgBar;
   FMax := aMax;
end;

{ TForm1 }

procedure TForm1.btnThdSinc(Sender: TObject);
begin
   if rbtTh01.Checked then
   begin
      thr1 := TMinhaThread.Create(True, edtInc.Value, edtTempo.Value,
         edtMax.Value, ProgressBar1);
      thr1.FreeOnTerminate := True;
      thr1.OnTerminate := @ThreadFinalizada;
      thr1.Start;
      rbtTh02.Checked := True;
      rbtTh01.Enabled := False;
   end
   else
   begin
      thr2 := TMinhaThread.Create(True, edtInc.Value, edtTempo.Value,
         edtMax.Value, ProgressBar2);
      thr2.FreeOnTerminate := True;
      thr2.OnTerminate := @ThreadFinalizada;
      thr2.Start;
   end;

end;

procedure TForm1.btnNormClick(Sender: TObject);
var
   x : integer;
begin
   {if rbtTh01.Checked then
      ProgressBar1.Max:=edtMax.Value
   else
      ProgressBar2.Max:=edtMax.Value;

   for x := 0 to edtMax.Value do
   begin

   end;  }
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   thr1.Terminate;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   thr2.Terminate;
end;

procedure TForm1.ThreadFinalizada(Sender: TObject);
begin
   Sender := nil;
end;

end.
