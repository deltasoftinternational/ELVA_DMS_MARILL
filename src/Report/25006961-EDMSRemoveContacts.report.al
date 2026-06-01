report 25006961 "EDMS Remove Contacts"//5186
{
    Caption = 'Remove Contacts';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Segment Header"; "Segment Header")
        {
            DataItemTableView = SORTING("No.");
            dataitem("Segment Line"; "Segment Line")
            {
                DataItemLink = "Segment No." = FIELD("No.");
                DataItemTableView = SORTING("Segment No.", "Line No.");
                dataitem(Contact; Contact)
                {
                    DataItemTableView = SORTING("No.");
                    RequestFilterFields = "No.", "Search Name", Type, "Salesperson Code", "Post Code", "Country/Region Code", "Territory Code";
                    dataitem("Contact Profile Answer"; "Contact Profile Answer")
                    {
                        DataItemLink = "Contact No." = FIELD("No.");
                        RequestFilterHeading = 'Profile';

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break();
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                                ContactOK := false
                            else
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Contact Mailing Group"; "Contact Mailing Group")
                    {
                        DataItemLink = "Contact No." = FIELD("No.");
                        DataItemTableView = SORTING("Contact No.", "Mailing Group Code");
                        RequestFilterFields = "Mailing Group Code";
                        RequestFilterHeading = 'Mailing Group';

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break();
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                                ContactOK := false
                            else
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Interaction Log Entry"; "Interaction Log Entry")
                    {
                        DataItemLink = "Contact Company No." = FIELD("Company No."), "Contact No." = FIELD("No.");
                        DataItemTableView = SORTING("Contact Company No.", "Contact No.", Date);
                        RequestFilterFields = Date, "Segment No.", "Campaign No.", Evaluation, "Interaction Template Code", "Salesperson Code";

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break();
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                                ContactOK := false
                            else
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Contact Job Responsibility"; "Contact Job Responsibility")
                    {
                        DataItemLink = "Contact No." = FIELD("No.");
                        DataItemTableView = SORTING("Contact No.", "Job Responsibility Code");
                        RequestFilterFields = "Job Responsibility Code";
                        RequestFilterHeading = 'Job Responsibility';

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break();
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                                ContactOK := false
                            else
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Contact Industry Group"; "Contact Industry Group")
                    {
                        DataItemLink = "Contact No." = FIELD("Company No.");
                        DataItemTableView = SORTING("Contact No.", "Industry Group Code");
                        RequestFilterFields = "Industry Group Code";
                        RequestFilterHeading = 'Industry Group';

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            CurrReport.Break();
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and (GetFilters <> '') then
                                ContactOK := false
                            else
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Contact Business Relation"; "Contact Business Relation")
                    {
                        DataItemLink = "Contact No." = FIELD("Company No.");
                        DataItemTableView = SORTING("Contact No.", "Business Relation Code");
                        RequestFilterFields = "Business Relation Code";
                        RequestFilterHeading = 'Business Relation';
                        dataitem("Value Entry"; "Value Entry")
                        {
                            DataItemTableView = SORTING("Source Type", "Source No.", "Item No.", "Posting Date");
                            RequestFilterFields = "Item No.", "Variant Code", "Posting Date", "Inventory Posting Group";

                            trigger OnAfterGetRecord()
                            begin
                                ContactOK := true;
                                CurrReport.Break();
                            end;

                            trigger OnPreDataItem()
                            begin
                                if SkipItemLedgerEntry then
                                    CurrReport.Break();

                                case "Contact Business Relation"."Link to Table" of
                                    "Contact Business Relation"."Link to Table"::Customer:
                                        begin
                                            SetRange("Source Type", "Source Type"::Customer);
                                            SetRange("Source No.", "Contact Business Relation"."No.");
                                        end;
                                    "Contact Business Relation"."Link to Table"::Vendor:
                                        begin
                                            SetRange("Source Type", "Source Type"::Vendor);
                                            SetRange("Source No.", "Contact Business Relation"."No.");
                                        end
                                    else
                                        CurrReport.Break();
                                end;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            SkipItemLedgerEntry := false;
                            if not ItemFilters then begin
                                ContactOK := true;
                                SkipItemLedgerEntry := true;
                                CurrReport.Break();
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if ContactOK and ((GetFilters <> '') or ItemFilters) then
                                ContactOK := false
                            else
                                CurrReport.Break();
                        end;
                    }
                    dataitem("Vehicle Contact"; "Vehicle Contact")
                    {
                        DataItemLink = "Contact No." = field("No.");
                        DataItemTableView = sorting("Contact No.");
                        RequestFilterFields = "Relationship Code";
                        column(ReportForNavId_3985; 3985)
                        {
                        }
                        dataitem(Vehicle; Vehicle)
                        {
                            DataItemLink = "Serial No." = field("Vehicle Serial No.");
                            RequestFilterFields = "Make Code", "Model Code";
                            column(ReportForNavId_7543; 7543)
                            {
                            }
                            dataitem("Vehicle Service Plan"; "Vehicle Service Plan")
                            {
                                DataItemLink = "Vehicle Serial No." = field("Serial No.");
                                RequestFilterFields = "No.", "Service Plan Type", "Template Code";
                                column(ReportForNavId_8970; 8970)
                                {
                                }
                                dataitem("Vehicle Service Plan Stage"; "Vehicle Service Plan Stage")
                                {
                                    DataItemLink = "Vehicle Serial No." = field("Vehicle Serial No."), "Plan No." = field("No.");
                                    RequestFilterFields = "Expected Service Date", "Service Date", Status;
                                    column(ReportForNavId_1757; 1757)
                                    {
                                    }

                                    trigger OnAfterGetRecord()
                                    begin
                                        VehContactOK := true;
                                        ContactOK := true;
                                    end;

                                    trigger OnPreDataItem()
                                    begin
                                        if not VehicleServicePlanStageFilter then
                                            CurrReport.Break;
                                        VehContactOK := false;
                                    end;
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    VehContactOK := true;
                                    if not VehicleServicePlanStageFilter then begin
                                        ContactOK := true;
                                        CurrReport.Break;
                                    end;
                                end;

                                trigger OnPreDataItem()
                                begin
                                    if not VehicleServicePlanFilter and not VehicleServicePlanStageFilter then
                                        CurrReport.Break;
                                    VehContactOK := false;
                                end;
                            }
                            dataitem("Service Ledger Entry EDMS"; "Service Ledger Entry EDMS")
                            {
                                DataItemLink = "Vehicle Serial No." = field("Serial No.");
                                RequestFilterFields = "Entry Type", "Posting Date";
                                column(ReportForNavId_2609; 2609)
                                {
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    VehContactOK := true;
                                    ContactOK := true;
                                end;

                                trigger OnPreDataItem()
                                begin
                                    if not ServiceLedgerEntryFilter then
                                        CurrReport.Break;
                                    VehContactOK := false;
                                end;
                            }
                            dataitem("Recall Campaign Vehicle"; "Recall Campaign Vehicle")
                            {
                                DataItemLink = VIN = field(VIN);
                                RequestFilterFields = "Campaign No.", "Active Campaign", Serviced;
                                column(ReportForNavId_1; 1)
                                {
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    VehContactOK := true;
                                    ContactOK := true;
                                end;

                                trigger OnPreDataItem()
                                begin
                                    //17.07.2013 EDMS P8 >>
                                    if not VehicleRecallFilter then
                                        CurrReport.Break;
                                    VehContactOK := false;
                                    //17.07.2013 EDMS P8 <<
                                end;
                            }

                            trigger OnAfterGetRecord()
                            begin
                                VehContactOK := true;
                                if not VehicleServicePlanFilter and not VehicleServicePlanStageFilter and not ServiceLedgerEntryFilter and not VehicleRecallFilter then begin
                                    ContactOK := true;
                                    CurrReport.Break;
                                end;
                            end;

                            trigger OnPreDataItem()
                            begin
                                VehContactOK := false;
                            end;
                        }
                        dataitem(IntegerVehCont; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = const(1));
                            column(ReportForNavId_2; 2)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if VehContactOK then
                                    AddVehicleContactTmp("Vehicle Contact");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if not VehicleFilter and not VehicleServicePlanFilter and not VehicleServicePlanStageFilter
                              and not ServiceLedgerEntryFilter and not VehicleRecallFilter then begin
                                ContactOK := true;
                                VehContactOK := true;
                                CurrReport.Break;
                            end;
                            //17.07.2013 EDMS P8 >>
                            VehContactOK := true;
                            //17.07.2013 EDMS P8 <<
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (ContactOK and (GetFilters <> '')) or VehicleFilter or VehicleServicePlanFilter or VehicleServicePlanStageFilter
                              or ServiceLedgerEntryFilter or VehicleRecallFilter then begin
                                ContactOK := false;
                                VehContactOK := false;
                            end else begin
                                VehContactOK := true;
                                CurrReport.Break;
                            end;
                        end;
                    }
                    dataitem("Integer"; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

                        trigger OnAfterGetRecord()
                        begin
                            if ContactOK then
                                InsertContact(Contact);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if EntireCompanies then begin
                            if TempCheckCont.Get("No.") then
                                CurrReport.Skip();
                            TempCheckCont := Contact;
                            TempCheckCont.Insert();
                        end;

                        ContactOK := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        FilterGroup(4);
                        SetRange("Company No.", "Segment Line"."Contact Company No.");
                        if not EntireCompanies then
                            SetRange("No.", "Segment Line"."Contact No.");
                        FilterGroup(0);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    RecordNo := RecordNo + 1;
                    if RecordNo = 1 then begin
                        OldDateTime := CurrentDateTime;
                        case MainReportNo of
                            REPORT::"EDMS Remove Contacts - Reduce":
                                Window.Open(Text000);
                            REPORT::"EDMS Remove Contacts - Refine":
                                Window.Open(Text001);
                        end;
                        NoOfRecords := Count;
                    end;
                    NewDateTime := CurrentDateTime;
                    if (NewDateTime - OldDateTime > 100) or (NewDateTime < OldDateTime) then begin
                        NewProgress := Round(RecordNo / NoOfRecords * 100, 1);
                        if NewProgress <> OldProgress then begin
                            Window.Update(1, NewProgress * 100);
                            OldProgress := NewProgress;
                        end;
                        OldDateTime := CurrentDateTime;
                    end;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if EntireCompanies then
            AddPeople;

        UpdateSegLines;
    end;

    trigger OnPreReport()
    begin
        ItemFilters := "Value Entry".HasFilter;

        VehicleFilter := Vehicle.HasFilter;
        VehicleServicePlanFilter := "Vehicle Service Plan".HasFilter;
        VehicleServicePlanStageFilter := "Vehicle Service Plan Stage".HasFilter;
        ServiceLedgerEntryFilter := "Service Ledger Entry EDMS".HasFilter;
        VehicleRecallFilter := "Recall Campaign Vehicle".HasFilter;

        SegCriteriaManagement.InsertCriteriaAction(
          "Segment Header".GetFilter("No."), MainReportNo,
          false, false, false, false, EntireCompanies);
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), DATABASE::Contact,
          Contact.GetFilters, Contact.GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), DATABASE::"Contact Profile Answer",
          "Contact Profile Answer".GetFilters, "Contact Profile Answer".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), DATABASE::"Contact Mailing Group",
          "Contact Mailing Group".GetFilters, "Contact Mailing Group".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), DATABASE::"Interaction Log Entry",
          "Interaction Log Entry".GetFilters, "Interaction Log Entry".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), DATABASE::"Contact Job Responsibility", "Contact Job Responsibility".GetFilters,
          "Contact Job Responsibility".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), DATABASE::"Contact Industry Group",
          "Contact Industry Group".GetFilters, "Contact Industry Group".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), DATABASE::"Contact Business Relation",
          "Contact Business Relation".GetFilters, "Contact Business Relation".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), DATABASE::"Value Entry",
          "Value Entry".GetFilters, "Value Entry".GetView(false));

        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), Database::"Vehicle Contact",
          "Vehicle Contact".GetFilters, "Vehicle Contact".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), Database::Vehicle,
          Vehicle.GetFilters, Vehicle.GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), Database::"Vehicle Service Plan",
          "Vehicle Service Plan".GetFilters, "Vehicle Service Plan".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), Database::"Vehicle Service Plan Stage",
          "Vehicle Service Plan Stage".GetFilters, "Vehicle Service Plan Stage".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), Database::"Service Ledger Entry EDMS",
          "Service Ledger Entry EDMS".GetFilters, "Service Ledger Entry EDMS".GetView(false));
        SegCriteriaManagement.InsertCriteriaFilters(
          "Segment Header".GetFilter("No."), Database::"Recall Campaign Vehicle",
          "Recall Campaign Vehicle".GetFilters, "Recall Campaign Vehicle".GetView(false));

        VehicleContactTmp.Reset;
        VehicleContactTmp.DeleteAll;
    end;

    var
        Text000: Label 'Reducing Contacts @1@@@@@@@@@@@@@';
        Text001: Label 'Refining Contacts @1@@@@@@@@@@@@@';
        TempCont: Record Contact temporary;
        TempCont2: Record Contact temporary;
        TempCheckCont: Record Contact temporary;
        Cont: Record Contact;
        SegLine: Record "Segment Line";
        SegmentSubLine: Record "Segment SubLine";
        SegmentHistoryMgt: Codeunit SegHistoryManagement;
        SegCriteriaManagement: Codeunit SegCriteriaManagement;
        Window: Dialog;
        MainReportNo: Integer;
        ItemFilters: Boolean;
        ContactOK: Boolean;
        EntireCompanies: Boolean;
        SkipItemLedgerEntry: Boolean;
        NoOfRecords: Integer;
        RecordNo: Integer;
        OldDateTime: DateTime;
        NewDateTime: DateTime;
        OldProgress: Integer;
        NewProgress: Integer;
        VehicleFilter: Boolean;
        VehicleServicePlanFilter: Boolean;
        VehicleServicePlanStageFilter: Boolean;
        ServiceLedgerEntryFilter: Boolean;
        VehicleRecallFilter: Boolean;
        DetailedDeleteVehicle: Boolean;
        VehContactOK: Boolean;
        VehicleContactTmp: Record "Vehicle Contact" temporary;

    procedure SetOptions(CalledFromReportNo: Integer; OptionEntireCompanies: Boolean; DetailedDeleteVehiclePar: Boolean)
    begin
        MainReportNo := CalledFromReportNo;
        EntireCompanies := OptionEntireCompanies;
        DetailedDeleteVehicle := DetailedDeleteVehiclePar;
    end;

    local procedure InsertContact(var CheckedCont: Record Contact)
    begin
        TempCont := CheckedCont;
        if TempCont.Insert() then;
    end;

    local procedure AddPeople()
    begin
        TempCont.Reset();
        if TempCont.Find('-') then
            repeat
                if TempCont."Company No." <> '' then begin
                    Cont.SetCurrentKey("Company No.");
                    Cont.SetRange("Company No.", TempCont."Company No.");
                    if Cont.Find('-') then
                        repeat
                            TempCont2 := Cont;
                            if TempCont2.Insert() then;
                        until Cont.Next() = 0
                end else begin
                    TempCont2 := TempCont;
                    TempCont2.Insert();
                end;
            until TempCont.Next() = 0;

        TempCont.DeleteAll();
        if TempCont2.Find('-') then
            repeat
                TempCont := TempCont2;
                TempCont.Insert();
            until TempCont2.Next() = 0;
        TempCont2.DeleteAll();
    end;

    local procedure UpdateSegLines()
    begin
        SegLine.Reset();
        SegLine.SetRange("Segment No.", "Segment Header"."No.");
        if SegLine.Find('-') then
            repeat
                case MainReportNo of
                    Report::"EDMS Remove Contacts - Reduce":
                        begin
                            if TempCont.Get(SegLine."Contact No.") then begin
                                if DetailedDeleteVehicle then begin
                                    SegmentSubLine.Reset;
                                    SegmentSubLine.SetRange("Segment No.", SegLine."Segment No.");
                                    SegmentSubLine.SetRange("Line No.", SegLine."Line No.");
                                    if SegmentSubLine.FindFirst then
                                        repeat
                                            if VehicleContactTmp.Get(SegmentSubLine."Vehicle Serial No.", '', SegLine."Contact No.") then begin
                                                SegmentSubLine.Delete(true);
                                                if SegmentSubLine.Find('<') then;
                                            end;
                                        until SegmentSubLine.Next = 0;
                                    //delete line if no sublines
                                    if not SegmentSubLine.FindFirst then begin
                                        SegLine.Delete(true);
                                        SegmentHistoryMgt.DeleteLine(
                                          SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");
                                    end;
                                end else begin
                                    SegLine.Delete(true);
                                    SegmentHistoryMgt.DeleteLine(
                                      SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");
                                end;
                            end;
                        end;

                    Report::"EDMS Remove Contacts - Refine":
                        begin
                            if not TempCont.Get(SegLine."Contact No.") then begin
                                if DetailedDeleteVehicle then begin
                                    SegmentSubLine.Reset;
                                    SegmentSubLine.SetRange("Segment No.", SegLine."Segment No.");
                                    SegmentSubLine.SetRange("Line No.", SegLine."Line No.");
                                    if SegmentSubLine.FindFirst then
                                        repeat
                                            if not VehicleContactTmp.Get(SegmentSubLine."Vehicle Serial No.", '', SegLine."Contact No.") then begin
                                                SegmentSubLine.Delete(true);
                                                if SegmentSubLine.Find('<') then;
                                            end;
                                        until SegmentSubLine.Next = 0;
                                    //delete line if no sublines
                                    if not SegmentSubLine.FindFirst then begin
                                        SegLine.Delete(true);
                                        SegmentHistoryMgt.DeleteLine(
                                          SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");
                                    end;
                                end else begin
                                    SegLine.Delete(true);
                                    SegmentHistoryMgt.DeleteLine(
                                      SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");
                                end;
                            end;
                        end;
                end;
            until SegLine.Next() = 0;
    end;

    procedure AddVehicleContactTmp(VehicleContactPar: Record "Vehicle Contact")
    begin
        if not VehicleContactTmp.Get(VehicleContactPar."Vehicle Serial No.", '', VehicleContactPar."Contact No.") then begin
            VehicleContactTmp.TransferFields(VehicleContactPar);
            VehicleContactTmp."Relationship Code" := '';
            VehicleContactTmp.Insert;
        end;
    end;
}

