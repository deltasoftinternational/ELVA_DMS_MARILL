Page 25006671 "Checklist Serv. Adv. Activit."
{
    // 28/06/2018 P30 GH
    //   Added field:
    //     "Pending Tasks
    //   Modified trigger OnOpenPage
    // 
    // 27/03/2018 GP1 P30
    //   Modified trigger
    //     OnOpenPage
    //   Added fields:
    //     "VHC - Reminders Overdue"
    //     "VHC - Reminders Upcoming"

    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Checklist Service Cue";

    layout
    {
        area(content)
        {
            cuegroup(Orders)
            {
                Caption = 'Orders';
                field(OrdersTotal; Rec."Orders -Total")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders -Total';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(OrdersPending; Rec."Orders - Pending")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - Pending';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(OrdersInProcess; Rec."Orders - In Process")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - In Process';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(OrdersWorkComplete; Rec."Orders - Finished")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - Work Complete';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field("Orders - Collection"; Rec."Orders - Finished")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - Collection Ready';
                    DrillDownPageID = "Service Orders EDMS";
                    Visible = false;
                }
                field(OrdersOnHold; Rec."Orders - On Hold")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Service Orders EDMS";
                }
            }
            cuegroup(OrdersV2Preview)
            {
                Caption = 'Orders V2 Preview';
                Visible = GHBeta;
                field(Total_V2; Rec."Orders -Total")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders -Total V2';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(OrdersPendingTodayV2; Rec."Orders - Pending Today")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - Pending Today V2';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(OrdersInProcess2; Rec."Orders - In Process")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - In Process V2';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(OrdersFinished2; Rec."Orders - Finished")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - Work Complete V2';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(OrdersOnHold2; Rec."Orders - On Hold")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - On Hold V2';
                    DrillDownPageID = "Service Orders EDMS";
                }
                field(OrdersReadyForCollectionV2; Rec."Orders - Ready For Collection")
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders - Ready For Collection V2';
                    DrillDownPageID = "Service Orders EDMS";
                }
            }
            cuegroup(VehicleInspection)
            {
                Caption = 'Vehicle Inspection';
                field(VehInspectionsPending; Rec."Veh. Inspections - Pending")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Process Checklist List";
                    Image = Checklist;
                }
                field(VehInspectionsInProgress; Rec."Veh. Inspections - In Progress")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Process Checklist List";
                    Image = Checklist;
                }
                field(VehInspectionsAwConfirm; Rec."Veh. Inspections - Aw.Confirm")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Process Checklist List";
                    Image = Checklist;
                    ToolTip = 'Completed Vehicle Inspections that require Advisor''s confirmation';
                }
            }
            cuegroup(VehicleHealthCheck)
            {
                Caption = 'Vehicle Health Check';
                Visible = ShowVHCActivities;
                field(VHCAwaitingAction; Rec."VHC - Awaiting Action")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vehicle Health Checks";
                    Image = Star;
                }
                field(VHCAwaitingParts; Rec."VHC - Awaiting Parts")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vehicle Health Checks";
                }
                field(VHCAwaitingAdvisor; Rec."VHC - Awaiting Advisor")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vehicle Health Checks";
                }
                field(VHCAwaitingAuthorisation; Rec."VHC - Awaiting Authorisation")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vehicle Health Checks";
                    Image = People;
                }
                field(VHCCompleted; Rec."VHC - Completed")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vehicle Health Checks";
                }
                field(VHCRemindersOverdue; Rec."VHC - Reminders Overdue")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vehicle Health Check Lines";
                    Image = Time;
                }
                field(VHCRemindersUpcoming; Rec."VHC - Reminders Upcoming")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vehicle Health Check Lines";
                    Image = Time;
                }
            }
            cuegroup(Quotes)
            {
                Caption = 'Quotes';
                field(ServiceQuotes; Rec."Service Quotes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    DrillDownPageID = "Service Quotes EDMS";
                    Image = Calculator;
                }
            }
            cuegroup(MyTasks)
            {
                Caption = 'My Tasks';
                field(PendingTasks; Rec."Pending Tasks")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "User Task List";
                    ToolTip = 'Specifies the number of pending tasks that are assigned to you.';
                }
            }
            cuegroup(Camera)
            {
                Caption = 'Camera';
                Visible = HasCamera;

                actions
                {
                    action(CreateVehPictureWithCamera)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Take Vehicle Picture with Camera';
                        Image = TileCamera;

                        trigger OnAction()
                        var
                            //CameraOptions: dotnet CameraOptions;
                            PictureMgtSetup: Record "Picture Mgt. Setup";
                            Camera: Codeunit Camera;
                            InstreamPic: InStream;
                            PicName: Text;
                            Out: OutStream;
                            NoSeriesMgt: Codeunit "No. Series";
                            Picture: Record Picture;
                        begin
                            if not HasCamera then
                                exit;

                            //CameraOptions := CameraOptions.CameraOptions;

                            PictureMgtSetup.Get;
                            if PictureMgtSetup."Camera Picture Quality" = 0 then
                                // CameraOptions.Quality := 100 // 100%
                                Camera.GetPicture(100, InstreamPic, PicName)
                            else
                                Camera.GetPicture(PictureMgtSetup."Camera Picture Quality", InstreamPic, PicName);
                            Picture.Init();
                            Picture.Validate("Source Type", Database::"Checklist Service Cue");
                            //Picture.Validate("Source Subtype", Rec."Source Subtype");
                            Picture.Validate("Source ID", Rec."Primary Key");
                            Clear(Picture.Blob);
                            Picture.Blob.CreateOutStream(Out);
                            CopyStream(Out, InstreamPic);
                            Picture."No." := NoSeriesMgt.GetNextNo(PictureMgtSetup."Picture Nos.", 0D, true);
                            Picture.Description := PicName;
                            Picture.Default := false;
                            Picture.Insert(true);
                            // CameraOptions.Quality := PictureMgtSetup."Camera Picture Quality";

                            //CameraProvider.RequestPictureAsync(CameraOptions);
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic;
                Caption = 'Set Up Cues';
                Image = Setup;

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        UpdateGroupsVisibility;
        //AutoPlayWelcomeVideo := VideoVisible and MiniGettingStartedMgt.ShouldWelcomeVideoBePlayed; //FIXME
    end;

    trigger OnOpenPage()
    var
        UserProfileMgt: Codeunit UserProfileManagement;
        BranchProfileSetup: Record "Branch Profile Setup";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        EndOfTodayDT: Decimal;
        camera: Codeunit Camera;
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
        ServiceMgtSetup.Get;
        Rec.SetFilter("Date Filter 3", '%1', WorkDate);
        Rec.SetFilter("Date Filter 4", '%1', WorkDate + 1);
        //Rec.SETFILTER("Date Filter 5", '%1..%2', 0D+1,WORKDATE-1);
        Rec.SetRange("Date Filter 5", 20760101D, WorkDate - 1);
        // 27/03/2018 P30 GP1 >>
        if Format(ServiceMgtSetup."VHC Upcoming Rem. Date Formula") <> '' then
            Rec.SetFilter("VHC - Date Filter Rem. Upc.", Format(WorkDate + 1) + '..' + Format(CalcDate(ServiceMgtSetup."VHC Upcoming Rem. Date Formula", WorkDate)))
        else
            Rec.SetFilter("VHC - Date Filter Rem. Upc.", Format(WorkDate + 1) + '..');
        // 27/03/2018 P30 GP1 <<

        // Rec.SETFILTER("Date Filter 1", FORMAT(CALCDATE('<-WD1>',WORKDATE))+'..'+FORMAT(CALCDATE('<WD7>',WORKDATE)));
        // Rec.SETFILTER("Date Filter 2", FORMAT(CALCDATE('<-WD1>',WORKDATE+7))+'..'+FORMAT(CALCDATE('<+WD7>',WORKDATE+7)));
        if UserSetup.Get(UserId) then
            Rec.SetFilter("Salesperson Code", UserSetup."Salespers./Purch. Code");

        if UserProfileMgt.CurrProfileID <> '' then
            if BranchProfileSetup.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                if BranchProfileSetup."Service Location Filter" <> '' then
                    Rec.SetFilter("Location Filter", BranchProfileSetup."Service Location Filter");

        HasCamera := Camera.IsAvailable;
        /* if HasCamera then
             CameraProvider := CameraProvider.Create;*///FIXME

        ShowVHCActivities := ServiceMgtSetup."VHC Tiles Promoted for Advisor";

        Rec.SetRange("User ID Filter", UserId);

        EndOfTodayDT := DateTimeMgt.Datetime(WorkDate, 235959.999T);
        Rec.SetRange("Allocation Date Filter", 0, EndOfTodayDT);

        Rec.SetFilter("Work Status Filter", ServiceMgtSetup."Work Status Ready for Collect.");

        CompanyInformation.Get;
        GHBeta := CompanyInformation."Garage Hive Beta";
    end;

    var
        UserSetup: Record "User Setup";
        //MiniGettingStartedMgt: Codeunit "Getting Started Mgt."; //FIXME
        [InDataSet]
        GettingStartedVisible: Boolean;
        [InDataSet]
        VideoVisible: Boolean;
        [InDataSet]
        AutoPlayWelcomeVideo: Boolean;
        CueSetup: Codeunit "Cues And KPIs";
        // [RunOnClient]
        // [WithEvents]
        // CameraProvider: dotnet CameraProvider; //FIXME
        HasCamera: Boolean;
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        ShowVHCActivities: Boolean;
        CompanyInformation: Record "Company Information";
        GHBeta: Boolean;

    local procedure UpdateGroupsVisibility()
    begin
        /* FIXME
        GettingStartedVisible := MiniGettingStartedMgt.IsGettingStartedVisible;
        VideoVisible := GettingStartedVisible and WelcomeVideoDisplayTargetIsSupported;
        */
    end;

    local procedure WelcomeVideoDisplayTargetIsSupported(): Boolean
    begin
        exit(CurrentClientType = Clienttype::Web);
    end;

    /* FIXME
    trigger Cameraprovider::PictureAvailable(PictureName: Text;PictureFilePath: Text)
    var
        CameraMgt: Codeunit "Camera Mgt";
    begin
        CameraMgt.CreateIncomingPictureFromServerFile(PictureName,PictureFilePath);
        CurrPage.Update;
    end;
    */
}

