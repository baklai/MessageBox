{ ****************************************************************************** }
{ }
{ Copyright (c) 2010-2015 Barklay Software }
{ }
{ ****************************************************************************** }
unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Winapi.ShellApi, Vcl.Themes, Vcl.Styles, Vcl.SysStyles,
  Vcl.Menus, Vcl.ComCtrls;

type
  TFMain = class(TForm)
    PageControl: TPageControl;
    TabSheetMsgBx: TTabSheet;
    TabSheetMsgCode: TTabSheet;
    SBKod: TSpeedButton;
    SBBox: TSpeedButton;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Error: TRadioButton;
    Warning: TRadioButton;
    Information: TRadioButton;
    Confirmation: TRadioButton;
    Pusto: TRadioButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    LETitle: TLabeledEdit;
    MemoText: TMemo;
    GroupBox3: TGroupBox;
    Ok: TRadioButton;
    OkCancel: TRadioButton;
    AbortRetryIgnore: TRadioButton;
    YesNoCancel: TRadioButton;
    YesNo: TRadioButton;
    RetryCancel: TRadioButton;
    GroupBox4: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox5: TGroupBox;
    LEVar: TLabeledEdit;
    TextCode: TMemo;
    Panel: TPanel;
    btnBack: TSpeedButton;
    btnCopy: TSpeedButton;
    btnSave: TSpeedButton;
    procedure SBBoxClick(Sender: TObject);
    procedure SBKodClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IconClick(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure SelBottomClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

  TitleText, TextText, TextVar: string;
  KeyIcon, KeyBottton, KeySelBottom: integer;

implementation

{$R *.dfm}

procedure TFMain.FormCreate(Sender: TObject);
begin
  PageControl.ActivePage:=TabSheetMsgBx;
  LETitle.Hint := 'Заголовок сообщения';
  MemoText.Hint := 'Текст сообщения';
  LEVar.Hint := '   Если испоьзовать диалог с выбором' + #13 +
    'ответа, то необходимо использовать' + #13 +
    'переменную типа Integer описаную в' + #13 +
    'сакции Var. В этой переменной будет' + #13 +
    'хранится результат ответа на диалог!';
  MemoText.Text := 'Введите текст сообщения...';
  KeyIcon := 0;
  KeyBottton := 0;
  KeySelBottom := 0;
end;

procedure TFMain.IconClick(Sender: TObject);
begin
  KeyIcon := (Sender as TRadioButton).Tag;
end;

procedure TFMain.btnBackClick(Sender: TObject);
begin
  PageControl.ActivePage:=TabSheetMsgBx;
  TextCode.Lines.Clear;
end;

procedure TFMain.ButtonClick(Sender: TObject);
begin
  KeyBottton := (Sender as TRadioButton).Tag;
end;

procedure TFMain.SelBottomClick(Sender: TObject);
begin
  KeySelBottom := (Sender as TRadioButton).Tag;
end;

procedure TFMain.btnCopyClick(Sender: TObject);
begin
  TextCode.SelectAll;
  TextCode.CopyToClipboard;
  TextCode.Lines.Clear;
  TextCode.Alignment:=taCenter;
  TextCode.Lines.Add('');
  TextCode.Lines.Add('');
  TextCode.Lines.Add('Код успешно скопирован в буффер!');
end;

procedure TFMain.btnSaveClick(Sender: TObject);
begin
  TextCode.Lines.SaveToFile('MessageBox.txt');
  TextCode.Lines.Clear;
  TextCode.Alignment:=taCenter;
  TextCode.Lines.Add('');
  TextCode.Lines.Add('');
  TextCode.Lines.Add('Код успешно сохранен в файл "MessageBox.txt"');
end;

procedure TFMain.SBBoxClick(Sender: TObject); // Просмотр сообщения...
begin
  TitleText := '';
  TitleText := LETitle.Text;
  TextText := '';
  TextText := StrPas(MemoText.Lines.GetText);
  MessageBox(Handle, PChar(TextText), PChar(TitleText), KeyIcon + KeyBottton + KeySelBottom);
end;

procedure TFMain.SBKodClick(Sender: TObject); // Просмотр кода сообщения...
var
  i: integer;
  temp: string;
begin
  TextCode.Clear;
  TextCode.Alignment:=taLeftJustify;
  TitleText := '';
  TitleText := LETitle.Text;
  TextText := '';
  TextText := StrPas(MemoText.Lines.GetText);
  TextVar := '';
  TextVar := LEVar.Text;
  temp := '';
  for i := 0 to length('                            ' + TextVar +
    ':=MessageBox(Handle,''') do
    temp := temp + ' ';
  TextCode.Clear;
  TextCode.Lines.Add('var');
  TextCode.Lines.Add('   ' + TextVar + ':word;');
  TextCode.Lines.Add('begin');
  if MemoText.Lines.Count = 1 then
    TextCode.Lines.Add('   ' + TextVar + ':=MessageBox(Handle,' + 'PChar(' +
      '''' + MemoText.Lines[0] + '''' + ')' + ',')
  else
  begin
    TextCode.Lines.Add('   ' + TextVar + ':=MessageBox(Handle,' + 'PChar(' +
      '''' + MemoText.Lines[0] + '''+#13+');
    for i := 1 to MemoText.Lines.Count - 2 do
      if i < MemoText.Lines.Count - 1 then
        TextCode.Lines.Add(temp + '''' + MemoText.Lines[i] + '''+#13+');
    TextCode.Lines.Add(temp + '''' + MemoText.Lines[i] + '''' + '),');
  end;

  TextCode.Lines.Add(temp + 'PChar(' + '''' + TitleText + '''' + ')' + ',' +
    IntToStr(KeyIcon + KeyBottton + KeySelBottom) + ');');
  if RetryCancel.Checked = true then
  begin
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDRETRY then');
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDCANCEL then');
  end;
  if YesNo.Checked = true then
  begin
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDYES then');
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDNO then');
  end;
  if YesNoCancel.Checked = true then
  begin
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDYES then');
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDNO then');
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDCANCEL then');
  end;
  if AbortRetryIgnore.Checked = true then
  begin
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDABORT then');
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDRETRY then');
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDIGNORE then');
  end;
  if OkCancel.Checked = true then
  begin
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDOK then');
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDCANCEL then');
  end;
  if Ok.Checked = true then
  begin
    TextCode.Lines.Add('   ' + 'if ' + TextVar + '=IDOK then');
  end;
  TextCode.Lines.Add('end;');
  PageControl.ActivePage:=TabSheetMsgCode;
end;

end.
