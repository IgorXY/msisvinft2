unit Unit1;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
   Vcl.ComCtrls;

type
   TForm1 = class(TForm)
      Button1: TButton;
      Memo1: TMemo;
      Button2: TButton;
      OpenDialog1: TOpenDialog;
      Memo2: TMemo;
      Memo3: TMemo;
      Button3: TButton;
      Label1: TLabel;
      Label2: TLabel;
      Label3: TLabel;
      Edit1: TEdit;
      Edit2: TEdit;
      Edit3: TEdit;
      Label4: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      Edit4: TEdit;
      Label7: TLabel;
      Button4: TButton;
      Button5: TButton;
      RadioGroup1: TRadioGroup;
      Button7: TButton;
      SaveDialog1: TSaveDialog;
      Button6: TButton;
      procedure Button1Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
      procedure Button3Click(Sender: TObject);
      procedure Edit1Change(Sender: TObject);
      procedure Edit2Change(Sender: TObject);
      procedure Edit3Change(Sender: TObject);
      procedure Edit4Change(Sender: TObject);
      procedure Button4Click(Sender: TObject);
      procedure Button5Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure RadioGroup1Click(Sender: TObject);
      procedure Button7Click(Sender: TObject);
      procedure Button6Click(Sender: TObject);
   private
      { Private declarations }
   public
      { Public declarations }
   end;

var
   Form1: TForm1;
   s_text: string;
   c_text: string;
   key, k1, k2, k3: string;
   U, s_textb, c_textb, keyb: array of byte;
   S: array [0 .. 255] of byte;
   u_n: integer;
   show_bytes: boolean;

implementation

{$R *.dfm}

function PrintByte(b: byte): string;
var
   S: string;
   i: integer;
   y: word;
begin
   y := 128;
   S := '';
   for i := 1 to 8 do
   begin
      if (b and y = y) then
         S := S + '1'
      else
         S := S + '0';
      y := y div 2;
   end;
   PrintByte := S;
end;

function MakeByte(S: string): byte;
var
   b: byte;
   i: integer;
   y: word;
begin
   y := 128;
   b := 0;
   for i := 1 to 8 do
   begin
      if (S[i] = '1') then
         b := b + y;
      y := y div 2;
   end;
   MakeByte := b;
end;

function S_XOR(ch1, ch2: char): char;
begin
   if ch1 = ch2 then
      S_XOR := '0'
   else
      S_XOR := '1';
end;

function S_MULTIPLEXOR(x1, x2, x3: char): char;
var
   y1, y2: char;
begin
   if (x1 = '1') and (x2 = '1') then
      y1 := '1'
   else
      y1 := '0';
   if (x1 = '0') and (x3 = '1') then
      y2 := '1'
   else
      y2 := '0';
   if (y1 = '1') or (y2 = '1') then
      S_MULTIPLEXOR := '1'
   else
      S_MULTIPLEXOR := '0';
end;

procedure Shift(var S: string);
var
   i: integer;
   ch: char;
begin
   for i := length(S) downto 2 do
      S[i] := S[i - 1];
end;

function LFSR(S: string; n: integer): string;
var
   b: string;
   i, j: integer;
   ch: char;
   for_xor_n, last: integer;
   for_xor: array of integer;
begin
   result := '';
   case (length(S)) of
      23:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 5;
         end;
      24:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 4;
            for_xor[1] := 3;
            for_xor[2] := 1;
         end;
      25:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 3;
         end;
      26:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 8;
            for_xor[1] := 7;
            for_xor[2] := 1;
         end;
      27:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 8;
            for_xor[1] := 7;
            for_xor[2] := 1;
         end;
      28:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 3;
         end;
      29:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 2;
         end;
      30:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 16;
            for_xor[1] := 15;
            for_xor[2] := 1;
         end;
      31:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 3;
         end;
      32:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 28;
            for_xor[1] := 27;
            for_xor[2] := 1;
         end;
      33:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 13;
         end;
      34:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 15;
            for_xor[1] := 14;
            for_xor[2] := 1;
         end;
      35:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 2;
         end;
      36:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 11;
         end;
      37:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 12;
            for_xor[1] := 10;
            for_xor[2] := 2;
         end;
      38:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 6;
            for_xor[1] := 5;
            for_xor[2] := 1;
         end;
      39:
         begin
            for_xor_n := 1;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 4;
         end;
      40:
         begin
            for_xor_n := 3;
            setlength(for_xor, for_xor_n);
            for_xor[0] := 21;
            for_xor[1] := 19;
            for_xor[2] := 2;
         end;
   end;
   last := length(S);
   for i := 1 to n do
   begin
      result := result + S[last];
      for j := 0 to for_xor_n - 1 do
         S[last] := S_XOR(S[last], S[for_xor[j]]);
      ch := S[last];
      Shift(S);
      S[1] := ch;
      // Form1.Memo1.Lines.Add(s[n])  ;
   end;

end;

function Chiper(m_text, key: string): string;
var
   i: integer;
begin
   result := '';
   for i := 1 to length(m_text) do
      result := result + S_XOR(m_text[i], key[i]);
end;

procedure RC4Chiper;
var
   i: integer;
begin
   setlength(c_textb, length(s_textb));
   Form1.Memo3.Text := '';
   for i := 1 to length(s_textb) do
   begin
      c_textb[i - 1] := s_textb[i - 1] xor keyb[i - 1];
      Form1.Memo3.Lines.Add(IntToStr(c_textb[i - 1]));
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   s1, s2, bs: string;
   i: integer;
begin
   s1 := Edit1.Text;
   // delete(s, 23, 2);
   // Memo1.Lines.Add(IntToStr(length(s_text)));
   if (length(s1) > 22) and (length(s1) < 41) then
   begin
      for i := 1 to length(s1) do
         s2 := s2 + s1[length(s1) - i + 1];
      key := LFSR(s2, length(s_text));
      Memo1.Text:=(key);
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   InputFile: file;
   b: byte;
   i, fz: integer;
begin
   if OpenDialog1.Execute then
   begin
      // read bits
      s_text := '';
      Memo2.Text := '';
      i := 0;
      // s := ''
      AssignFile(InputFile, OpenDialog1.FileName);
      reset(InputFile, 1);
      if not eof(InputFile) then
      begin
         fz := filesize(InputFile);
         setlength(s_textb, fz);
         while not eof(InputFile) do
         begin
            blockread(InputFile, b, 1);
            s_text := s_text + PrintByte(b);
            // Memo2.Lines.Add(PrintByte(b));

            s_textb[i] := b;

            if show_bytes then
               Memo2.Lines.Add(IntToStr(s_textb[i]));
            // Form1.Memo1.Lines.Add(IntToStr(b));
            inc(i);
         end;
      end;
      closefile(InputFile);
      if not show_bytes then
         Memo2.Text := s_text;
   end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   if (key <> '') and (s_text <> '') then
      c_text := Chiper(s_text, key);
   Memo3.Text := c_text;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
   s1, s2, s3, s4: string;
   i: integer;
begin
   if length(s_text) > 0 then
   begin
      s1 := Edit1.Text;
      s2 := Edit2.Text;
      s3 := Edit3.Text;
      Memo1.Text := '';
      // delete(s, 23, 2);
      // Memo1.Lines.Add(IntToStr(length(s_text)));
      if (length(s1) > 22) and (length(s2) > 22) and (length(s3) > 22) and
        (length(s1) < 41) and (length(s2) < 41) and (length(s3) < 41) then
      begin
         key := '';
         s4 := '';
         for i := 1 to length(s1) do
            s4 := s4 + s1[length(s1) - i + 1];
         s1 := LFSR(s4, length(s_text));
         Memo1.Lines.Add('LSFR 1:' + #13);
         Memo1.Text := Memo1.Text + s1;
         s4 := '';
         for i := 1 to length(s2) do
            s4 := s4 + s2[length(s2) - i + 1];
         s2 := LFSR(s4, length(s_text));
         Memo1.Lines.Add('LSFR 2:' + #13);
         Memo1.Text := Memo1.Text + s2;
         s4 := '';
         for i := 1 to length(s3) do
            s4 := s4 + s3[length(s3) - i + 1];
         s3 := LFSR(s4, length(s_text));
         Memo1.Lines.Add('LSFR 3:' + #13);
         Memo1.Text := Memo1.Text + s3;
         for i := 1 to length(s_text) do
            key := key + S_MULTIPLEXOR(s1[i], s2[i], s3[i]);
         Memo1.Lines.Add('Key:');
         Memo1.Lines.Add(key);
      end;
   end;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
   str: string;
   i, old_i, x, j, k: integer;
   sw: byte;

begin
   if length(s_text) > 0 then
   begin
      str := Edit4.Text;
      if length(str) > 0 then
      begin
         Memo1.Text := '';
         i := 1;
         u_n := 0;
         while i <= length(str) do
         begin
            while str[i] = ' ' do
               inc(i);
            old_i := i;
            while (i <= length(str)) and (str[i] <> ' ') do
               inc(i);
            if tryStrToInt(copy(str, old_i, i - old_i), x) then
            begin
               if (x < 256) then
               begin
                  u_n := u_n + 1;
                  setlength(U, u_n);
                  U[u_n - 1] := x;
                  Memo1.Lines.Add(IntToStr(U[u_n - 1]));
               end;
            end;
            while (i <= length(str)) and (str[i] = ' ') do
               inc(i);
         end;
         if u_n > 0 then
         begin
            for i := 0 to 255 do
               S[i] := i;
            j := 0;
            for i := 0 to 255 do
            begin
               j := (j + S[i] + U[i mod u_n]) mod 256;
               sw := S[i];
               S[i] := S[j];
               S[j] := sw;
            end;
            i := 0;
            j := 0;
            setlength(keyb, length(s_textb));
            for k := 1 to length(s_textb) do
            begin
               i := (i + 1) mod 256;
               j := (j + S[i]) mod 256;
               sw := S[i];
               S[i] := S[j];
               S[j] := sw;
               keyb[k - 1] := S[(S[i] + S[j]) mod 256];
            end;

            Memo1.Lines.Add('key:');
            for i := 01 to length(keyb) do
               Memo1.Lines.Add(IntToStr(i) + ': ' + IntToStr(keyb[i - 1]));

            RC4Chiper;
         end;

      end;
   end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
   i: integer;
   flag: boolean;
begin
   if Memo2.Text <> '' then
   begin
      flag := false;
      s_text := Memo2.Text;
      while not flag do
      begin
         flag := true;
         for i := 1 to length(s_text) do
            if (s_text[i] <> '0') and (s_text[i] <> '1') then
            begin
               delete(s_text, i, 1);
               flag:=false;
            end;
      end;
      Memo2.Text := s_text;
   end;

end;

procedure TForm1.Button7Click(Sender: TObject);
var
   OutputFile: file;
   b: byte;
   s1: string;
   i: integer;
begin
   if (length(c_text) > 0) or (length(c_textb) > 0) then

      if SaveDialog1.Execute then
      begin
         AssignFile(OutputFile, SaveDialog1.FileName);
         rewrite(OutputFile, 1);
         if not show_bytes then
         begin
            if c_text <> '' then
               for i := 1 to length(c_text) div 8 do
               begin
                  s1 := copy(c_text, (i - 1) * 8 + 1, 8);
                  b := MakeByte(s1);
                  blockwrite(OutputFile, b, 1);
               end;
         end
         else
            if length(c_textb) <> 0 then
               for i := 1 to length(c_textb) do
                  blockwrite(OutputFile, c_textb[i - 1], 1);

         closefile(OutputFile);

      end;

end;

procedure TForm1.Edit1Change(Sender: TObject);
var
   S: string;
   i: integer;
begin
   S := Edit1.Text;
   for i := 1 to length(S) do
      if (S[i] <> '1') and (S[i] <> '0') then
         delete(S, i, 1);
   Edit1.Text := S;
end;

procedure TForm1.Edit2Change(Sender: TObject);
var
   S: string;
   i: integer;
begin
   S := Edit2.Text;
   for i := 1 to length(S) do
      if (S[i] <> '1') and (S[i] <> '0') then
         delete(S, i, 1);
   Edit2.Text := S;
end;

procedure TForm1.Edit3Change(Sender: TObject);
var
   S: string;
   i: integer;
begin
   S := Edit3.Text;
   for i := 1 to length(S) do
      if (S[i] <> '1') and (S[i] <> '0') then
         delete(S, i, 1);
   Edit3.Text := S;
end;

procedure TForm1.Edit4Change(Sender: TObject);
var
   S: string;
   i: integer;
begin
   S := Edit4.Text;
   for i := 1 to length(S) do
      if not(S[i] in ['0' .. '9', ' ']) then
         delete(S, i, 1);
   Edit4.Text := S;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   show_bytes := false;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
   case RadioGroup1.ItemIndex of
      0:
         begin
            show_bytes := false;
            Button1.Visible := true;
            Button3.Visible := true;
            Button4.Visible := false;
            Button5.Visible := false;
            Button6.Visible := true;
            Edit1.Visible := true;
            Edit2.Visible := false;
            Edit3.Visible := false;
            Edit4.Visible := false;
            Label4.Visible := true;
            Label5.Visible := false;
            Label6.Visible := false;
            Label7.Visible := false;
            Label1.Caption:='���� ������:';
            Label2.Caption:='���� �����:';
            Label3.Caption:='���� �����:';
         end;
      1:
         begin
            show_bytes := false;
            Button1.Visible := false;
            Button3.Visible := true;
            Button4.Visible := true;
            Button5.Visible := false;
            Button6.Visible := true;
            Edit1.Visible := true;
            Edit2.Visible := true;
            Edit3.Visible := true;
            Edit4.Visible := false;
            Label5.Visible := true;
            Label6.Visible := true;
            Label7.Visible := false;
            Label1.Caption:='���� ������:';
            Label2.Caption:='���� �����:';
            Label3.Caption:='���� �����:';
         end;
      2:
         begin
            show_bytes := true;
            Button1.Visible := false;
            Button3.Visible := false;
            Button4.Visible := false;
            Button5.Visible := true;
            Button6.Visible := false;
            Edit1.Visible := false;
            Edit2.Visible := false;
            Edit3.Visible := false;
            Edit4.Visible := true;
            Label4.Visible := false;
            Label5.Visible := false;
            Label6.Visible := false;
            Label7.Visible := true;
            Label1.Caption:='����� ������:';
            Label2.Caption:='����� �����:';
            Label3.Caption:='����� �����:';
         end;

   end;
end;

end.
