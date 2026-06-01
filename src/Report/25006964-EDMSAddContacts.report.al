report 25006964 "EDMS Add Contacts"//5198
{
    // 10.08.2018 EDMS
    //   * Corrected filters when adding Vehicle related contacts
    // 
    // 17.07.2013 EDMS P8
    //   * Added ExpandVehicles
    // 
    // 17.10.2012 EDMS P8
    //         * Added request page

    Caption = 'Add Contacts';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Segment Header"; "Segment Header")
        {
            DataItemTableView = SORTING("No.");
        }
        dataitem(Contact; Contact)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Name", Type, "Salesperson Code", "Post Code", "Country/Region Code", "Territory Code";
            dataitem("Contact Profile Answer"; "Contact Profile Answer")
            {
                DataItemLink = "Contact No." = FIELD("No.");
                DataItemTableView = SORTING("Contact No.", "Profile Questionnaire Code", "Line No.");
                RequestFilterFields = "Profile Questionnaire Code", "Line No.";

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
                dataitem("Value Entry"; "Value Entry")
                {
                    DataItemTableView = SORTING("Source Type", "Source No.", "Item No.", "Posting Date");
                    RequestFilterFields = "Item No.", "Variant Code", "Posting Date", "Inventory Posting Group";

                    trigger OnAfterGetRecord()
                    begin
                        if Contact.Type = Contact.Type::Person then
                            ContactOK := FindContInPostDocuments(Contact."No.", "Value Entry")
                        else
                            ContactOK := true;

                        if ContactOK then
                            CurrReport.Break();
                    end;

                    trigger OnPreDataItem()
                    begin
                        if SkipItemLedgerEntry then
                            CurrReport.Break();

                        case "Contact Business Relation"."Link to Table" of
                            "Contact Business Relation"."Link to Table"::Customer:
                                begin
                                    SetRange("Item Ledger Entry Type", "item ledger entry type"::Sale);
                                    SetRange("Source Type", "Source Type"::Customer);
                                    SetRange("Source No.", "Contact Business Relation"."No.");
                                end;
                            "Contact Business Relation"."Link to Table"::Vendor:
                                begin
                                    SetRange("Item Ledger Entry Type", "item ledger entry type"::Purchase);
                                    SetRange("Source Type", "Source Type"::Vendor);
                                    SetRange("Source No.", "Contact Business Relation"."No.");
                                end
                            else
                                CurrReport.Break();
                        end;
                    end;
                }
                dataitem("Sales Invoice Line"; "Sales Invoice Line")
                {
                    RequestFilterFields = "Line Type", "Order Line Type No.";
                    column(ReportForNavId_1570; 1570)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ContactOK := true;
                        CurrReport.Break;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if SkipInvoiceLineEntry then
                            CurrReport.Break;

                        case "Contact Business Relation"."Link to Table" of
                            "Contact Business Relation"."link to table"::Customer:
                                begin
                                    SetRange("Sell-to Customer No.", "Contact Business Relation"."No.");
                                end else
                                        CurrReport.Break;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    SkipItemLedgerEntry := false;

                    SkipInvoiceLineEntry := false;

                    if not ItemFilters then
                        SkipItemLedgerEntry := true;

                    if not InvoiceLineFilter then
                        SkipInvoiceLineEntry := true;

                    //IF NOT ItemFilters THEN BEGIN
                    if not (ItemFilters or InvoiceLineFilter) then begin
                        ContactOK := true;
                        SkipItemLedgerEntry := true;
                        CurrReport.Break();
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    //IF ContactOK AND ((GETFILTERS <> '') OR ItemFilters) THEN
                    if ContactOK and ((GetFilters <> '') or ItemFilters or InvoiceLineFilter) then
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
                                ContactOK := true;
                                VehContactOK := true;
                                if VehicleServicePlanStageFilter then begin
                                    CurrReport.Break;
                                end;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not VehicleServicePlanStageFilter then
                                    CurrReport.Break;
                                ContactOK := false;
                                VehContactOK := false;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            ContactOK := true;
                            VehContactOK := true;
                            if not VehicleServicePlanStageFilter then begin
                                CurrReport.Break;
                            end;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not VehicleServicePlanFilter and not VehicleServicePlanStageFilter then begin
                                CurrReport.Break;
                            end else begin
                                ContactOK := false;
                                VehContactOK := false;
                            end;
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
                            ContactOK := false;
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
                            /*
                            VehContactOK := TRUE;
                            ContactOK := TRUE;
                            */
                            if VehicleRecallFilter then begin
                                ContactOK := true;
                                CurrReport.Break;
                            end;

                        end;

                        trigger OnPreDataItem()
                        begin
                            //17.07.2013 EDMS P8 >>
                            if not VehicleRecallFilter then
                                CurrReport.Break;
                            ContactOK := false;
                            VehContactOK := false;
                            //17.07.2013 EDMS P8 <<
                            /*
                            IF ContactOK AND VehicleRecallFilter THEN
                              ContactOK := FALSE
                            ELSE
                              CurrReport.BREAK;
                            */

                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ContactOK := true;
                        VehContactOK := true;
                        if not VehicleServicePlanFilter and not VehicleServicePlanStageFilter and not ServiceLedgerEntryFilter and not VehicleRecallFilter then begin
                            CurrReport.Break;
                        end;
                    end;

                    trigger OnPreDataItem()
                    var
                        ContBussRelation: Record "Contact Business Relation";
                    begin
                        if VehicleFilter or VehicleServicePlanFilter or VehicleServicePlanStageFilter
                          or ServiceLedgerEntryFilter or VehicleRecallFilter then begin
                            ContactOK := false;
                            VehContactOK := false;
                        end;

                        /*IF (ContactOK AND (GETFILTERS<>'')) OR VehicleServicePlanFilter OR VehicleServicePlanStageFilter
                          OR ServiceLedgerEntryFilter OR VehicleRecallFilter THEN BEGIN
                          ContactOK := FALSE;
                          VehContactOK := FALSE;
                        END ELSE BEGIN
                          VehContactOK := TRUE;
                          CurrReport.BREAK;
                        END;
                        */

                    end;
                }
                dataitem(IntegerVehCont; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(ReportForNavId_3; 3)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if VehContactOK then begin
                            AddVehicleContactTmp("Vehicle Contact");
                            ContactVehicleInserted := true;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    ContactOK := true;
                    VehContactOK := true;
                    if not VehicleFilter and not VehicleServicePlanFilter and not VehicleServicePlanStageFilter
                      and not ServiceLedgerEntryFilter and not VehicleRecallFilter and not FillSublines then begin
                        CurrReport.Break;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    //IF ContactOK AND VehicleFilter THEN
                    if (ContactOK and (GetFilters <> '')) or VehicleFilter or VehicleServicePlanFilter or VehicleServicePlanStageFilter
                      or ServiceLedgerEntryFilter or VehicleRecallFilter or FillSublines then begin
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
                    //IF ContactOK THEN
                    if ContactOK or ContactVehicleInserted then
                        InsertContact(Contact);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RecordNo := RecordNo + 1;
                if RecordNo = 1 then begin
                    Window.Open(Text000);
                    NoOfRecords := Count;
                    OldDateTime := CurrentDateTime;
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

                ContactOK := true;
                ContactVehicleInserted := false;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AllowExistingContact; AllowExistingContact)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Allow Existing Contacts';
                        ToolTip = 'Specifies if existing contacts are included in the segment.';
                    }
                    field(ExpandCompanies; ExpandCompanies)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Expand Companies';
                        ToolTip = 'Specifies if you want the segment to include all person contacts who are working for the company that you want to add to the segment.';
                    }
                    field(AllowRelatedCompaines; AllowCoRepdByContPerson)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Allow Related Companies';
                        Importance = Additional;
                        MultiLine = true;
                        ToolTip = 'Specifies if companies represented by person contacts are included in the segment.';
                    }
                    field(IgnoreExclusion; IgnoreExclusion)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Ignore Exclusion';
                        Importance = Additional;
                        ToolTip = 'Specifies if contacts are excluded for which the Exclude from Segment field has been selected on the contact card.';
                    }
                    group(VehicleInfo)
                    {
                        Caption = 'Vehicle Info';
                        field(FillSublines; FillSublines)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Add Vehicle Info';

                            trigger OnValidate()
                            begin
                                if not FillSublines then
                                    ExpandVehicles := false;
                            end;
                        }
                        field(ExpandVehicles; ExpandVehicles)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Contact Line per Vehicle';
                            Enabled = FillSublines;
                        }
                    }
                }
            }
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
        if ExpandCompanies then
            AddPeople;
        if AllowCoRepdByContPerson then
            AddCompanies;

        OnPostReportOnBeforeUpdateSegLines("Segment Header");

        UpdateSegLines;
    end;

    trigger OnPreReport()
    begin
        ItemFilters := "Value Entry".HasFilter;

        InvoiceLineFilter := "Sales Invoice Line".HasFilter;
        VehicleFilter := Vehicle.HasFilter;
        VehicleContactFilter := "Vehicle Contact".HasFilter;
        VehicleServicePlanFilter := "Vehicle Service Plan".HasFilter;
        VehicleServicePlanStageFilter := "Vehicle Service Plan Stage".HasFilter;
        ServiceLedgerEntryFilter := "Service Ledger Entry EDMS".HasFilter;
        VehicleRecallFilter := "Recall Campaign Vehicle".HasFilter;

        SegCriteriaManagement.InsertCriteriaAction(
          "Segment Header".GetFilter("No."), REPORT::"EDMS Add Contacts",
          AllowExistingContact, ExpandCompanies, AllowCoRepdByContPerson, IgnoreExclusion, false);
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
          "Segment Header".GetFilter("No."), Database::"Sales Invoice Line",
          "Sales Invoice Line".GetFilters, "Sales Invoice Line".GetView(false));
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
        Text000: Label 'Inserting contacts @1@@@@@@@@@@@@@';
        TempCont: Record Contact temporary;
        TempCont2: Record Contact temporary;
        Cont: Record Contact;
        SegLine: Record "Segment Line";
        SegmentHistoryMgt: Codeunit SegHistoryManagement;
        SegCriteriaManagement: Codeunit SegCriteriaManagement;
        Window: Dialog;
        NextLineNo: Integer;
        ItemFilters: Boolean;
        ContactOK: Boolean;
        AllowExistingContact: Boolean;
        ExpandCompanies: Boolean;
        AllowCoRepdByContPerson: Boolean;
        IgnoreExclusion: Boolean;
        SkipItemLedgerEntry: Boolean;
        NoOfRecords: Integer;
        RecordNo: Integer;
        OldDateTime: DateTime;
        NewDateTime: DateTime;
        OldProgress: Integer;
        NewProgress: Integer;
        RecallServiceFilter: Boolean;
        SkipServicePackage: Boolean;
        InvoiceLineFilter: Boolean;
        SkipInvoiceLineEntry: Boolean;
        VehicleFilter: Boolean;
        VehicleContactFilter: Boolean;
        VehicleServicePlanFilter: Boolean;
        VehicleServicePlanStageFilter: Boolean;
        ServiceLedgerEntryFilter: Boolean;
        VehicleRecallFilter: Boolean;
        ExpandVehicles: Boolean;
        [InDataSet]
        FillSublines: Boolean;
        VehContactOK: Boolean;
        VehicleContactTmp: Record "Vehicle Contact" temporary;
        ContactVehicleInserted: Boolean;

    procedure SetOptions(OptionAllowExistingContact: Boolean; OptionExpandCompanies: Boolean; OptionAllowCoRepdByContPerson: Boolean; OptionIgnoreExclusion: Boolean)
    begin
        AllowExistingContact := OptionAllowExistingContact;
        ExpandCompanies := OptionExpandCompanies;
        AllowCoRepdByContPerson := OptionAllowCoRepdByContPerson;
        IgnoreExclusion := OptionIgnoreExclusion;
    end;

    local procedure InsertContact(var CheckedCont: Record Contact)
    begin
        TempCont := CheckedCont;
        if TempCont.Insert() then;
    end;

    local procedure AddCompanies()
    begin
        TempCont.Reset();
        if TempCont.Find('-') then
            repeat
                TempCont2 := TempCont;
                if TempCont2.Insert() then;
                if TempCont."Company No." <> '' then begin
                    Cont.Get(TempCont."Company No.");
                    TempCont2 := Cont;
                    if TempCont2.Insert() then;
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
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateSegLines("Segment Header", IsHandled);
        if IsHandled then
            exit;
        /*
        SegLine.SetRange("Segment No.","Segment Header"."No.");
        IF SegLine.FINDLAST THEN
            NextLineNo := SegLine."Line No." + 10000
        ELSE
            NextLineNo := 10000;
        
        TempCont.Reset();
        TempCont.SetCurrentkey("Company Name","Company No.",Type,Name);
        IF NOT IgnoreExclusion THEN
          TempCont.SetRange("Exclude from Segment",false);
        IF TempCont.FIND('-') THEN
          repeat
            ContactOK := true;
            if not AllowExistingContact then begin
              SegLine.SetCurrentkey("Contact No.","Segment No.");
              SegLine.SetRange("Contact No.",TempCont."No.");
              SegLine.SetRange("Segment No.","Segment Header"."No.");
              if SegLine.FindFirst then
                ContactOK := false;
            end;
        
                OnBeforeInsertSegmentLine(
                  TempCont, AllowExistingContact, ExpandCompanies, AllowCoRepdByContPerson, IgnoreExclusion, ContactOK);
        
            if ContactOK then begin
                    SegLine.Init();
                    SegLine."Line No." := NextLineNo;
              SegLine.Validate("Segment No.","Segment Header"."No.");
              SegLine.Validate("Contact No.",TempCont."No.");
              SegLine.Insert(true);
                    SegmentHistoryMgt.InsertLine(
                      SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");
                    NextLineNo := SegLine."Line No." + 10000;
            end;
            until TempCont.Next() = 0;
          */

        TempCont.Reset;
        TempCont.SetCurrentkey("Company Name", "Company No.", Type, Name);
        if not IgnoreExclusion then
            TempCont.SetRange("Exclude from Segment", false);
        if TempCont.Find('-') then
            repeat
                SegLine.Reset;
                ContactOK := true;
                if not AllowExistingContact then begin
                    SegLine.SetCurrentkey("Contact No.", "Segment No.");
                    SegLine.SetRange("Contact No.", TempCont."No.");
                    SegLine.SetRange("Segment No.", "Segment Header"."No.");
                    if SegLine.Find('-') then
                        ContactOK := false;
                end;

                if ContactOK then begin
                    SegLine.Init;
                    SegLine.Validate("Segment No.", "Segment Header"."No.");
                    SegLine.Validate("Contact No.", TempCont."No.");
                    SegLine."Line No." := GetNextSegmentLineNo(SegLine."Segment No.");
                    ;
                    SegLine.Insert(true);
                    SegmentHistoryMgt.InsertLine(
                      SegLine."Segment No.", SegLine."Contact No.", SegLine."Line No.");
                end;
                if FillSublines then
                    AddVehicles(SegLine);
            until TempCont.Next = 0;

    end;

    local procedure FindContInPostDocuments(ContactNo: Code[20]; ValueEntry: Record "Value Entry"): Boolean
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        ReturnShptHeader: Record "Return Shipment Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
    begin
        case ValueEntry."Source Type" of
            ValueEntry."Source Type"::Customer:
                begin
                    if SalesInvHeader.ReadPermission then
                        if SalesInvHeader.Get(ValueEntry."Document No.") then
                            if (SalesInvHeader."Sell-to Contact No." = ContactNo) or
                               (SalesInvHeader."Bill-to Contact No." = ContactNo)
                            then
                                exit(true);
                    if SalesShptHeader.ReadPermission then
                        if SalesShptHeader.Get(ValueEntry."Document No.") then
                            if (SalesShptHeader."Sell-to Contact No." = ContactNo) or
                               (SalesShptHeader."Bill-to Contact No." = ContactNo)
                            then
                                exit(true);
                    if SalesCrMemoHeader.ReadPermission then
                        if SalesCrMemoHeader.Get(ValueEntry."Document No.") then
                            if (SalesCrMemoHeader."Sell-to Contact No." = ContactNo) or
                               (SalesCrMemoHeader."Bill-to Contact No." = ContactNo)
                            then
                                exit(true);
                    if ReturnRcptHeader.ReadPermission then
                        if ReturnRcptHeader.Get(ValueEntry."Document No.") then
                            if (ReturnRcptHeader."Sell-to Contact No." = ContactNo) or
                               (ReturnRcptHeader."Bill-to Contact No." = ContactNo)
                            then
                                exit(true);
                end;
            ValueEntry."Source Type"::Vendor:
                begin
                    if PurchInvHeader.ReadPermission then
                        if PurchInvHeader.Get(ValueEntry."Document No.") then
                            if (PurchInvHeader."Buy-from Contact No." = ContactNo) or
                               (PurchInvHeader."Pay-to Contact No." = ContactNo)
                            then
                                exit(true);
                    if ReturnShptHeader.ReadPermission then
                        if ReturnShptHeader.Get(ValueEntry."Document No.") then
                            if (ReturnShptHeader."Buy-from Contact No." = ContactNo) or
                               (ReturnShptHeader."Pay-to Contact No." = ContactNo)
                            then
                                exit(true);
                    if PurchCrMemoHeader.ReadPermission then
                        if PurchCrMemoHeader.Get(ValueEntry."Document No.") then
                            if (PurchCrMemoHeader."Buy-from Contact No." = ContactNo) or
                               (PurchCrMemoHeader."Pay-to Contact No." = ContactNo)
                            then
                                exit(true);
                    if PurchRcptHeader.ReadPermission then
                        if PurchRcptHeader.Get(ValueEntry."Document No.") then
                            if (PurchRcptHeader."Buy-from Contact No." = ContactNo) or
                               (PurchRcptHeader."Pay-to Contact no." = ContactNo)
                            then
                                exit(true);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSegmentLine(var TempContact: Record Contact temporary; AllowExistingContact: Boolean; ExpandCompanies: Boolean; AllowCoRepdByContPerson: Boolean; IgnoreExclusion: Boolean; var ContactOK: Boolean)
    begin
    end;

    procedure AddVehicles(var SegmentLinePar: Record "Segment Line")
    var
        ContactL: Record Contact;
        SegmentSubLineL: Record "Segment SubLine";
    begin
        if ContactL.Get(SegmentLinePar."Contact No.") then begin
            VehicleContactTmp.Reset;
            VehicleContactTmp.SetRange(VehicleContactTmp."Contact No.", SegmentLinePar."Contact No.");
            if VehicleContactTmp.FindFirst then
                //  "Vehicle Contact".RESET;
                //  "Vehicle Contact".SETRANGE("Vehicle Contact"."Contact No.", "Contact No.");
                //  IF "Vehicle Contact".FINDFIRST THEN

                repeat
                    if ExpandVehicles then begin
                        SegmentLinePar.CalcFields("Vehicles Count");
                        if SegmentLinePar."Vehicles Count" > 0 then begin
                            if AllowExistingContact then begin
                                SegmentLinePar."Line No." := GetNextSegmentLineNo(SegmentLinePar."Segment No.");
                                SegmentLinePar.Insert(true);
                            end else begin
                                SegmentSubLineL.Reset;
                                SegmentSubLineL.SetRange("Segment No.", SegmentLinePar."Segment No.");
                                SegmentSubLineL.SetRange("Line No.", SegmentLinePar."Line No.");
                                SegmentSubLineL.SetRange("Vehicle Serial No.", VehicleContactTmp."Vehicle Serial No.");
                                if not SegmentSubLineL.FindFirst then begin
                                    SegmentLinePar."Line No." := GetNextSegmentLineNo(SegmentLinePar."Segment No.");
                                    SegmentLinePar.Insert(true);
                                end;
                            end;
                        end;
                    end;
                    if AllowExistingContact then begin
                        SegmentLinePar.VehicleAddToSublines(VehicleContactTmp."Vehicle Serial No.", 0)
                    end else begin
                        SegmentSubLineL.Reset;
                        SegmentSubLineL.SetRange("Segment No.", SegmentLinePar."Segment No.");
                        SegmentSubLineL.SetRange("Line No.", SegmentLinePar."Line No.");
                        SegmentSubLineL.SetRange("Vehicle Serial No.", VehicleContactTmp."Vehicle Serial No.");
                        if not SegmentSubLineL.FindFirst then begin
                            SegmentLinePar.VehicleAddToSublines(VehicleContactTmp."Vehicle Serial No.", 0)
                        end;
                    end;

                until VehicleContactTmp.Next = 0;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateSegLines(var SegmentHeader: Record "Segment Header"; var IsHandled: Boolean)
    begin
    end;

    procedure AddVehicleContactTmp(VehicleContactPar: Record "Vehicle Contact")
    begin
        if not VehicleContactTmp.Get(VehicleContactPar."Vehicle Serial No.", '', VehicleContactPar."Contact No.") then begin
            VehicleContactTmp.TransferFields(VehicleContactPar);
            VehicleContactTmp."Relationship Code" := '';
            VehicleContactTmp.Insert;
        end;
    end;

    procedure GetNextSegmentLineNo(HeaderNo: Code[20]) RetValue: Integer
    var
        SegmentLineL: Record "Segment Line";
    begin
        SegmentLineL.SetRange("Segment No.", HeaderNo);
        if SegmentLineL.FindLast then
            RetValue := SegmentLineL."Line No." + 10000
        else
            RetValue := 10000;
        exit(RetValue);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostReportOnBeforeUpdateSegLines(var SegmentHeader: Record "Segment Header")
    begin
    end;
}

