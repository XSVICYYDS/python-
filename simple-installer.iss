; Inno Setup 安装程序配置文件
; 小白桌面宠物

[Setup]
AppName=Smart Desktop Pet - Xiaobai
AppVersion=1.0.0
AppPublisher=Shangzhi Middle School Class 809
DefaultDirName={pf}\Smart Desktop Pet - Xiaobai
DefaultGroupName=Smart Desktop Pet - Xiaobai
OutputDir=..\Output
OutputBaseFilename=Xiaobai-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
AllowNoIcons=yes
UninstallDisplayIcon={app}\SmartDesktopPet.exe
DisableDirPage=no
DisableProgramGroupPage=no
DisableFinishedPage=no
DisableWelcomePage=no
ShowLanguageDialog=no

[Files]
Source: "..\dist\SmartDesktopPet\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Smart Desktop Pet - Xiaobai"; Filename: "{app}\SmartDesktopPet.exe"
Name: "{group}\Uninstall Smart Desktop Pet - Xiaobai"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Smart Desktop Pet - Xiaobai"; Filename: "{app}\SmartDesktopPet.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Run]
Filename: "{app}\SmartDesktopPet.exe"; Description: "Launch Smart Desktop Pet - Xiaobai"; Flags: nowait postinstall skipifsilent
