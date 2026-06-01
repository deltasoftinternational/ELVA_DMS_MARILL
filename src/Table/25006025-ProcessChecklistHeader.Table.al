Table 25006025 "Process Checklist Header"
{
    // 14/08/2018 EB.P30 GH
    //   Added function:
    //     InitRecord
    //   Modified function:
    //     CreateLines
    // 
    // 09/08/2018 EB.P30 GH
    //   Modified trigger OnInsert
    //   Added fields:
    //     5043 "No."
    //     5048 "Doc. No. Occurrence"
    // 
    // 16/04/2018
    //   *Modified trigger Template Code - OnValidate()
    // 
    // 12/02/2018 GH P1
    //   *Added ENG captions
    //   *Added field "Process Status"
    //   *Added field "Creation Date"
    //   *Added field "Creation Time"
    //   *Added field "Completion Date"
    //   *Added field "Completion Time"
    //   *Added field "Completed by User ID"
    //   *Modified OnInsert Trigger
    //   *Added field Type
    //   *Modified trigger Template Code - OnValidate()
    //   *Added field "Location Code"
    //   *Added field "Vehicle Registration No."
    //   *Added function OnLookupVehicleRegistrationNo
    //   *Added function VehicleDescription
    //   *Added procedure ShowLines
    // 
    // 29.04.2015 EB.P7 #HklaBug
    //   Template Code - OnValidate() trigger modified.

    Caption = 'Process Checklist Header Arch.';
    LookupPageID = "Process Checklist List";

    fields
    {
        field(10; "No."; Code[10])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    ProcessChecklistSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                end;
            end;
        }
        field(20; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                PictureManagement: Codeunit "Picture Management";
            begin
                //16/03/2018 GH P1 >>
                if "Vehicle Serial No." = '' then begin
                    "Vehicle Registration No." := '';
                    exit;
                end;

                Vehicle.Get("Vehicle Serial No.");
                Vehicle.TestField(Blocked, false);

                "Vehicle Registration No." := Vehicle."Registration No.";
                //16/03/2018 GH P1 <<
                if xRec."Vehicle Serial No." <> Rec."Vehicle Serial No." then
                    PictureManagement.UpdateVehicleSerialNo(Database::"Process Checklist Header", 0, "No.", "Vehicle Serial No.");
            end;
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(40; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
        }
        field(50; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55; "Source Profile"; Integer)
        {
            Caption = 'Source Profile';
            DataClassification = ToBeClassified;
        }
        field(60; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(70; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(80; "Source ID"; Code[20])
        {
            Caption = 'Source ID';

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
            begin
                if "Source Type" = database::"Service Header EDMS" then begin
                    ServiceHeader.Reset;
                    ServiceHeader.SetRange("No.", "Source ID");
                    if ServiceHeader.FindFirst then begin
                        Validate("Sell-to Customer No.", ServiceHeader."Sell-to Customer No.");
                        Validate("Vehicle Serial No.", ServiceHeader."Vehicle Serial No.");
                    end
                end
            end;
        }
        field(100; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            TableRelation = "Questionary Template";

            trigger OnValidate()
            var
                ChecklistLine: Record "Process Checklist Line";
            begin
                if (xRec."Template Code" <> "Template Code") then begin
                    TestField(Status, Status::" ");
                    if xRec."Template Code" <> '' then
                        //16/04/2018 GH P1 >>
                        //IF NOT CONFIRM(ChangeTemplateQst, FALSE) THEN
                        if not Confirm(ChangeTemplateQst, false, FieldCaption("Template Code")) then
                            //16/04/2018 GH P1 <<
                            Error('');
                    DeleteLines;

                    if "Template Code" <> '' then begin
                        //TESTFIELD("Vehicle Serial No."); //15/03/2018 GH P1 - commented
                        ProcessChecklistTemplate.Get("Template Code");
                        //15/03/2018 GH P1 >>
                        Type := ProcessChecklistTemplate.Type;
                        "Checklist Category" := ProcessChecklistTemplate."Checklist Category";
                        //15/03/2018 GH P1 <<
                        //QuestionaryTemplate.TESTFIELD(Blocked, FALSE); //Aleksej pārbaudi šo aizkomentēju jo nekompilējās.
                        CreateLines;
                    end;
                end;
            end;
        }
        field(140; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Released,Canceled';
            OptionMembers = " ",Released,Canceled;

            trigger OnValidate()
            begin
                ChangeStatus(Status);
            end;
        }
        field(150; "Checklist Category"; Code[20])
        {
            Caption = 'Checklist Category';
            TableRelation = "Checklist Category";
        }
        field(200; "Process Date"; Date)
        {
            Caption = 'Process Date';
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
            DataClassification = ToBeClassified;
        }
        field(25006393; "Customer Signature Image"; Blob)
        {
            Caption = 'Signature Image';
            DataClassification = ToBeClassified;
        }
        field(25006394; "Customer Signature Text"; Text[100])
        {
            Caption = 'Signature Text';
            DataClassification = ToBeClassified;
        }
        field(25006395; "Employee Signature Image"; Blob)
        {
            Caption = 'Signature Image';
            DataClassification = ToBeClassified;
        }
        field(25006396; "Employee Signature Text"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25006650; "Process Status"; Option)
        {
            Caption = 'Process Status';
            OptionMembers = Pending,"In Progress",Completed;

            trigger OnValidate()
            begin
                case "Process Status" of
                    "process status"::Pending:
                        begin
                            "Creation Date" := Today;
                            "Creation Time" := Time;
                            "Completion Date" := 0D;
                            "Completion Time" := 0T;
                            "Completed by User ID" := '';
                        end;
                    "process status"::"In Progress":
                        begin
                        end;
                    "process status"::Completed:
                        begin
                            "Completion Date" := Today;
                            "Completion Time" := Time;
                            "Completed by User ID" := UserId;
                        end;
                end;
            end;
        }
        field(25006660; "Creation Date"; Date)
        {
        }
        field(25006662; "Creation Time"; Time)
        {
        }
        field(25006670; "Completion Date"; Date)
        {
        }
        field(25006672; "Completion Time"; Time)
        {
        }
        field(25006680; "Completed by User ID"; Code[50])
        {
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(25006690; Type; Option)
        {
            OptionMembers = " ","Vehicle Inspection";
        }
        field(25006692; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(25006693; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                TextConfirmVehManualCreate: label 'There is no vehicle with Registration No. %1 in the database. Do you want to create a new vehicle manually?';
                NewVehicleSerialNo: Code[20];
                VehicleSelected: Boolean;
            begin
                "Vehicle Registration No." := DelChr("Vehicle Registration No.", '=', ' ');

                if "Vehicle Registration No." = '' then begin
                    Validate("Vehicle Serial No.", '');
                    exit;
                end;

                Vehicle.Reset;
                Vehicle.SetCurrentkey("Registration No.");
                Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
                if Vehicle.FindFirst then begin
                    VehicleSelected := true;
                    if Vehicle.Count > 1 then
                        if not (Page.RunModal(Page::"Vehicle List", Vehicle) = Action::LookupOK) then
                            VehicleSelected := false;
                    if VehicleSelected then begin
                        if "Vehicle Serial No." <> Vehicle."Serial No." then
                            Validate("Vehicle Serial No.", Vehicle."Serial No.")
                    end else
                        "Vehicle Registration No." := xRec."Vehicle Registration No.";
                end else begin
                    Message('No vehicle found with Registration No. %1 in the database.', "Vehicle Registration No.");
                    "Vehicle Registration No." := xRec."Vehicle Registration No.";
                end;
            end;
        }
        field(25006695; "Confirmed by Advisor"; Boolean)
        {

            trigger OnValidate()
            var
                GHFeatureMgt: Codeunit "Checklist Features Mgt.";
            begin
                GHFeatureMgt.ConfirmChecklist(Rec, xRec);
            end;
        }
        field(25006697; "VHC No."; Code[20])
        {
            TableRelation = "Service Header EDMS"."No." where("Document Type" = const(VHC));
        }
        field(25006698; "Make"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle."Make Code" WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(25006699; "Model"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle."Model Code" WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(25006700; "Sell-to Customer No."; Code[20])
        {
            TableRelation = "Customer";

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.get("Sell-to Customer No.") then
                    "Sell-to Customer Name" := Customer.Name
                else
                    "Sell-to Customer Name" := '';
            end;
        }
        field(25006701; "Sell-to Customer Name"; Text[100])
        {

        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Serial No.")
        {
        }
        key(Key3; "Source Type", "Source Subtype", "Source ID")
        {
        }
        key(Key4; Type, "Process Status", "Location Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ProcessChecklistLine: Record "Process Checklist Line";
        PictureManagement: Codeunit "Picture Management";
    begin
        ProcessChecklistLine.Reset;
        ProcessChecklistLine.SetRange("Process Checklist No.", "No.");
        ProcessChecklistLine.DeleteAll(true);
        PictureManagement.DeleteRelatedPictures(Database::"Process Checklist Header", 0, "No.", "Vehicle Serial No.");
    end;

    trigger OnInsert()
    var
        ProcessChecklistTemplate: Record "Questionary Template";
        UserProfileMgt: Codeunit UserProfileManagement;
        BranchProfileSetup: Record "Branch Profile Setup";
    begin
        if "No." = '' then begin
            TestNoSeries;
            "No." := NoSeriesMgt.GetNextNo(GetNoSeriesCode(), 0D, true);
            "No. Series" := GetNoSeriesCode();
        end;
        "Process Date" := Today;

        if UserProfileMgt.CurrProfileID <> '' then
            if BranchProfileSetup.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                if BranchProfileSetup."Def. Service Location Code" <> '' then
                    Validate("Location Code", BranchProfileSetup."Def. Service Location Code");

        //15/03/2018 GH P1 >>
        Validate("Process Status", "process status"::Pending);
        GetUserSetup;
        //15/03/2018 GH P1 <<

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(Database::"Service Header EDMS", 0, "No.");    // 09/08/2018 EB.P30 GH
    end;

    var
        ProcessChecklistSetup: Record "Process Checklist Setup";
        ProcessChecklistHdr: Record "Process Checklist Header";
        NoSeriesMgt: Codeunit "No. Series";
        Text051: label 'Process checkilst %1 already exists.';
        Text010: label 'You cannot change %1 while lines exist.';
        ProcessChecklistTemplate: Record "Questionary Template";
        NotAllowedStatusErr: label 'New status of Trade-In document No. %1 is not allowed.';
        ChangeTemplateQst: label 'Do you want to change %1? All questionnaire lines will be recreated and data will be lost.';
        ChecklistLine: Record "Process Checklist Line";
        ArchiveManagement: Codeunit ArchiveManagement;


    procedure AssistEdit(OldProcessChecklistHdr: Record "Process Checklist Header"): Boolean
    var
        ProcessChecklistHdr2: Record "Process Checklist Header";
    begin
        ProcessChecklistHdr.Copy(Rec);
        ProcessChecklistSetup.Get;
        TestNoSeries;
        if NoSeriesMgt.LookupRelatedNoSeries(ProcessChecklistSetup."Process Checklist Nos.", OldProcessChecklistHdr."No. Series", ProcessChecklistHdr."No. Series") then begin
            ProcessChecklistHdr."No." := NoSeriesMgt.GetNextNo(ProcessChecklistHdr."No. Series", WorkDate(), true);
            if ProcessChecklistHdr2.Get(ProcessChecklistHdr."No.") then
                Error(Text051, ProcessChecklistHdr."No.");
            Rec := ProcessChecklistHdr;
            exit(true);
        end;
        // if NoSeriesMgt.SelectSeries(ProcessChecklistSetup."Process Checklist Nos.",
        //    OldProcessChecklistHdr."No. Series", ProcessChecklistHdr."No. Series") then begin
        //         NoSeriesMgt.SetSeries(ProcessChecklistHdr."No.");
        //         if ProcessChecklistHdr2.Get(ProcessChecklistHdr."No.") then
        //             Error(Text051, ProcessChecklistHdr."No.");
        //         Rec := ProcessChecklistHdr;
        //         exit(true);
        //     end;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        ProcessChecklistSetup.Get;
        ProcessChecklistSetup.TestField("Process Checklist Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        exit(ProcessChecklistSetup."Process Checklist Nos.");
    end;


    procedure ChangeStatus(NewStatus: Option " ",Released,Canceled)
    begin
        Status := xRec.Status;
        if NewStatus = Status then
            exit;

        if (NewStatus = Newstatus::" ") and IsInUse
        then
            Error(NotAllowedStatusErr, "No.");

        case NewStatus of
            Newstatus::Released:
                begin
                    TestField("Process Date");
                    TestField("Template Code");
                end;
            Newstatus::Canceled:
                begin
                end;
        end;

        Status := NewStatus;
        Modify;
    end;

    local procedure IsInUse(): Boolean
    var
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin

        exit(false);
    end;

    local procedure DeleteLines()
    begin
        ChecklistLine.Reset;
        ChecklistLine.SetRange("Process Checklist No.", "No.");
        ChecklistLine.DeleteAll(true);
    end;


    procedure CreateLines()
    var
        QstSubjGroup: Record "Questionary Templ. Subj. Group";
        SubjGroup: Record "Questionary Subject Group";
        SubjGroupQuestion: Record "Quest. Subj. Group Question";
        NextLineNo: Integer;
        LastItemLineNo: Integer;
    begin
        TestField(Status, Status::" ");
        TestField("Template Code");

        // 14/08/2018 EB.P30 GH >>
        if "No." = '' then
            InitRecord;
        // 14/08/2018 EB.P30 GH <<

        DeleteLines;
        NextLineNo := 1;

        QstSubjGroup.Reset;
        QstSubjGroup.SetCurrentkey("Questionary Template Code", "Sorting No.");
        QstSubjGroup.SetRange("Questionary Template Code", "Template Code");
        QstSubjGroup.FindFirst;
        repeat
            SubjGroup.Get(QstSubjGroup."Questionary Subject Group Code");
            ChecklistLine.Init;
            ChecklistLine."Process Checklist No." := "No.";
            ChecklistLine."Line No." := NextLineNo;
            NextLineNo += 1;
            ChecklistLine.Validate("Line Type", ChecklistLine."line type"::Group);
            ChecklistLine."Questionary Subject Group Code" := SubjGroup.Code;
            ChecklistLine."Question Text" := SubjGroup.Description;
            ChecklistLine.Insert;

            SubjGroupQuestion.Reset;
            SubjGroupQuestion.SetRange("Questionary Subject Group Code", SubjGroup.Code);
            SubjGroupQuestion.FindFirst;
            repeat
                ChecklistLine.Init;
                ChecklistLine."Process Checklist No." := "No.";
                ChecklistLine."Line No." := NextLineNo;
                NextLineNo += 1;
                ChecklistLine.Validate("Line Type", SubjGroupQuestion.Type);
                if ChecklistLine."Line Type" = ChecklistLine."line type"::Line then
                    LastItemLineNo := ChecklistLine."Line No.";
                if ChecklistLine."Line Type" = ChecklistLine."line type"::Control then
                    ChecklistLine."Parent Line No." := LastItemLineNo;
                ChecklistLine."Questionary Subject Group Code" := SubjGroup.Code;
                ChecklistLine."Question No." := SubjGroupQuestion."No.";
                ChecklistLine."Question Text" := SubjGroupQuestion."Question Text";
                ChecklistLine."Answer Type" := SubjGroupQuestion."Answer Type";
                ChecklistLine.SubType := SubjGroupQuestion.SubType;
                ChecklistLine."Control Color" := SubjGroupQuestion."Control Color";
                ChecklistLine."Control AssistEdit" := SubjGroupQuestion."Control AssistEdit";

                if SubjGroupQuestion."Default Value" <> '' then
                    ChecklistLine.Validate("Answer Text", SubjGroupQuestion."Default Value");
                ChecklistLine.Insert;
            until SubjGroupQuestion.Next = 0;
        until QstSubjGroup.Next = 0;
    end;


    procedure OnLookupVehicleRegistrationNo()
    var
        Vehicle: Record Vehicle;
        LookUpMgt: Codeunit LookUpManagement;
    begin
        if "Vehicle Registration No." <> '' then begin
            Vehicle.Reset;
            Vehicle.SetCurrentkey("Registration No.");
            Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
            if Vehicle.FindFirst then;
            Vehicle.SetRange("Registration No.");
        end;

        if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then begin
            Validate("Vehicle Serial No.", Vehicle."Serial No.");
            "Sell-to Customer No." := Vehicle."Customer No.";
        end;

    end;


    procedure VehicleDescription(): Text
    var
        Vehicle: Record Vehicle;
    begin
        if "Vehicle Serial No." = '' then
            exit('');
        Vehicle.Get("Vehicle Serial No.");
        exit(Vehicle."Make Code" + ' ' + Vehicle."Model Code");
    end;


    procedure ShowLines()
    begin
        TestField("No.");
        TestField("Template Code");
        Page.Run(Page::"Process Checklist List", Rec);
    end;


    procedure GetUserSetup()
    var
        UserSetup: Record "User Setup";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
        ServSetup: Record "Service Mgt. Setup EDMS";
        ServLocation: Code[20];
    begin
        ServSetup.Get;

        if UserProfileMgt.CurrProfileID <> '' then begin
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin //For Service Employees
                ServLocation := UserProfile."Def. Service Location Code";
                if ServLocation = '' then
                    ServLocation := ServSetup."Def. Service Location Code";
                if ServLocation <> '' then
                    Validate("Location Code", ServLocation);
            end;
        end else begin
            ServLocation := ServSetup."Def. Service Location Code";  //26.02.2013 EDMS P8
            if ServLocation <> '' then
                Validate("Location Code", ServLocation);
        end;
    end;

    local procedure InitRecord()
    begin
        TestNoSeries;
        "No. Series" := GetNoSeriesCode();
        "No." := NoSeriesMgt.GetNextNo("No. Series", 0D, true);
    end;
}

