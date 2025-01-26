//------------------------------------------------------------------------------
//   wpReposDir - Selects the repository data directory
//------------------------------------------------------------------------------
//
//   Author:  Jan Urbansky
//   Created: 2025-01-18
//   Version: 1.0
//

#define wpReposDirIcon "Databases.ico"

[CustomMessages]
wpReposDirWindowCaption=Select Repository Data Directory
wpReposDirWindowDescription=Where should repository data files be installed?
wpReposDirIconCaption=SVN Server will store the repositories into following folder.
wpReposDirPageDescription=Select the folder in which Setup should install repository data files, then click Next.
wpReposDirReposPath=Edit1
wpReposDirBtnBrowse=B&rowse...

[Code]
var
  wpReposDir: TWizardPage;
  icoReposDir: TBitmapImage;
  lblReposDirPageDescription: TLabel;
  lblReposDirIcon: TLabel;
  txtReposDirReposPath: TEdit;
  btnReposDirBrowse: TButton;

{ wpReposDir_Activate }

procedure wpReposDir_Activate(Page: TWizardPage);
begin
  // enter code here...
end;

{ wpReposDir_ShouldSkipPage }

function wpReposDir_ShouldSkipPage(Page: TWizardPage): Boolean;
begin
  Result := False;
end;

{ wpReposDir_BackButtonClick }

function wpReposDir_BackButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
end;

{ wpReposDir_NextkButtonClick }

function wpReposDir_NextButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
end;

{ wpReposDir_CancelButtonClick }

procedure wpReposDir_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
begin
  // enter code here...
end;

{ btnReposDirBrowse_Click }
procedure btnReposDirBrowse_Click(Sender: TObject);
var
  SelectedFolder: string;
begin
  SelectedFolder := txtReposDirReposPath.Text;

  if BrowseForFolder('Please select a folder:', SelectedFolder, True) then
  begin
    txtReposDirReposPath.Text := SelectedFolder;
  end;
end;

{ wpReposDir_CreatePage }

function wpReposDir_CreatePage(PreviousPageId: Integer): Integer;
begin
  wpReposDir := CreateCustomPage(
    PreviousPageId,
    ExpandConstant('{cm:wpReposDirWindowCaption}'),
    ExpandConstant('{cm:wpReposDirWindowDescription}')
  );

  { icoReposDir }
  icoReposDir := TBitmapImage.Create(wpReposDir);
  with icoReposDir do
  begin
    Parent := wpReposDir.Surface;
    Left := ScaleX(0);
    Top := ScaleY(0);
    Width := ScaleX(32);
    Height := ScaleY(32);
  end;

  InitializeBitmapImageFromIcon(icoReposDir, ExpandConstant('{tmp}') + '\{#wpReposDirIcon}', wpReposDir.SurfaceColor, [32, 48, 64]);

  
  { lblReposDirIcon }
  lblReposDirIcon := TLabel.Create(wpReposDir);
  with lblReposDirIcon do
  begin
    Parent := wpReposDir.Surface;
    Caption := ExpandConstant('{cm:wpReposDirIconCaption}');
    Left := ScaleX(40);
    Top := ScaleY(6);
    Width := ScaleX(367);
    Height := ScaleY(13);
  end;
  
  { lblReposDirPageDescription }
  lblReposDirPageDescription := TLabel.Create(wpReposDir);
  with lblReposDirPageDescription do
  begin
    Parent := wpReposDir.Surface;
    Caption := ExpandConstant('{cm:wpReposDirPageDescription}');
    Left := ScaleX(0);
    Top := ScaleY(38);
    Width := ScaleX(407);
    Height := ScaleY(13);
  end;
 
  { txtReposDirReposPath }
  txtReposDirReposPath := TEdit.Create(wpReposDir);
  with txtReposDirReposPath do
  begin
    Parent := wpReposDir.Surface;
    Left := ScaleX(0);
    Top := ScaleY(63);
    Width := ScaleX(332);
    Height := ScaleY(21);
    TabOrder := 0;
    Text := WizardDirValue() +  + '{#SVNRootDir}' //ExpandConstant('{cm:wpReposDirReposPath}');
  end;
  
  { btnReposDirBrowse }
  btnReposDirBrowse := TButton.Create(wpReposDir);
  with btnReposDirBrowse do
  begin
    Parent := wpReposDir.Surface;
    Caption := ExpandConstant('{cm:wpReposDirBtnBrowse}');
    Left := ScaleX(342);
    Top := ScaleY(62);
    Width := ScaleX(75);
    Height := ScaleY(22);
    TabOrder := 1;
    OnClick := @btnReposDirBrowse_Click;
  end;

  with wpReposDir do
  begin
    OnActivate := @wpReposDir_Activate;
    OnShouldSkipPage := @wpReposDir_ShouldSkipPage;
    OnBackButtonClick := @wpReposDir_BackButtonClick;
    OnNextButtonClick := @wpReposDir_NextButtonClick;
    OnCancelButtonClick := @wpReposDir_CancelButtonClick;
  end;

  Result := wpReposDir.ID;
end;

function GetReposDir(Param: String): String;
begin
  { Returns the selected DataDir }
  Result := txtReposDirReposPath.Text;
end;
