//------------------------------------------------------------------------------
//   wpReposAdmin - Set up the Repository Administrator
//------------------------------------------------------------------------------
//
//   Author:  Jan Urbansky
//   Created: 2025-01-25
//   Version: 1.0
//

#define wpReposAdminIcon "ReposAdminUser.ico"

[CustomMessages]
wpReposAdminWindowCaption=Configure Repositories Administrator
wpReposAdminWindowDescription=Set up the Administrator account for SVN Server
wpReposAdminIconCaption=Administrator account for all repositories.
wpReposAdminPageDescription=If you would like to customize the Administrator account, take your choices. Then click Next.
wpReposAdminNameCaption=Name:
wpReposAdminPwdCaption=Password:
wpReposAdminPwdSecondCaption=Password (repeat):

[Code]
var
  wpReposAdmin: TWizardPage;
  icoAdminUser: TBitmapImage;
  lblAdminIcon: TLabel;
  lblAdminPageDescription: TLabel;
  lblAdminName: TLabel;
  lblAdminPwd: TLabel;
  lblAdminPwdSecond: TLabel;
  txtAdminName: TEdit;
  txtAdminPwd: TPasswordEdit;
  txtAdminPwdSecond: TPasswordEdit;

  svnAdminName: String;
  svnAdminPwd: String;

function GetSvnAdminName(Params: String): String;
begin
  Result:= svnAdminName;
end;

function GetSvnAdminPwd(Params: String): String;
begin
  Result:= svnAdminPwd;
end;

{ wpReposAdminPage_Activate }
procedure wpReposAdmin_Activate(Page: TWizardPage);
begin
  // enter code here...
end;

{ wpReposAdmin_ShouldSkipPage }
function wpReposAdmin_ShouldSkipPage(Page: TWizardPage): Boolean;
begin
  Result := False;
end;

{ wpReposAdmin_BackButtonClick }
function wpReposAdmin_BackButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
end;

{ wpReposAdmin_NextkButtonClick }
function wpReposAdmin_NextButtonClick(Page: TWizardPage): Boolean;
begin
  Result := False;

  if not SameStr(txtAdminPwd.Text, txtAdminPwdSecond.Text) then
  begin
    MsgBox('The entered passwords does not match.', mbCriticalError, MB_OK);
  end else begin
    svnAdminName := txtAdminName.Text;
    svnAdminPwd := txtAdminPwd.Text;
    Result := True;
  end;
end;

{ wpReposAdmin_CancelButtonClick }
procedure wpReposAdmin_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
begin
  // enter code here...
end;

{ wpReposAdmin_CreatePage }
function wpReposAdmin_CreatePage(PreviousPageId: Integer): Integer;
begin
  wpReposAdmin := CreateCustomPage(
    PreviousPageId,
    ExpandConstant('{cm:wpReposAdminWindowCaption}'),
    ExpandConstant('{cm:wpReposAdminWindowDescription}')
  );

  { icoAdminUser }
  icoAdminUser := TBitmapImage.Create(wpReposAdmin);
  with icoAdminUser do
  begin
    Parent := wpReposAdmin.Surface;
    Left := ScaleX(0);
    Top := ScaleY(0);
    Width := ScaleX(32);
    Height := ScaleY(32);
  end;

  InitializeBitmapImageFromIcon(icoAdminUser, ExpandConstant('{tmp}') + '\{#wpReposAdminIcon}', wpReposAdmin.SurfaceColor, [32, 48, 64]);

  { lblAdminIcon }
  lblAdminIcon := TLabel.Create(wpReposAdmin);
  with lblAdminIcon do
  begin
    Parent := wpReposAdmin.Surface;
    Caption := ExpandConstant('{cm:wpReposAdminIconCaption}');
    Left := ScaleX(40);
    Top := ScaleY(6);
    Width := ScaleX(367);
    Height := ScaleY(13);
  end;

  { lblAdminPageDescription }
  lblAdminPageDescription := TLabel.Create(wpReposAdmin);
  with lblAdminPageDescription do
  begin
    Parent := wpReposAdmin.Surface;
    Caption := ExpandConstant('{cm:wpReposAdminPageDescription}');
    WordWrap := True;
    AutoSize:= True;
    Left := ScaleX(0);
    Top := ScaleY(38);
    Width := ScaleX(407);
    Height := ScaleY(26);
  end;

  { lblAdminName }
  lblAdminName := TLabel.Create(wpReposAdmin);
  with lblAdminName do
  begin
    Parent := wpReposAdmin.Surface;
    Caption := ExpandConstant('{cm:wpReposAdminNameCaption}');
    AutoSize:= True;
    Left := ScaleX(40);
    Top := ScaleY(82);
    Width := ScaleX(117);
    Height := ScaleY(13);
  end;
  
  { lblAdminPwd }
  lblAdminPwd := TLabel.Create(wpReposAdmin);
  with lblAdminPwd do
  begin
    Parent := wpReposAdmin.Surface;
    Caption := ExpandConstant('{cm:wpReposAdminPwdCaption}');
    AutoSize:= True;
    Left := ScaleX(40);
    Top := ScaleY(120);
    Width := ScaleX(117);
    Height := ScaleY(13);
  end;
  
  { lblAdminPwdSecond }
  lblAdminPwdSecond := TLabel.Create(wpReposAdmin);
  with lblAdminPwdSecond do
  begin
    Parent := wpReposAdmin.Surface;
    Caption := ExpandConstant('{cm:wpReposAdminPwdSecondCaption}');
    AutoSize:= True;
    Left := ScaleX(40);
    Top := ScaleY(158);
    Width := ScaleX(117);
    Height := ScaleY(13);
  end;
  
  { txtAdminName }
  txtAdminName := TEdit.Create(wpReposAdmin);
  with txtAdminName do
  begin
    Parent := wpReposAdmin.Surface;
    Left := ScaleX(160);
    Top := ScaleY(79);
    Width := ScaleX(201);
    Height := ScaleY(21);
    TabOrder := 2;
    Text := ExpandConstant('{#AdminName}');
  end;
  
  { txtAdminPwd }
  txtAdminPwd := TPasswordEdit.Create(wpReposAdmin);
  with txtAdminPwd do
  begin
    Parent := wpReposAdmin.Surface;
    Left := ScaleX(160);
    Top := ScaleY(117);
    Width := ScaleX(201);
    Height := ScaleY(21);
    TabOrder := 3;
    Text := ExpandConstant('{#AdminPwd}');
  end;
  
  { txtAdminPwdSecond }
  txtAdminPwdSecond := TPasswordEdit.Create(wpReposAdmin);
  with txtAdminPwdSecond do
  begin
    Parent := wpReposAdmin.Surface;
    Left := ScaleX(160);
    Top := ScaleY(155);
    Width := ScaleX(201);
    Height := ScaleY(21);
    TabOrder := 4;
    Text := ExpandConstant('{#AdminPwd}');
  end;

  with wpReposAdmin do
  begin
    OnActivate := @wpReposAdmin_Activate;
    OnShouldSkipPage := @wpReposAdmin_ShouldSkipPage;
    OnBackButtonClick := @wpReposAdmin_BackButtonClick;
    OnNextButtonClick := @wpReposAdmin_NextButtonClick;
    OnCancelButtonClick := @wpReposAdmin_CancelButtonClick;
  end;

  Result := wpReposAdmin.ID;
end;
