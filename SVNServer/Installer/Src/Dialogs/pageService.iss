//------------------------------------------------------------------------------
//   wpService - Set up the Windows service
//------------------------------------------------------------------------------
//
//   Author:  Jan Urbansky
//   Created: 2025-01-18
//   Version: 1.0
//

#define wpServiceIcon "ServiceController.ico"

[CustomMessages]
wpServiceWindowCaption=Configure Windows Service
wpServiceWindowDescription=Set up the Windows Service for SVN Server
wpServicePageCaption=If you would like to customize the Windows service, take your choices. Then click Next.
wpServiceServiceNameCaption=Service Name:
wpServiceDisplayNameCaption=Display Name:
wpServiceDescriptionCaption=Description:
wpServiceStartupTypeCaption=Startup Type:
wpServiceStdSettingsCaption=Standard settings
wpServiceCustomSettingsCaption=Custom:
wpServiceStartupTypeItem0=Auto
wpServiceStartupTypeItem1=Delayed-Auto
wpServiceStartupTypeItem2=Demand
wpServiceStartupTypeItem3=Disabled

[Code]
var
  wpService: TWizardPage;
  icoService: TBitmapImage;
  lblSvcPageDescription: TLabel;
  lblSvcServiceName: TLabel;
  lblSvcDisplayName: TLabel;
  lblSvcDescription: TLabel;
  lblSvcStartupType: TLabel;
  rbSvcStdSettings: TRadioButton;
  rbSvcCustomSettings: TRadioButton;
  txtSvcServiceName: TEdit;
  txtSvcDisplayName: TEdit;
  txtSvcDescription: TEdit;
  cbSvcStartupType: TComboBox;

  SvcInfo: TArrayOfString;
  SvcName: String;
  SvcDesc: String;
  SvcDisplayName: String;

function GetStartType() : String;
begin
  case cbSvcStartupType.ItemIndex of 
    0: Result:= 'auto';
    1: Result:= 'delayed-auto';
    2: Result:= 'demand';
    3: Result:= 'diabled';
  end;
end;

procedure SetSvnInfo();
begin
  SvcInfo[0] := '{#SVNSvcName}';
  SvcInfo[1] := '{#SVNSvcDisplayName}';
  SvcInfo[2] := '{#SVNSvcDesc}';
  SvcInfo[3] := 'auto';

  if rbSvcCustomSettings.Checked then
  begin
    SvcInfo[0] := txtSvcServiceName.Text;
    SvcInfo[1] := txtSvcDisplayName.Text;
    SvcInfo[2] := txtSvcDescription.Text;
    SvcInfo[3] := GetStartType();
  end;

  //SaveStringsToFile('C:\Temp\SvcInfo.txt', SvcInfo, false);
end;

function GetSvcInfo(Param: String) : String;
begin
  Result := SvcInfo[StrToInt(Param)];
end;

{ rbSvcCustomSettingsClick }
procedure rbClick(Sender: TObject);
var
  chk : Boolean;
begin
  chk := rbSvcCustomSettings.Checked;

  lblSvcServiceName.Enabled := chk;
  lblSvcDisplayName.Enabled := chk;
  lblSvcDescription.Enabled := chk;
  lblSvcStartupType.Enabled := chk;
  txtSvcServiceName.Enabled := chk;
  txtSvcDisplayName.Enabled := chk;
  txtSvcDescription.Enabled := chk;
  cbSvcStartupType.Enabled := chk;
end;

{ wpServicePage_Activate }
procedure wpService_Activate(Page: TWizardPage);
begin
  // enter code here...
end;

{ wpService_ShouldSkipPage }
function wpService_ShouldSkipPage(Page: TWizardPage): Boolean;
begin
  Result := False;
end;

{ wpService_BackButtonClick }
function wpService_BackButtonClick(Page: TWizardPage): Boolean;
begin
  Result := True;
end;

{ wpService_NextkButtonClick }
function wpService_NextButtonClick(Page: TWizardPage): Boolean;
begin
  SetSvnInfo();
  Result := True;
end;

{ wpService_CancelButtonClick }
procedure wpService_CancelButtonClick(Page: TWizardPage; var Cancel, Confirm: Boolean);
begin
  // enter code here...
end;

{ wpService_CreatePage }
function wpService_CreatePage(PreviousPageId: Integer): Integer;
begin
  wpService := CreateCustomPage(
    PreviousPageId,
    ExpandConstant('{cm:wpServiceWindowCaption}'),
    ExpandConstant('{cm:wpServiceWindowDescription}')
  );

  SetArrayLength(SvcInfo, 4);

  { icoService }
  icoService := TBitmapImage.Create(wpService);
  with icoService do
  begin
    Parent := wpService.Surface;
    Left := ScaleX(0);
    Top := ScaleY(0);
    Width := ScaleX(32);
    Height := ScaleY(32);
  end;

  InitializeBitmapImageFromIcon(icoService, ExpandConstant('{tmp}') + '\{#wpServiceIcon}', wpService.SurfaceColor, [32, 48, 64]);

  { lblSvcPageDescription }
  lblSvcPageDescription := TLabel.Create(wpService);
  with lblSvcPageDescription do
  begin
    Parent := wpService.Surface;
    Caption := ExpandConstant('{cm:wpServicePageCaption}');
    WordWrap := True;
    AutoSize:= True;
    Left := ScaleX(40);
    Top := ScaleY(0);
    Width := ScaleX(367); //77
    Height := ScaleY(29);
  end;

  { rbSvcStdSettings }
  rbSvcStdSettings := TRadioButton.Create(wpService);
  with rbSvcStdSettings do
  begin
    Parent := wpService.Surface;
    Caption := ExpandConstant('{cm:wpServiceStdSettingsCaption}');
    Left := ScaleX(8);
    Top := ScaleY(40);
    Width := ScaleX(113);
    Height := ScaleY(17);
    Checked := True;
    TabOrder := 0;
    TabStop := True;
    OnClick := @rbClick;
  end;
  
  { rbSvcCustomSettings }
  rbSvcCustomSettings := TRadioButton.Create(wpService);
  with rbSvcCustomSettings do
  begin
    Parent := wpService.Surface;
    Caption := ExpandConstant('{cm:wpServiceCustomSettingsCaption}');
    Left := ScaleX(8);
    Top := ScaleY(64);
    Width := ScaleX(113);
    Height := ScaleY(17);
    TabOrder := 1;
    OnClick := @rbClick;
  end;

  { lblSvcServiceName }
  lblSvcServiceName := TLabel.Create(wpService);
  with lblSvcServiceName do
  begin
    Parent := wpService.Surface;
    Caption := ExpandConstant('{cm:wpServiceServiceNameCaption}');
    Left := ScaleX(40);
    Top := ScaleY(94);
    Width := ScaleX(70);
    Height := ScaleY(13);
    Enabled := False;
  end;
  
  { lblSvcDisplayName }
  lblSvcDisplayName := TLabel.Create(wpService);
  with lblSvcDisplayName do
  begin
    Parent := wpService.Surface;
    Caption := ExpandConstant('{cm:wpServiceDisplayNameCaption}');
    Left := ScaleX(40);
    Top := ScaleY(126);
    Width := ScaleX(70);
    Height := ScaleY(13);
    Enabled := False;
  end;
  
  { lblSvcDescription }
  lblSvcDescription := TLabel.Create(wpService);
  with lblSvcDescription do
  begin
    Parent := wpService.Surface;
    Caption := ExpandConstant('{cm:wpServiceDescriptionCaption}');
    Left := ScaleX(40);
    Top := ScaleY(158);
    Width := ScaleX(70);
    Height := ScaleY(13);
    Enabled := False;
  end;

  { lblSvcStartupType }
  lblSvcStartupType := TLabel.Create(wpService);
  with lblSvcStartupType do
  begin
    Parent := wpService.Surface;
    Caption := ExpandConstant('{cm:wpServiceStartupTypeCaption}');
    Left := ScaleX(40);
    Top := ScaleY(190);
    Width := ScaleX(70);
    Height := ScaleY(13);
    Enabled := False;
    //Visible := False;
  end;
  
  { txtSvcServiceName }
  txtSvcServiceName := TEdit.Create(wpService);
  with txtSvcServiceName do
  begin
    Parent := wpService.Surface;
    Left := ScaleX(160);
    Top := ScaleY(92);
    Width := ScaleX(241);
    Height := ScaleY(21);
    Enabled := False;
    TabOrder := 2;
    Text := ExpandConstant('{#SVNSvcName}');
  end;
  
  { txtSvcDisplayName }
  txtSvcDisplayName := TEdit.Create(wpService);
  with txtSvcDisplayName do
  begin
    Parent := wpService.Surface;
    Left := ScaleX(160);
    Top := ScaleY(124);
    Width := ScaleX(241);
    Height := ScaleY(21);
    Enabled := False;
    TabOrder := 3;
    Text := ExpandConstant('{#SVNSvcDisplayName}');
  end;
  
  { txtSvcDescription }
  txtSvcDescription := TEdit.Create(wpService);
  with txtSvcDescription do
  begin
    Parent := wpService.Surface;
    Left := ScaleX(160);
    Top := ScaleY(156);
    Width := ScaleX(241);
    Height := ScaleY(21);
    Enabled := False;
    TabOrder := 4;
    Text := ExpandConstant('{#SVNSvcDesc}');
  end;
  
  { cbSvcStartupType }
  cbSvcStartupType := TComboBox.Create(wpService);
  with cbSvcStartupType do
  begin
    Parent := wpService.Surface;
    Left := ScaleX(160);
    Top := ScaleY(188);
    Width := ScaleX(105);
    Height := ScaleY(21);
    Enabled := False;
    Style := csDropDownList;
    TabOrder := 5;
    Items.Add(ExpandConstant('{cm:wpServiceStartupTypeItem0}'));
    Items.Add(ExpandConstant('{cm:wpServiceStartupTypeItem1}'));
    Items.Add(ExpandConstant('{cm:wpServiceStartupTypeItem2}'));
    Items.Add(ExpandConstant('{cm:wpServiceStartupTypeItem3}'));
    ItemIndex := 0;
    //Visible := False;
  end;

  with wpService do
  begin
    OnActivate := @wpService_Activate;
    OnShouldSkipPage := @wpService_ShouldSkipPage;
    OnBackButtonClick := @wpService_BackButtonClick;
    OnNextButtonClick := @wpService_NextButtonClick;
    OnCancelButtonClick := @wpService_CancelButtonClick;
  end;

  Result := wpService.ID;
end;
