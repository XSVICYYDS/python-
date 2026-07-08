; ===========================================
; 小白智能桌面宠物 - 完整安装程序
; Inno Setup Script v1.0
; 开发者：尚志中学809班徐慎
; ===========================================

#define MyAppName "智能桌面宠物-小白"
#define MyAppVersion "0.4.28"
#define MyAppPublisher "尚志中学809班徐慎"
#define MyAppURL "https://github.com/example"
#define MyAppExeName "智能桌面宠物-小白.exe"

[Setup]
; ===========================================
; 基本配置
; ===========================================
AppId={{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; 安装目录和文件名
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes

; 输出配置
OutputDir=..\小白-安装包
OutputBaseFilename={#MyAppName}-{#MyAppVersion}-Setup
; SetupIconFile - 暂时禁用，等待确认图标文件

; 压缩设置
Compression=lzma2/ultra64
SolidCompression=yes
LZMAUseSeparateProcess=yes

; 安装程序界面
WizardStyle=modern
WizardSizePercent=120,120
WizardImageFile=
WizardSmallImageFile=

; 权限和选项
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
AllowNoIcons=yes

; 许可证文件（如果存在）
; LicenseFile=..\LICENSE.txt

; 卸载配置
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}

; 版本信息
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} 安装程序
VersionInfoCopyright=Copyright (C) 2024 {#MyAppPublisher}
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}

[Languages]
; 语言设置
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
english.FeatureDescription=This is a cute AI desktop pet software

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode
Name: "auto_start"; Description: "开机自动启动小白"; GroupDescription: "其他选项:"

[Files]
; 打包的文件
Source: "..\dist\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: InstallCheck
Source: "..\使用说明.md"; DestDir: "{app}"; Flags: ignoreversion; Check: InstallCheck
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion; Check: InstallCheck

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\使用说明"; Filename: "{app}\使用说明.md"
Name: "{group}\卸载 {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "MalteseDesktopPet"; ValueData: """{app}\{#MyAppExeName}"""; Flags: uninsdeletevalue; Tasks: auto_start
Root: HKCU; Subkey: "Software\{#MyAppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, ' ', '...')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "reg"; Parameters: "delete ""HKCU\Software\Microsoft\Windows\CurrentVersion\Run"" /v MalteseDesktopPet /f"; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
; ===========================================
; 全局变量
; ===========================================
var
  IntroductionPage: TWizardPage;
  LicensePage: TWizardPage;
  UserAccountPage: TWizardPage;
  UsernameInput, PasswordInput: TNewEdit;
  ShowPasswordCheckbox: TNewCheckBox;
  RememberMeCheckbox: TNewCheckBox;
  LoginButton, RegisterButton: TNewButton;
  StatusLabel: TNewStaticText;
  AgreementCheckbox: TNewCheckBox;
  IntroductionPage: TWizardPage;

; ===========================================
; 检查函数
; ===========================================
function InstallCheck(): Boolean;
begin
  Result := True;
end;

function IsUserLoggedIn(): Boolean;
var
  UserFile: String;
  Lines: TArrayOfString;
  LineCount: Integer;
begin
  Result := False;
  UserFile := ExpandConstant('{localappdata}\{#MyAppName}\users.txt');
  if FileExists(UserFile) then
  begin
    if LoadStringsFromFile(UserFile, Lines) then
    begin
      LineCount := GetArrayLength(Lines);
      Result := LineCount >= 2;
    end;
  end;
end;

function ValidateEmail(email: String): Boolean;
var
  i: Integer;
  AtCount: Integer;
begin
  Result := False;
  AtCount := 0;
  
  if Length(email) < 5 then
    Exit;
    
  if Pos('@', email) = 0 then
    Exit;
    
  if Pos('.', email) = 0 then
    Exit;
    
  for i := 1 to Length(email) do
  begin
    if email[i] = '@' then
      Inc(AtCount);
  end;
  
  Result := AtCount = 1;
end;

function UserExists(username: String): Boolean;
var
  UserFile: String;
  Lines: TArrayOfString;
  i: Integer;
begin
  Result := False;
  UserFile := ExpandConstant('{localappdata}\{#MyAppName}\users.txt');
  if FileExists(UserFile) then
  begin
    if LoadStringsFromFile(UserFile, Lines) then
    begin
      for i := 0 to GetArrayLength(Lines) - 1 do
      begin
        if Pos(username + '|', Lines[i]) = 1 then
        begin
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

procedure SaveUser(username, password: String);
var
  UserFile: String;
  UserDir: String;
begin
  UserDir := ExpandConstant('{localappdata}\{#MyAppName}');
  if not DirExists(UserDir) then
    CreateDir(UserDir);
    
  UserFile := UserDir + '\users.txt';
  SaveStringToFile(UserFile, username + '|' + password + '|' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now), True);
end;

; ===========================================
; 创建小白介绍页面
; ===========================================
procedure CreateIntroductionPage();
var
  FeatureLabel1, FeatureLabel2, FeatureLabel3, FeatureLabel4, FeatureLabel5: TNewStaticText;
  StepsLabel, Step1Label, Step2Label, Step3Label, Step4Label: TNewStaticText;
  IntroImage: TBitmapImage;
begin
  IntroductionPage := CreateCustomPage(wpWelcome, '软件介绍', '了解小白智能桌面宠物');

  with TNewStaticText.Create(IntroductionPage) do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '欢迎使用智能桌面宠物-小白！';
    Font.Size := 16;
    Font.Style := [fsBold];
    Left := 20;
    Top := 20;
    Width := PageWidth - 40;
    AutoSize := True;
  end;

  with TNewStaticText.Create(IntroductionPage) do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '这是一款可爱的人工智能桌面宠物软件，它会陪伴您度过每一天。';
    Font.Size := 11;
    Left := 20;
    Top := 55;
    Width := PageWidth - 40;
    AutoSize := True;
  end;

  FeatureLabel1 := TNewStaticText.Create(IntroductionPage);
  with FeatureLabel1 do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '🎨 可爱动画：32+精美动画效果，萌萌哒视觉体验';
    Font.Size := 10;
    Left := 30;
    Top := 95;
    Width := PageWidth - 60;
    AutoSize := True;
  end;

  FeatureLabel2 := TNewStaticText.Create(IntroductionPage);
  with FeatureLabel2 do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '🎮 趣味游戏：多款经典小游戏（数独、华容道、贪吃蛇、2048等）';
    Font.Size := 10;
    Left := 30;
    Top := 120;
    Width := PageWidth - 60;
    AutoSize := True;
  end;

  FeatureLabel3 := TNewStaticText.Create(IntroductionPage);
  with FeatureLabel3 do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '🤖 智能行为：自动执行各种有趣的动作和提醒';
    Font.Size := 10;
    Left := 30;
    Top := 145;
    Width := PageWidth - 60;
    AutoSize := True;
  end;

  FeatureLabel4 := TNewStaticText.Create(IntroductionPage);
  with FeatureLabel4 do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '💬 丰富互动：贴贴、充电、投喂等多种互动方式';
    Font.Size := 10;
    Left := 30;
    Top := 170;
    Width := PageWidth - 60;
    AutoSize := True;
  end;

  FeatureLabel5 := TNewStaticText.Create(IntroductionPage);
  with FeatureLabel5 do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '⚙️ 高度可定制：自由调整外观、行为模式、功能设置';
    Font.Size := 10;
    Left := 30;
    Top := 195;
    Width := PageWidth - 60;
    AutoSize := True;
  end;

  with TNewStaticText.Create(IntroductionPage) do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '安装步骤：';
    Font.Size := 12;
    Font.Style := [fsBold];
    Left := 20;
    Top := 240;
    Width := PageWidth - 40;
    AutoSize := True;
  end;

  Step1Label := TNewStaticText.Create(IntroductionPage);
  with Step1Label do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '1️⃣ 阅读并同意用户许可协议';
    Font.Size := 10;
    Left := 30;
    Top := 270;
    Width := PageWidth - 60;
    AutoSize := True;
  end;

  Step2Label := TNewStaticText.Create(IntroductionPage);
  with Step2Label do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '2️⃣ 创建或登录用户账号';
    Font.Size := 10;
    Left := 30;
    Top := 295;
    Width := PageWidth - 60;
    AutoSize := True;
  end;

  Step3Label := TNewStaticText.Create(IntroductionPage);
  with Step3Label do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '3️⃣ 选择安装位置';
    Font.Size := 10;
    Left := 30;
    Top := 320;
    Width := PageWidth - 60;
    AutoSize := True;
  end;

  Step4Label := TNewStaticText.Create(IntroductionPage);
  with Step4Label do
  begin
    Parent := IntroductionPage.Surface;
    Caption := '4️⃣ 完成安装并启动程序';
    Font.Size := 10;
    Left := 30;
    Top := 345;
    Width := PageWidth - 60;
    AutoSize := True;
  end;
end;

; ===========================================
; 创建用户账号页面
; ===========================================
procedure CreateUserAccountPage();
var
  TitleLabel, UsernameLabel, PasswordLabel: TNewStaticText;
begin
  UserAccountPage := CreateCustomPage(wpLicense, '用户账号', '创建或登录您的账号');

  TitleLabel := TNewStaticText.Create(UserAccountPage);
  with TitleLabel do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '请创建账号或登录已有账号';
    Font.Size := 12;
    Font.Style := [fsBold];
    Left := 20;
    Top := 20;
    Width := PageWidth - 40;
    AutoSize := True;
  end;

  UsernameLabel := TNewStaticText.Create(UserAccountPage);
  with UsernameLabel do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '用户名 / 邮箱：';
    Left := 20;
    Top := 60;
    Width := 120;
    AutoSize := True;
  end;

  UsernameInput := TNewEdit.Create(UserAccountPage);
  with UsernameInput do
  begin
    Parent := UserAccountPage.Surface;
    Name := 'UsernameInput';
    Left := 20;
    Top := 85;
    Width := PageWidth - 80;
    Height := 25;
    Text := '';
    AutoSelect := False;
  end;

  PasswordLabel := TNewStaticText.Create(UserAccountPage);
  with PasswordLabel do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '密码：';
    Left := 20;
    Top := 130;
    Width := 120;
    AutoSize := True;
  end;

  PasswordInput := TNewEdit.Create(UserAccountPage);
  with PasswordInput do
  begin
    Parent := UserAccountPage.Surface;
    Name := 'PasswordInput';
    Left := 20;
    Top := 155;
    Width := PageWidth - 80;
    Height := 25;
    Text := '';
    PasswordChar := '*';
    AutoSelect := False;
  end;

  ShowPasswordCheckbox := TNewCheckBox.Create(UserAccountPage);
  with ShowPasswordCheckbox do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '显示密码';
    Left := 20;
    Top := 190;
    Width := PageWidth - 40;
    OnClick := @ShowPasswordCheckboxClick;
  end;

  RememberMeCheckbox := TNewCheckBox.Create(UserAccountPage);
  with RememberMeCheckbox do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '记住我';
    Left := 20;
    Top := 220;
    Width := PageWidth - 40;
    Checked := False;
  end;

  LoginButton := TNewButton.Create(UserAccountPage);
  with LoginButton do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '登录';
    Left := 20;
    Top := 260;
    Width := 120;
    Height := 30;
    OnClick := @LoginButtonClick;
  end;

  RegisterButton := TNewButton.Create(UserAccountPage);
  with RegisterButton do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '注册新账号';
    Left := 150;
    Top := 260;
    Width := 120;
    Height := 30;
    OnClick := @RegisterButtonClick;
  end;

  StatusLabel := TNewStaticText.Create(UserAccountPage);
  with StatusLabel do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '';
    Left := 20;
    Top := 310;
    Width := PageWidth - 40;
    AutoSize := True;
    Font.Color := clRed;
  end;

  with TNewStaticText.Create(UserAccountPage) do
  begin
    Parent := UserAccountPage.Surface;
    Caption := '提示：注册即表示您同意我们的服务条款和隐私政策';
    Font.Size := 8;
    Font.Color := clGray;
    Left := 20;
    Top := 340;
    Width := PageWidth - 40;
    AutoSize := True;
  end;
end;

; ===========================================
; 事件处理函数
; ===========================================
procedure ShowPasswordCheckboxClick(Sender: TObject);
begin
  if ShowPasswordCheckbox.Checked then
    PasswordInput.PasswordChar := #0
  else
    PasswordInput.PasswordChar := '*';
end;

procedure LoginButtonClick(Sender: TObject);
var
  username, password: String;
begin
  username := Trim(UsernameInput.Text);
  password := Trim(PasswordInput.Text);
  
  if username = '' then
  begin
    StatusLabel.Caption := '错误：请输入用户名或邮箱';
    UsernameInput.SetFocus;
    Exit;
  end;
  
  if password = '' then
  begin
    StatusLabel.Caption := '错误：请输入密码';
    PasswordInput.SetFocus;
    Exit;
  end;
  
  if not ValidateEmail(username) and (Pos('@', username) = 0) then
  begin
    if Length(username) < 3 then
    begin
      StatusLabel.Caption := '错误：用户名长度至少为3个字符';
      UsernameInput.SetFocus;
      Exit;
    end;
  end;
  
  if UserExists(username) then
  begin
    StatusLabel.Caption := '✓ 登录成功！点击下一步继续安装';
    StatusLabel.Font.Color := clGreen;
  end
  else
  begin
    StatusLabel.Caption := '错误：用户不存在，请先注册';
    StatusLabel.Font.Color := clRed;
  end;
end;

procedure RegisterButtonClick(Sender: TObject);
var
  username, password: String;
begin
  username := Trim(UsernameInput.Text);
  password := Trim(PasswordInput.Text);
  
  if username = '' then
  begin
    StatusLabel.Caption := '错误：请输入用户名或邮箱';
    UsernameInput.SetFocus;
    Exit;
  end;
  
  if password = '' then
  begin
    StatusLabel.Caption := '错误：请输入密码';
    PasswordInput.SetFocus;
    Exit;
  end;
  
  if Length(password) < 6 then
  begin
    StatusLabel.Caption := '错误：密码长度至少为6个字符';
    PasswordInput.SetFocus;
    Exit;
  end;
  
  if not ValidateEmail(username) and (Pos('@', username) > 0) then
  begin
    StatusLabel.Caption := '错误：请输入有效的邮箱地址';
    UsernameInput.SetFocus;
    Exit;
  end;
  
  if UserExists(username) then
  begin
    StatusLabel.Caption := '错误：该用户名或邮箱已被注册';
    StatusLabel.Font.Color := clRed;
  end
  else
  begin
    SaveUser(username, password);
    StatusLabel.Caption := '✓ 注册成功！点击下一步继续安装';
    StatusLabel.Font.Color := clGreen;
  end;
end;

procedure InitializeWizard();
begin
  CreateIntroductionPage();
  CreateUserAccountPage();
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // 创建用户数据目录
    CreateDir(ExpandConstant('{localappdata}\{#MyAppName}'));
  end;
end;
