program MessageBox;

uses
  Forms,
  UMain in 'UMain.pas' {FMain} ,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Windows10');
  Application.Title := 'MessageBox - генератор сообщений';
  Application.CreateForm(TFMain, FMain);
  Application.Run;

end.
