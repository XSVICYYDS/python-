; Inno Setup 安装程序配置文件
; 用于创建小白桌面宠物的安装程序

[Setup]
; 应用名称
AppName=智能桌面宠物-小白
; 应用版本
AppVersion=1.0.0
; 应用发布者
AppPublisher=尚志中学809班
; 应用发布者URL
AppPublisherURL=https://github.com/example
; 应用支持URL
AppSupportURL=https://github.com/example
; 应用更新URL
AppUpdateURL=https://github.com/example
; 许可证文件（可选）
; LicenseFile=LICENSE.txt
; 默认安装目录
DefaultDirName={autopf}\智能桌面宠物-小白
; 默认开始菜单文件夹
DefaultGroupName=智能桌面宠物-小白
; 输出目录
OutputDir=..\安装包
; 输出文件名
OutputBaseFilename=智能桌面宠物-小白-安装包
; 安装程序文件名
SetupIconFile=C:\Users\XS\Desktop\小白.ico
; 压缩方式
Compression=lzma2/ultra64
; 压缩级别
SolidCompression=yes
;向导样式
WizardStyle=modern
; 权限提升（Windows Vista及更高版本）
PrivilegesRequired=lowest
; 允许用户修改安装目录
AllowNoIcons=yes
; 卸载程序名称
UninstallDisplayIcon={app}\智能桌面宠物-小白.exe
; 显示自定义向导图片（可选）
; WizardImageFile=wizardimage.bmp
; 显示自定义向导小图片（可选）
; WizardSmallImageFile=wizardsmallimage.bmp

[Languages]
; 语言选择
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
; 创建桌面快捷方式
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
; 创建快速启动栏快捷方式
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode
; 开机自动启动
Name: "auto_start"; Description: "开机自动启动小白"; GroupDescription: "其他选项:"

[Files]
; 打包的文件
; 注意：路径分隔符使用反斜杠
Source: "..\dist\智能桌面宠物-小白\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; 包含Python运行时库（如果需要）
; Source: "python311.dll"; DestDir: "{app}"; Flags: ignoreversion
; Source: "python3.dll"; DestDir: "{app}"; Flags: ignoreversion
; Source: "vcruntime140.dll"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; 开始菜单快捷方式
Name: "{group}\智能桌面宠物-小白"; Filename: "{app}\智能桌面宠物-小白.exe"
Name: "{group}\卸载智能桌面宠物-小白"; Filename: "{uninstallexe}"
; 桌面快捷方式
Name: "{autodesktop}\智能桌面宠物-小白"; Filename: "{app}\智能桌面宠物-小白.exe"; Tasks: desktopicon
; 快速启动栏快捷方式
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\智能桌面宠物-小白"; Filename: "{app}\智能桌面宠物-小白.exe"; Tasks: quicklaunchicon

[Registry]
; 开机自动启动注册表项
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "MalteseDesktopPet"; ValueData: """{app}\智能桌面宠物-小白.exe"""; Flags: uninsdeletevalue; Tasks: auto_start

[Run]
; 安装完成后运行程序
Filename: "{app}\智能桌面宠物-小白.exe"; Description: "{cm:LaunchProgram,智能桌面宠物-小白}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
; 卸载时删除开机自启动注册表项
Filename: "reg"; Parameters: "delete ""HKCU\Software\Microsoft\Windows\CurrentVersion\Run"" /v MalteseDesktopPet /f"; Flags: runhidden

[Code]
; 自定义代码（可选）

// 检查是否已安装
function InitializeSetup(): Boolean;
begin
  Result := True;
end;

// 安装完成后执行
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // 安装后操作
  end;
end;

// 卸载开始前执行
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    // 卸载前操作
  end;
end;
