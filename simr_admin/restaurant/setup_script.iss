#define MyAppName "SIMR Admin"
#define MyAppVersion "2.0"
#define MyAppPublisher "SIMR"
#define MyAppURL "https://www.management-restaurant.eu"
#define MyAppExeName "SIMRAdmin.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".myp"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

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
OutputDir=D:\Scoala\24-25\Info\CEX GL\Robotica\installers
OutputBaseFilename=SIMR Admin
SetupIconFile=D:\Scoala\24-25\Info\CEX GL\Robotica\simr_admin\restaurant\bin\Release\net9.0-windows10.0.19041.0\win10-x64\appicon.ico
SolidCompression=yes
WizardStyle=modern
DisableWelcomePage=no
DisableDirPage=no
DisableProgramGroupPage=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
english.WelcomeLabel1=SIMR Admin Installation
english.WelcomeLabel2=The complete solution for efficient restaurant management
english.WelcomeLabel3=Thank you for choosing SIMR Admin – your all-in-one restaurant management solution. This application is designed to help you efficiently handle staff coordination, ingredient and menu control, table tracking, and order management, all from one centralized platform.%n%nThis wizard will guide you through the installation process on your Windows device. In just a few steps, you'll be ready to streamline your daily operations and gain full control over your restaurant.%n%nClick Next to begin the installation.
english.LoadingComponents=Loading components...

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\Scoala\24-25\Info\CEX GL\Robotica\simr_admin\restaurant\bin\Release\net9.0-windows10.0.19041.0\win10-x64\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Scoala\24-25\Info\CEX GL\Robotica\simr_admin\restaurant\bin\Release\net9.0-windows10.0.19041.0\win10-x64\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

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
  SplashPage: TForm;
  SplashLabel: TLabel;
  SplashProgress: TNewProgressBar;

procedure ShowSplashScreen;
begin
  SplashPage := TForm.Create(nil);
  SplashPage.BorderStyle := bsNone;
  SplashPage.Position := poScreenCenter;
  SplashPage.ClientWidth := 500;
  SplashPage.ClientHeight := 250;
  SplashPage.Color := clWhite;
  SplashPage.Caption := '';
  
  with TLabel.Create(SplashPage) do
  begin
    Parent := SplashPage;
    Caption := '{#MyAppName}';
    Left := 0;
    Top := 40;
    Width := 500;
    Height := 30;
    Alignment := taCenter;
    Font.Size := 18;
    Font.Style := [fsBold];
    Font.Color := clNavy;
    Transparent := True;
  end;
  
  SplashProgress := TNewProgressBar.Create(SplashPage);
  SplashProgress.Parent := SplashPage;
  SplashProgress.Left := 50;
  SplashProgress.Top := 130;
  SplashProgress.Width := 400;
  SplashProgress.Height := 25;
  SplashProgress.Min := 0;
  SplashProgress.Max := 100;
  SplashProgress.Position := 0;
  
  SplashLabel := TLabel.Create(SplashPage);
  SplashLabel.Parent := SplashPage;
  SplashLabel.Caption := 'Initializing installation...';
  SplashLabel.Left := 0;
  SplashLabel.Top := 170;
  SplashLabel.Width := 500;
  SplashLabel.Height := 20;
  SplashLabel.Alignment := taCenter;
  SplashLabel.Font.Size := 9;
  SplashLabel.Font.Color := clGray;
  SplashLabel.Transparent := True;
  
  SplashPage.Show;
  SplashPage.Update;
end;

procedure UpdateSplashProgress(Progress: Integer; StatusText: String);
begin
  SplashProgress.Position := Progress;
  SplashLabel.Caption := StatusText + ' (' + IntToStr(Progress) + '%)';
  SplashPage.Update;
end;

procedure HideSplashScreen;
begin
  SplashPage.Close;
  SplashPage.Free;
end;

procedure InitializeWizard;
var
  WelcomeText: TNewStaticText;
  TextHeight: Integer;
  I: Integer;
begin
  ShowSplashScreen;
  try
    UpdateSplashProgress(10, CustomMessage('LoadingComponents'));
    for I := 20 to 100 do
    begin
      UpdateSplashProgress(I, CustomMessage('LoadingComponents'));
      Sleep(30);
    end;
    WizardForm.WelcomeLabel1.Caption := CustomMessage('WelcomeLabel1');
    WizardForm.WelcomeLabel1.Font.Style := [fsBold];
    WizardForm.WelcomeLabel1.Font.Size := 12;
    WizardForm.WelcomeLabel1.Top := ScaleY(30);
    WizardForm.WelcomeLabel1.Left := ScaleX(20);
    WizardForm.WelcomeLabel1.Width := WizardForm.ClientWidth - ScaleX(40);
    WizardForm.WelcomeLabel1.Height := ScaleY(24);
    WizardForm.WelcomeLabel1.AutoSize := True;
    WizardForm.WelcomeLabel2.Caption := CustomMessage('WelcomeLabel2');
    WizardForm.WelcomeLabel2.Font.Style := [fsBold];
    WizardForm.WelcomeLabel2.Font.Size := 9;
    WizardForm.WelcomeLabel2.Top := WizardForm.WelcomeLabel1.Top + WizardForm.WelcomeLabel1.Height + ScaleY(8);
    WizardForm.WelcomeLabel2.Left := ScaleX(20);
    WizardForm.WelcomeLabel2.Width := WizardForm.ClientWidth - ScaleX(40);
    WizardForm.WelcomeLabel2.Height := ScaleY(18);
    WizardForm.WelcomeLabel2.AutoSize := True;
    WelcomeText := TNewStaticText.Create(WizardForm);
    try
      WelcomeText.Parent := WizardForm;
      WelcomeText.Left := ScaleX(20);
      WelcomeText.Width := WizardForm.ClientWidth - ScaleX(40);
      WelcomeText.WordWrap := True;
      WelcomeText.Caption := CustomMessage('WelcomeLabel3');
      WelcomeText.Font.Size := 8;
      TextHeight := WelcomeText.Height;
    finally
      WelcomeText.Free;
    end;
    WelcomeText := TNewStaticText.Create(WizardForm);
    WelcomeText.Parent := WizardForm.WelcomePage;
    WelcomeText.Left := ScaleX(20);
    WelcomeText.Top := WizardForm.WelcomeLabel2.Top + WizardForm.WelcomeLabel2.Height + ScaleY(20);
    WelcomeText.Width := WizardForm.ClientWidth - ScaleX(40);
    WelcomeText.Height := TextHeight + ScaleY(20);
    WelcomeText.AutoSize := False;
    WelcomeText.WordWrap := True;
    WelcomeText.Caption := CustomMessage('WelcomeLabel3');
    WelcomeText.Font.Size := 8;
    WizardForm.WelcomePage.Height := WelcomeText.Top + WelcomeText.Height + ScaleY(80);
  finally
    HideSplashScreen;
  end;
end;