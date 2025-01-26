//------------------------------------------------------------------------------
//   Base Code - here are defined all the basic stuff
//------------------------------------------------------------------------------
//
//   Author:  Jan Urbansky
//   Created: 2025-01-18
//   Version: 1.0
//

#include ".\Dialogs\pageReposDir.iss"
#include ".\Dialogs\pageService.iss"
#include ".\Dialogs\pageReposAdmin.iss"

[Code]
function CreateScheduledTask() : Boolean;
var
  tmp, tmpFile: String;
  str: AnsiString;
  ResultCode: Integer;
begin
  tmpFile := ExpandConstant('{tmp}\ScheduledTaskConfig.xml');
  LoadStringFromFile(tmpFile, str);

  tmp:= string(str);

  StringChangeEx( tmp, '{computername}', GetComputerNameString, True );
  StringChangeEx( tmp, '{username}', ExpandConstant('{username}'), True );
  StringChangeEx( tmp, '{app}', ExpandConstant('{app}'), True );

  str := AnsiString(tmp);

  SaveStringToFile(tmpFile, str, false);

  Result:= Exec(ExpandConstant('{cmd}'), '/c schtasks /create /tn "{#SVNTaskSchedulerName}" /xml "' + tmpFile + '"', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

procedure RemoveEnvironmentVars();
var
  Paths, regkey : String;
  str : TArrayOfString;
  sl: TStringList;
  x: LongInt;
begin
  regkey := 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

  if RegQueryStringValue(HKLM, regkey, 'Path', Paths) then
  begin
    str := StringSplit(Paths, [';'], stExcludeEmpty);

    sl:= TStringList.Create;

    for x:= 0 to GetArrayLength(str)-1 do sl.Add(str[x]);

    sl.Delete( sl.IndexOf('%SVN_HOME%') );
    sl.Delete( sl.IndexOf('%SVN_BINDIR%') );
    sl.Delete( sl.IndexOf('%SVNPath%') );

    Paths:= '';

    for x:= 0 to sl.Count-1 do
    begin
      Paths := Paths + sl[x];
      if x <> sl.Count-1 then Paths := Paths + ';';
    end;

    RegWriteStringValue(HKLM, regkey, 'Path', Paths);
  end;
end;

function InitializeSetup: Boolean;
begin
  ExtractTemporaryFile('Databases.ico');
  ExtractTemporaryFile('ServiceController.ico');
  ExtractTemporaryFile('ReposAdminUser.ico');
  ExtractTemporaryFile('ScheduledTaskConfig.xml');
  
  Result := True;
end;
  
procedure InitializeWizard();
begin
  { Some properties }
  WizardForm.DiskSpaceLabel.Hide;

  { Create custom pages }
  wpReposDir_CreatePage(wpSelectDir); // select repo dir page after default dir page
  wpService_CreatePage(wpReposDir.ID); // service page after repo dir page
  wpReposAdmin_CreatePage(wpService.ID); // define admin account after service page
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    // remove environment path variables
    RemoveEnvironmentVars();
  end;
end;
