#define MyAppName "SIMR Admin"
#define MyAppVersion "1.5"
#define MyAppPublisher "SIMR"
#define MyAppURL "https://www.management-restaurant.eu"
#define MyAppExeName "SIMRAdmin.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".myp"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt
#define WelcomeImage "D:\Scoala\24-25\Info\CEX GL\Robotica\simr_admin\restaurant\welcome_image.bmp"
[Setup]
AppId={{9B14AB14-EF1E-4749-A77E-F92E7BA037F1}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion} Setup Wizard
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
ChangesAssociations=yes
LicenseFile=D:\Scoala\24-25\Info\CEX GL\Robotica\README.md
OutputDir=D:\Scoala\24-25\Info\CEX GL\Robotica\installers
OutputBaseFilename=SIMR Admin
SetupIconFile=D:\Scoala\24-25\Info\CEX GL\Robotica\simr_admin\restaurant\bin\Release\net9.0-windows10.0.19041.0\win10-x64\appicon.ico
SolidCompression=yes
WizardStyle=modern
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
[CustomMessages]
english.WelcomeLabel1=Welcome to the SIMR Admin Setup Wizard
english.WelcomeLabel2=This wizard will guide you through the installation of SIMR Admin%n%nversion {#MyAppVersion}. It is recommended that you close all other applications%n%nbefore starting Setup. Click Next to continue.
english.LoadingComponents=Loading components...
[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
[Files]
Source: "D:\Scoala\24-25\Info\CEX GL\Robotica\simr_admin\restaurant\bin\Release\net9.0-windows10.0.19041.0\win10-x64\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Scoala\24-25\Info\CEX GL\Robotica\simr_admin\restaurant\bin\Release\net9.0-windows10.0.19041.0\win10-x64\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#WelcomeImage}"; DestDir: "{tmp}"; Flags: dontcopy
[Registry]
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
[Code]
var
  WelcomePage: TWizardPage;
  WelcomeImage: TBitmapImage;
  SplashPage: TForm;
  SplashLabel: TLabel;
  SplashProgress: TNewProgressBar;
procedure ShowSplashScreen;
begin
  SplashPage := TForm.Create(nil);
  SplashPage.BorderStyle := bsNone;
  SplashPage.Position := poScreenCenter;
  SplashPage.Width := 575;
  SplashPage.Height := 300; 
  SplashPage.Color := clWhite;
  SplashPage.Caption := '';
  with TLabel.Create(SplashPage) do
  begin
    Parent := SplashPage;
    Caption := '{#MyAppName} {#MyAppVersion}';
    Left := 20;
    Top := 20;
    Width := 560;
    Height := 30;
    Font.Size := 16;
    Font.Style := [fsBold];
    Font.Color := clNavy;
  end;
  SplashLabel := TLabel.Create(SplashPage);
  SplashLabel.Parent := SplashPage;
  SplashLabel.Caption := CustomMessage('LoadingComponents');
  SplashLabel.Left := 20;
  SplashLabel.Top := 80;
  SplashLabel.Width := 570;
  SplashLabel.Height := 50;
  SplashLabel.Font.Size := 8;
  SplashLabel.Font.Style := [fsBold];
  SplashLabel.WordWrap := True;
  SplashProgress := TNewProgressBar.Create(SplashPage);
  SplashProgress.Parent := SplashPage;
  SplashProgress.Left := 20;
  SplashProgress.Top := 175;
  SplashProgress.Width := 500;
  SplashProgress.Height := 30;
  SplashProgress.Min := 0;
  SplashProgress.Max := 100;
  SplashProgress.Position := 0;
  SplashPage.Show;
  SplashPage.Update;
end;
procedure UpdateSplashProgress(Progress: Integer; StatusText: String);
begin
  SplashProgress.Position := Progress;
  SplashLabel.Caption := StatusText + '(' + IntToStr(Progress) + '%)';
  SplashPage.Update;
end;
procedure HideSplashScreen;
begin
  SplashPage.Close;
  SplashPage.Free;
end;
procedure InitializeWizard;
var
  I: Integer;
begin
  ShowSplashScreen;
  try
    UpdateSplashProgress(10, CustomMessage('LoadingComponents'));
    ExtractTemporaryFile(ExtractFileName(ExpandConstant('{#WelcomeImage}')));
    for I := 20 to 100 do
    begin
      UpdateSplashProgress(I, CustomMessage('LoadingComponents'));
      Sleep(30);
    end;
    WelcomePage := CreateCustomPage(wpWelcome, CustomMessage('WelcomeLabel1'), '');
    WelcomeImage := TBitmapImage.Create(WelcomePage);
    WelcomeImage.Bitmap.LoadFromFile(ExpandConstant('{tmp}\') + ExtractFileName(ExpandConstant('{#WelcomeImage}')));
    WelcomeImage.Parent := WelcomePage.Surface;
    WelcomeImage.Left := 0;
    WelcomeImage.Top := 0;
    WelcomeImage.Width := WizardForm.ClientWidth div 2 - 200;
    WelcomeImage.Height := WizardForm.ClientHeight - 175;
    WelcomeImage.Stretch := False;
    with TLabel.Create(WelcomePage) do
    begin
      Parent := WelcomePage.Surface;
      Left := WelcomeImage.Width + 20;
      Top := 0;
      Width := WizardForm.ClientWidth - WelcomeImage.Width - 40;
      Height := 300;
      Caption := CustomMessage('WelcomeLabel2');
      WordWrap := True;
      AutoSize := False;
      Font.Size := 8;
    end;
    WizardForm.WelcomeLabel1.Visible := False;
    WizardForm.WelcomeLabel2.Visible := False;
    WelcomePage.Surface.Height := 600;
    WelcomePage.Surface.Width := WizardForm.ClientWidth;
  finally
    HideSplashScreen;
  end;
end;