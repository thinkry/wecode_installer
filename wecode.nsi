; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "WeCode"
!define PRODUCT_VERSION "1.1.9"
!define PRODUCT_WEB_SITE "http://thinkry.github.io"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\WeCode.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "res\m.ico"
!define MUI_UNICON "res\Only.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "res\back.bmp"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "SimpChinese"

; MUI end ------

RequestExecutionLevel admin #NOTE: You still need to check user rights with UserInfo!

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "wecode1.1.9.exe"
InstallDir "$PROGRAMFILES\WeCode"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
BrandingText "WeCode程序员云笔记"

; ------ Exe 文件添加版本信息（这个放到 MUI_LANGUAGE后面，否则中文是乱码） ------
VIProductVersion "1.1.9.0"
;产品名称
VIAddVersionKey /LANG=${LANG_SimpChinese} "ProductName" "WeCode程序员云笔记-安装程序"
;产品版本
VIAddVersionKey /LANG=${LANG_SimpChinese} "ProductVersion" "1.1.9"
;版权
VIAddVersionKey /LANG=${LANG_SimpChinese} "LegalCopyright" "Copyright (c) 2015-2017"
;描述
VIAddVersionKey /LANG=${LANG_SimpChinese} "FileDescription" "WeCode程序员云笔记-安装程序"
;文件版本号
VIAddVersionKey /LANG=${LANG_SimpChinese} "FileVersion" "1.1.9.0"
; ------ Exe 文件添加版本信息 结束 ------

Section -.NET
Call GetNetFrameworkVersion
Pop $R1
 ${If} $R1 < 'v2.0.50727'
 SetDetailsPrint textonly
 DetailPrint "正在安装 .NET Framework 4"
 SetDetailsPrint listonly

 SetOutPath "$TEMP"
 SetOverwrite on
 File ".\dotNetFx40_Full_setup.exe"
 ExecWait '$TEMP\dotNetFx40_Full_setup.exe /norestart /ChainingPackage FullX64Bootstrapper' $R1
 Delete "$TEMP\dotNetFx40_Full_setup.exe"
 ${EndIf}
SectionEnd

Section "主程序" SEC01
  SectionIn RO
  SetShellVarContext all
  SetOutPath "$INSTDIR"
  SetOverwrite on
  File "..\wecode\bin\Release\WeifenLuo.WinFormsUI.Docking.dll"
  File "..\wecode\bin\Release\WeCode.exe"
  File "..\wecode\bin\Release\TreeNodeLocal.xml"
  File "..\wecode\bin\Release\ScintillaNET.dll"
  File "..\wecode\bin\Release\Newtonsoft.Json.dll"
  File "..\wecode\bin\Release\Interop.JRO.dll"
  File "..\wecode\bin\Release\Interop.ADOX.dll"
  File "..\wecode\bin\Release\Interop.ADODB.dll"
  File "..\wecode\bin\Release\DockPanel.config"
  File "..\wecode\bin\Release\SciLexer64.dll"
  File "..\wecode\bin\Release\SciLexer.dll"
  SetOutPath "$INSTDIR\temp"
  File "..\wecode\bin\Release\temp\m.ico"
  SetOutPath "$INSTDIR\db"
  SetOverwrite off
  File "..\wecode\bin\Release\db\helpdb.mdb"
  SetOutPath "$INSTDIR"
  File "..\wecode\bin\Release\WeCode.exe.Config"
SectionEnd

Section "快速启动" SEC02
  SetShellVarContext all
  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\WeCode"
  CreateShortCut "$SMPROGRAMS\WeCode\WeCode.lnk" "$INSTDIR\WeCode.exe"
  CreateShortCut "$SMPROGRAMS\WeCode\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section "桌面快捷方式" SEC03
  SetShellVarContext all
  SetOutPath $INSTDIR
  CreateShortCut "$DESKTOP\WeCode.lnk" "$INSTDIR\WeCode.exe" "" "$INSTDIR\temp\m.ico"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
SectionEnd

Section -Post
  SetShellVarContext all
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\WeCode.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\WeCode.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "主程序相关"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "开始菜单的快捷方式"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "桌面快捷方式"
!insertmacro MUI_FUNCTION_DESCRIPTION_END


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从你的计算机移除。"
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你确实要完全移除 $(^Name) ，其及所有的组件？" IDYES +2
  Abort
FunctionEnd

Function GetNetFrameworkVersion
;获取.Net Framework版本支持
Push $1
Push $0
ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" "Install"
ReadRegDWORD $1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" "Version"
StrCmp $0 1 KnowNetFrameworkVersion +1
ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" "Install"
ReadRegDWORD $1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" "Version"
StrCmp $0 1 KnowNetFrameworkVersion +1
ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0\Setup" "InstallSuccess"
ReadRegDWORD $1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.0\Setup" "Version"
StrCmp $0 1 KnowNetFrameworkVersion +1
ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727" "Install"
ReadRegDWORD $1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727" "Version"
StrCmp $1 "" +1 +2
StrCpy $1 "2.0.50727.832"
StrCmp $0 1 KnowNetFrameworkVersion +1
ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322" "Install"
ReadRegDWORD $1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v1.1.4322" "Version"
StrCmp $1 "" +1 +2
StrCpy $1 "1.1.4322.573"
StrCmp $0 1 KnowNetFrameworkVersion +1
ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\.NETFramework\policy\v1.0" "Install"
ReadRegDWORD $1 HKLM "SOFTWARE\Microsoft\.NETFramework\policy\v1.0" "Version"
StrCmp $1 "" +1 +2
StrCpy $1 "1.0.3705.0"
StrCmp $0 1 KnowNetFrameworkVersion +1
StrCpy $1 "not .NetFramework"
KnowNetFrameworkVersion:
Pop $0
Exch $1
FunctionEnd

Section Uninstall
  SetShellVarContext all
  Delete "$INSTDIR\uninst.exe"
  ;Delete "$INSTDIR\db\helpdb.mdb"
  Delete "$INSTDIR\temp\m.ico"
  Delete "$INSTDIR\SciLexer.dll"
  Delete "$INSTDIR\SciLexer64.dll"
  Delete "$INSTDIR\DockPanel.config"
  Delete "$INSTDIR\Interop.ADODB.dll"
  Delete "$INSTDIR\Interop.ADOX.dll"
  Delete "$INSTDIR\Interop.JRO.dll"
  Delete "$INSTDIR\Newtonsoft.Json.dll"
  Delete "$INSTDIR\ScintillaNET.dll"
  Delete "$INSTDIR\TreeNodeLocal.xml"
  Delete "$INSTDIR\WeCode.exe"
  Delete "$INSTDIR\WeCode.exe.Config"
  Delete "$INSTDIR\WeifenLuo.WinFormsUI.Docking.dll"

  Delete "$SMPROGRAMS\WeCode\Uninstall.lnk"
  Delete "$DESKTOP\WeCode.lnk"
  Delete "$SMPROGRAMS\WeCode\WeCode.lnk"

  RMDir "$SMPROGRAMS\WeCode"
  RMDir "$INSTDIR\temp"
  ;RMDir "$INSTDIR\db"
  ;RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd