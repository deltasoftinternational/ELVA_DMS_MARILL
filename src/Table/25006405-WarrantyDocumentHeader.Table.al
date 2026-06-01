Table 25006405 "Warranty Document Header"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added Fields:
    //     51200 Total Amount
    //     51201 Total Adjusted
    //     51202 Total Approved
    //     51203 Total Rejected
    //     51240 Initial Service Order No.
    //     52001 Unplanned Stop
    //     52002 Item Repair Status
    //     52004 Causal Item Serial No.
    //     52005 Causal Part Serial No.
    //     52011 Parts Fitted Date
    //     52012 Parts Operation Hours
    //     52016 Repair Date
    //     52110 Recall Campaign External No.
    // 
    //   Modified Fields:
    //     170 Recal Campaign Code

    Caption = 'Warranty Document Header';
    DrillDownPageID = "Warranty Document List";
    LookupPageID = "Warranty Document List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(20; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(30; "Service Order Sequence No."; Integer)
        {
            Caption = 'Service Order Sequence No.';
        }
        field(40; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record Vehicle;
            begin
                // 23.04.2015 EDMS P21 >>
                // IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                OnLookupVIN;
                // 23.04.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);

                // 20.02.2015 EDMS P21 >>
                if VIN = '' then begin
                    Validate("Vehicle Serial No.", '');
                    exit;
                end;

                Vehicle.Reset;
                Vehicle.SetCurrentkey(VIN);
                Vehicle.SetRange(VIN, VIN);
                if Vehicle.FindFirst then begin
                    if "Vehicle Serial No." <> Vehicle."Serial No." then
                        Validate("Vehicle Serial No.", Vehicle."Serial No.")
                end else begin
                    MessageLoc(StrSubstNo(Text137, Vehicle.TableCaption, FieldCaption(VIN), VIN), '');
                    //IF "Document Type" <> "Document Type"::Quote THEN
                    VIN := xRec.VIN;
                end;
                // 20.02.2015 EDMS P21 <<
            end;
        }
        field(50; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                if "Vehicle Registration No." = '' then begin
                    Validate("Vehicle Serial No.", '');
                    exit;
                end;

                Vehicle.Reset;
                Vehicle.SetCurrentkey("Registration No.");
                Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
                if Vehicle.FindFirst then begin
                    if "Vehicle Serial No." <> Vehicle."Serial No." then
                        Validate("Vehicle Serial No.", Vehicle."Serial No.")
                end else begin
                    MessageLoc(StrSubstNo(Text131, "Vehicle Registration No."), '');
                    // 20.02.2015 EDMS P21 >>
                    //IF "Document Type" <> "Document Type"::Quote THEN
                    "Vehicle Registration No." := xRec."Vehicle Registration No.";
                    // 20.02.2015 EDMS P21 <<
                end;
            end;
        }
        field(60; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                Model: Record Model;
                DocumentMgt: Codeunit DocumentManagementDMS;
                FillCustomer: Boolean;
            begin
                if "Vehicle Serial No." = '' then begin
                    "Vehicle Registration No." := '';
                    "Make Code" := '';
                    "Model Code" := '';
                    "Model Version No." := '';                                // 20.02.2015 EDMS P21
                    VIN := '';
                    "Vehicle Accounting Cycle No." := '';
                    "Vehicle Status Code" := '';
                    "Model Commercial Name" := '';
                    //VALIDATE("Contract No.", '');                             // 15.04.2014 Elva Baltic P21
                    exit;
                end;

                Vehicle.Get("Vehicle Serial No.");
                Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                Vehicle.TestField(Blocked, false);  //08.05.2014 Elva Baltic P8 #S0084 MMG7.00


                VIN := Vehicle.VIN;
                Validate("Vehicle Accounting Cycle No.", Vehicle."Default Vehicle Acc. Cycle No.");
                "Vehicle Registration No." := Vehicle."Registration No.";
                "Make Code" := Vehicle."Make Code";
                "Model Code" := Vehicle."Model Code";
                "Model Version No." := Vehicle."Model Version No.";         // 20.02.2015 EDMS P21
                "Vehicle Status Code" := Vehicle."Status Code";

                if Model.Get("Make Code", "Model Code") then
                    "Model Commercial Name" := Model."Commercial Name"
                else
                    "Model Commercial Name" := Vehicle."Model Commercial Name";


                //IF (Rec."Sell-to Customer No." = xRec."Sell-to Customer No.") AND NOT FindVehicle THEN
                //  FindVehicleCont;

                //UpdateVehicleContact;

                DocumentMgt.ShowVehicleComments("Vehicle Serial No.");

                CheckRecallCampaigns("Vehicle Serial No.");

                //29.09.2011 EDMS P8 >>
                //IF ("Vehicle Serial No." <> xRec."Vehicle Serial No.") AND (xRec."Vehicle Serial No." <> '') THEN
                //  TireManagement.ChangeVehicleInServiceHeader(Rec, xRec."Vehicle Serial No.", "Vehicle Serial No.");
                //29.09.2011 EDMS P8 <<

                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 >>
                //CreateDim(
                //  DATABASE::"Vehicle Status", "Vehicle Status Code",
                //  DATABASE::Customer,"Bill-to Customer No.",
                //  DATABASE::"Salesperson/Purchaser","Service Advisor",
                //  DATABASE::"Responsibility Center","Responsibility Center",
                //  DATABASE::"Deal Type","Deal Type",
                //  DATABASE::Make,"Make Code",
                //  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                //  DATABASE::"Payment Method","Payment Method Code",
                //  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                //  );
                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 <<

                //IF xRec."Vehicle Serial No." <> "Vehicle Serial No." THEN BEGIN               // 15.04.2014 Elva Baltic P21
                //  FindContract;                                                               // 15.04.2014 Elva Baltic P21
                //  SetHideValidationDialog(FALSE);                                             // 23.04.2015 EDMS P21
                //  RecreateDmsServLines(FIELDCAPTION("Vehicle Serial No."));                   // 16.03.2015 EDMS P21
                //END;
            end;
        }
        field(70; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(75; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recDimValue: Record "Dimension Value";
            begin
                //CreateDim(
                //  DATABASE::"Vehicle Status", "Vehicle Status Code",
                //  DATABASE::Customer,"Bill-to Customer No.",
                //  DATABASE::"Salesperson/Purchaser","Service Advisor",
                //  DATABASE::"Responsibility Center","Responsibility Center",
                //  DATABASE::"Deal Type","Deal Type",
                //  //DATABASE::Vehicle,VIN,
                //  DATABASE::Make,"Make Code",
                //  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                //  DATABASE::"Payment Method","Payment Method Code",
                //  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                //  );

                //04.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                //RecreateDmsServLines(FIELDCAPTION("Vehicle Status Code"));
                //04.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(80; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);

                // 16.03.2015 EDMS P21 >>
                if ("Make Code" <> xRec."Make Code") and ("Model Code" <> '') then
                    Validate("Model Code", '');
                // 16.03.2015 EDMS P21 <<
            end;
        }
        field(81; "External Claim No."; Code[20])
        {
            Caption = 'External Claim No.';
        }
        field(90; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(100; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));

            trigger OnLookup()
            var
                Item: Record Item;
            begin
                // 20.02.2015 EDMS P21 >>
                if LookUpMgt.LookUpModelVersion(Item, "Model Version No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", Item."No.");
                // 20.02.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(110; "Model Commercial Name"; Text[50])
        {
            CalcFormula = lookup(Model."Commercial Name" where("Make Code" = field("Make Code"),
                                                                Code = field("Model Code")));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Variable Field Run 1"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006180';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                TestVFRun1;
                CheckServicePlan(FieldNo("Variable Field Run 1"));
            end;
        }
        field(130; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006255';

            trigger OnValidate()
            begin
                TestVFRun2;
                CheckServicePlan(FieldNo("Variable Field Run 2"));
            end;
        }
        field(140; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006260';

            trigger OnValidate()
            begin
                TestVFRun3;
                CheckServicePlan(FieldNo("Variable Field Run 3"));
            end;
        }
        field(150; "Claim Job Type"; Code[20])
        {
            Caption = 'Claim Job Type';
            TableRelation = "Claim Job Type";
        }
        field(160; "Symptom Code"; Code[20])
        {
            Caption = 'Symptom Code';
            TableRelation = "Symptom Code EDMS".Code where("Make Code" = field("Make Code"));
        }
        field(170; "Recal Campaign Code"; Code[20])
        {
            Caption = 'Recal Campaign';
            TableRelation = "Recall Campaign";

            trigger OnValidate()
            var
                RecallCampaign: Record "Recall Campaign";
            begin
                if RecallCampaign.Get("Recal Campaign Code") then begin
                    "Causal Item No." := RecallCampaign."Causal Part No.";
                    "Symptom Code" := RecallCampaign."Symptom Code";
                    "Recall Campaign External No." := RecallCampaign."External No.";
                end;
            end;
        }
        field(180; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if CurrFieldNo <> FieldNo("Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        //RecreateDmsServLines(FIELDCAPTION("Currency Code"));
                    end
                    else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(185; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                //IF "Currency Factor" <> xRec."Currency Factor" THEN
                //UpdateDMSServLines(FIELDCAPTION("Currency Factor"),FALSE);
            end;
        }
        field(190; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(200; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(210; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                NoSeries: Record "No. Series";
            begin
                /*
                TestNoSeriesDate(
                  "Posting No.","Posting No. Series",
                  FIELDCAPTION("Posting No."),FIELDCAPTION("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.","Prepayment No. Series",
                  FIELDCAPTION("Prepayment No."),FIELDCAPTION("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.","Prepmt. Cr. Memo No. Series",
                  FIELDCAPTION("Prepmt. Cr. Memo No."),FIELDCAPTION("Prepmt. Cr. Memo No. Series"));
                
                VALIDATE("Document Date","Posting Date");
                
                IF ("Document Type" IN ["Document Type"::"Return Order","Document Type"::Booking]) AND NOT ("Posting Date" = xRec."Posting Date")
                THEN
                 PriceMessageIfServLinesExist(FIELDCAPTION("Posting Date"));
                
                IF "Currency Code" <> '' THEN
                 BEGIN
                  UpdateCurrencyFactor;
                  IF "Currency Factor" <> xRec."Currency Factor" THEN
                   ConfirmUpdateCurrencyFactor;
                 END;
                */

            end;
        }
        field(220; "Document Date"; Date)
        {
        }
        field(230; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                Currency: Record Currency;
                RecalculatePrice: Boolean;
                SalesHeader: Record "Sales Header";
                ServLine: Record "Service Line EDMS";
                ServLineCopy: Record "Service Line EDMS";
            begin
                /*
                TESTFIELD(Status,Status::Open);
                
                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                
                 SalesHeader.RESET;
                 SalesHeader.SETCURRENTKEY("Service Document No.");
                 SalesHeader.SETFILTER("Document Type",'%1|%2',SalesHeader."Document Type"::Invoice,SalesHeader."Document Type"::"Credit Memo");
                 SalesHeader.SETRANGE("Service Document No.","No.");
                 IF SalesHeader.FINDFIRST THEN
                  ERROR(Text101);
                
                  ServLine.SETRANGE("Document Type","Document Type");
                  ServLine.SETRANGE("Document No.","No.");
                  ServLine.SETFILTER("Unit Price",'<>%1',0);
                  ServLine.SETFILTER("VAT %",'<>%1',0);
                  IF ServLine.FINDFIRST THEN BEGIN
                    RecalculatePrice :=
                      ConfirmLoc(
                        STRSUBSTNO(
                          Text024 +
                          Text026,
                          FIELDCAPTION("Prices Including VAT"),ServLine.FIELDCAPTION("Unit Price")),
                        TRUE, '');
                    ServLine.SetServHeader(Rec);
                
                    IF "Currency Code" = '' THEN
                      Currency.InitRoundingPrecision
                    ELSE
                      Currency.GET("Currency Code");
                    ServLine.LOCKTABLE;
                    LOCKTABLE;
                    ServLine.FINDSET;
                    REPEAT
                      //27.08.2007. EDMS P2 >>
                      ServLine.TESTFIELD("Prepayment %", 0);
                      //27.08.2007. EDMS P2 <<
                
                      ServLineCopy := ServLine;
                      ServLine.TESTFIELD("Prepmt. Amt. Inv.",0); //08-05-2007 EDMS P3 PREPMT
                      IF NOT RecalculatePrice THEN BEGIN
                        ServLine."VAT Difference" := 0;
                        ServLine.InitOutstandingAmount;
                      END ELSE
                        IF "Prices Including VAT" THEN BEGIN
                          ServLine."Unit Price" :=
                            ROUND(
                              ServLine."Unit Price" * (1 + (ServLine."VAT %" / 100)),
                              Currency."Unit-Amount Rounding Precision");
                          IF ServLine.Quantity <> 0 THEN BEGIN
                            ServLine."Line Discount Amount" :=
                              ROUND(
                                ServLine.Quantity * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            ServLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                ServLine."Inv. Discount Amount" * (1 + (ServLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                            ServLine.UpdateAmounts
                
                          END;
                        END ELSE BEGIN
                          ServLine."Unit Price" :=
                            ROUND(
                              ServLine."Unit Price" / (1 + (ServLine."VAT %" / 100)),
                              Currency."Unit-Amount Rounding Precision");
                          IF ServLine.Quantity <> 0 THEN BEGIN
                            ServLine."Line Discount Amount" :=
                              ROUND(
                                ServLine.Quantity * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            ServLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                ServLine."Inv. Discount Amount" / (1 + (ServLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                            ServLine.UpdateAmounts
                          END;
                        END;
                      ServLine.MODIFY;
                    UNTIL ServLine.NEXT = 0;
                  END;
                END;
                */

            end;
        }
        field(51200; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Warranty Document Line".Amount where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(51201; "Total Adjusted"; Decimal)
        {
            CalcFormula = sum("Warranty Document Line"."Adjusted Amount" where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(51202; "Total Approved"; Decimal)
        {
            CalcFormula = sum("Warranty Reimbursment Entry".Amount where("Warranty Document No." = field("No."),
                                                                          Status = const(Approved)));
            FieldClass = FlowField;
        }
        field(51203; "Total Rejected"; Decimal)
        {
            CalcFormula = sum("Warranty Reimbursment Entry".Amount where("Warranty Document No." = field("No."),
                                                                          Status = const(Rejected)));
            FieldClass = FlowField;
        }
        field(51240; "Initial Service Order No."; Code[20])
        {
            Caption = 'Initial Service Order No.';
        }
        field(52001; "Unplanned Stop"; Boolean)
        {
            Caption = 'Unplanned Stop';
        }
        field(52002; "Item Repair Status"; Option)
        {
            Caption = 'Item Repair Status';
            OptionCaption = 'Replaced,Repaired';
            OptionMembers = Replaced,Repaired;
        }
        field(52004; "Causal Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(52005; "Causal Item Serial No."; Code[20])
        {
            Caption = 'Causal Item Serial No.';
        }
        field(52011; "Parts Fitted Date"; Date)
        {
            Caption = 'Parts Fitted Date';
        }
        field(52012; "Parts Operation Hours"; Decimal)
        {
            Caption = 'Parts Operation Hours';
            DecimalPlaces = 0 : 0;
        }
        field(52016; "Repair Date"; Date)
        {
            Caption = 'Repair Date';
        }
        field(52110; "Recall Campaign External No."; Code[20])
        {
            Caption = 'Recall Campaign External No.';

            trigger OnValidate()
            var
                RecallCampaign: Record "Recall Campaign";
                RecallCampaignList: Page "Recall Campaign List";
            begin
                RecallCampaign.Reset;
                RecallCampaign.SetRange("External No.", "Recall Campaign External No.");
                if RecallCampaign.Count > 0 then
                    if RecallCampaign.Count = 1 then begin
                        RecallCampaign.FindFirst;
                        Validate("Recal Campaign Code", RecallCampaign."No.");
                    end else begin
                        RecallCampaignList.SetTableview(RecallCampaign);
                        RecallCampaignList.LookupMode := true;
                        if RecallCampaignList.RunModal = Action::LookupOK then begin
                            RecallCampaignList.GetRecord(RecallCampaign);
                            Validate("Recal Campaign Code", RecallCampaign."No.");
                        end;
                    end;
            end;
        }
        field(25006001; "Deal Type"; Code[10])
        {
            Caption = 'Deal Type';
            TableRelation = "Deal Type";
        }
        field(25007407; "Document Status"; Code[20])
        {
            Caption = 'Document Status';
            TableRelation = "Document Status".Code where("Document Type" = const("Warranty Document"),
                                                          "Document Profile" = const(Service));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        WarrantyDocumentLine: Record "Warranty Document Line";
    begin
        WarrantyDocumentLine.Reset;
        WarrantyDocumentLine.SetRange("Document No.", "No.");
        WarrantyDocumentLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        WarrantySetup.Get;

        if "No." = '' then begin
            TestNoSeries;
            "No. Series" := GetNoSeriesCode();
            "No." := NoSeriesMgt.GetNextNo("No. Series", "Posting Date", true);

        end;

        InitRecord;
    end;

    var
        Vehicle: Record Vehicle;
        HideValidationDialog: Boolean;
        EDMS001: label '%1 cannot be less than in previous visit.';
        Text021: label 'Do you want to update the exchange rate?';
        Text102: label 'Pending service plan No. %1 exists for this vehicle.';
        Text121: label 'The vehicle %1 %2, registration number %3,  VIN %4 exists in %5 other service orders.';
        Text131: label 'There is no vehicle with Registration No. %1';
        Text137: label 'There is no %1 with %2 %3';
        LookUpMgt: Codeunit LookUpManagement;
        tcSER001: label 'The vehicle %1 %2, registration number %3,  VIN %4 exists on another service order.';
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        Text130: label 'There are one or more pending recall campaigns for VIN %1. Please check recall campaign details';
        WarrantySetup: Record "Warranty Setup";
        WarrantyHeader: Record "Warranty Document Header";
        AppMgt: Codeunit DocumentManagementDMS;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
        Confirmed: Boolean;
        NoSeriesMgt: Codeunit "No. Series";
        Text051: label 'The Warranty Document %1 already exists.';
        VFMgt: Codeunit "Variable Field Management";


    procedure InitRecord()
    var
        LocCodeFilterStr: Code[20];
        SingleQuote: Char;
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate;
        "Document Date" := WorkDate;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        exit(WarrantySetup."Warranty Document Nos.");
    end;

    local procedure TestNoSeries(): Boolean
    begin
        WarrantySetup.TestField("Warranty Document Nos.");
    end;


    procedure AssistEdit(OldWarrantyHeader: Record "Warranty Document Header"): Boolean
    var
        WarrantyHeader2: Record "Warranty Document Header";
    begin
        WarrantyHeader.Copy(Rec);
        WarrantySetup.Get;
        TestNoSeries;
        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldWarrantyHeader."No. Series", WarrantyHeader."No. Series") then begin
            WarrantyHeader."No." := NoSeriesMgt.GetNextNo(WarrantyHeader."No. Series", WorkDate(), true);
            if WarrantyHeader2.Get(WarrantyHeader."No.") then
                Error(Text051, WarrantyHeader."No.");
            Rec := WarrantyHeader;
            exit(true);
        end;
    end;


    procedure MessageLoc(MessageTxt: Text[1024]; RunParStr: Text[1024])
    begin
        // RunParStr not used for now
        if not HideValidationDialog then
            Message(MessageTxt);
    end;


    procedure ConfirmLoc(MessageTxt: Text[1024]; ActiveButton: Boolean; RunParStr: Text[1024]): Boolean
    begin
        // RunParStr not used for now
        if HideValidationDialog then
            exit(true)
        else
            exit(Confirm(MessageTxt, ActiveButton));
    end;


    procedure OnLookupVehicleRegistrationNo()
    begin
        if "Vehicle Registration No." <> '' then begin
            Vehicle.Reset;
            Vehicle.SetCurrentkey("Registration No.");
            Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
            if Vehicle.FindFirst then;
            Vehicle.SetRange("Registration No.");
        end;

        if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then
            Validate("Vehicle Serial No.", Vehicle."Serial No.");
    end;


    procedure OnLookupVIN()
    var
        Vehicle: Record Vehicle;
    begin
        if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then
            Validate("Vehicle Serial No.", Vehicle."Serial No.");
    end;


    procedure CheckRecallCampaigns(VehSerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
        RecallCampaignVeh: Record "Recall Campaign Vehicle";
    begin
        Vehicle.Reset;
        if not Vehicle.Get(VehSerialNo) then
            exit;

        ServiceSetup.Get;
        if not ServiceSetup."Recall Campaign Warnings" then
            exit;

        RecallCampaignVeh.Reset;
        RecallCampaignVeh.SetRange(VIN, Vehicle.VIN);
        if RecallCampaignVeh.FindFirst then
            repeat
                RecallCampaignVeh.CalcFields("Active Campaign");
                if (RecallCampaignVeh."Active Campaign") and not RecallCampaignVeh.Serviced then
                    MessageLoc(StrSubstNo(Text130, Vehicle.VIN), '');
            until RecallCampaignVeh.Next = 0;
    end;


    procedure TestVFRun1()
    var
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
    begin
        //14.09.2007. P2 >>
        if "Variable Field Run 1" > 0 then begin
            if "Variable Field Run 1" < ServOrdInfoPaneMgt.CalcLastVisitVFRun1("Vehicle Serial No.") then
                MessageLoc(StrSubstNo(EDMS001, AppMgt.CaptionClassTranslate_off(GlobalLanguage, '7,25006145,25006180')), '');
            TestVFRun1ForComponent;
        end;
        //14.09.2007. P2 <<
    end;


    procedure TestVFRun2()
    var
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
    begin
        if "Variable Field Run 2" > 0 then begin
            if "Variable Field Run 2" < ServOrdInfoPaneMgt.CalcLastVisitVFRun2("Vehicle Serial No.") then
                MessageLoc(StrSubstNo(EDMS001, AppMgt.CaptionClassTranslate_off(GlobalLanguage, '7,25006145,25006255')), '');
            TestVFRun1ForComponent;
        end;
    end;


    procedure TestVFRun3()
    var
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
    begin
        if "Variable Field Run 3" > 0 then begin
            if "Variable Field Run 3" < ServOrdInfoPaneMgt.CalcLastVisitVFRun3("Vehicle Serial No.") then
                MessageLoc(StrSubstNo(EDMS001, AppMgt.CaptionClassTranslate_off(GlobalLanguage, '7,25006145,25006260')), '');
            TestVFRun1ForComponent;
        end;
    end;


    procedure CheckServicePlan(FieldPar: Integer)
    var
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        PlanDateFormula: Code[20];
    begin
        if "Vehicle Serial No." = '' then
            exit;
        ServiceSetup.Get;

        if not ServiceSetup."Service Plan Notification" then
            exit;

        if IsAchievedServPlanStageByField(FieldPar, VehicleServicePlanStage) then
            MessageLoc(StrSubstNo(Text102, VehicleServicePlanStage."Plan No."), '');
    end;


    procedure TestVFRun1ForComponent()
    var
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        CompPendingPlanExists: Boolean;
    begin
        /*
        // for now do not check actual value
        ServiceSetup.GET;
        IF ServiceSetup."Notify About Components" THEN
          IF NOT (("Document Type" = LastModifiedRec."Document Type") AND ("No." = LastModifiedRec."No.")) THEN
            AboutComponentsNotified := FALSE;
          LastModifiedRec := Rec;
          IF NOT AboutComponentsNotified THEN BEGIN
            VehicleComponent.RESET;
            VehicleComponent.SETRANGE("Parent Vehicle Serial No.", "Vehicle Serial No.");
            IF VehicleComponent.FINDFIRST THEN
              REPEAT
                VehicleServicePlanStage.RESET;
                VehicleServicePlanStage.SETCURRENTKEY(Status,"Expected Service Date");
                VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
                VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", VehicleComponent."No.");
                CompPendingPlanExists := VehicleServicePlanStage.FINDFIRST;
              UNTIL ((VehicleComponent.NEXT = 0) OR CompPendingPlanExists);
              IF CompPendingPlanExists THEN BEGIN
                MessageLoc(Text132, '');
                AboutComponentsNotified := TRUE;
              END;
          END;
        */

    end;


    procedure IsAchievedServPlanStageByField(FieldPar: Integer; var VehicleServicePlanStage: Record "Vehicle Service Plan Stage"): Boolean
    var
        VehicleServicePlan: Record "Vehicle Service Plan";
        PlanDateFormula: Code[20];
        MakeCheck: Boolean;
    begin
        ServiceSetup.Get;

        VehicleServicePlanStage.Reset;
        VehicleServicePlanStage.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleServicePlanStage.SetRange(Status, VehicleServicePlanStage.Status::Pending);
        /*
        CASE FieldPar OF
          FIELDNO("Variable Field Run 1"):
            BEGIN
              IF ("Variable Field Run 1" = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE("Variable Field Run 1", 0.0000000001,
                                               "Variable Field Run 1" + ServiceSetup."Notify Before (VF Run 1)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Variable Field Run 1" = 0) THEN
                  EXIT(FALSE);
            END;
          FIELDNO("Variable Field Run 2"):
            BEGIN
              IF ("Variable Field Run 2" = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE("Variable Field Run 2", 0.0000000001,
                                               "Variable Field Run 2" + ServiceSetup."Notify Before (VF Run 2)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Variable Field Run 2" = 0) THEN
                  EXIT(FALSE);
            END;
          FIELDNO("Variable Field Run 3"):
            BEGIN
              IF ("Variable Field Run 3" = 0) THEN
                EXIT(FALSE);
              VehicleServicePlanStage.SETRANGE("Variable Field Run 3", 0.0000000001,
                                               "Variable Field Run 3" + ServiceSetup."Notify Before (VF Run 3)");
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Variable Field Run 3" = 0) THEN
                  EXIT(FALSE);
            END;
          FIELDNO("Order Date"):
            BEGIN
              IF ("Order Date" = 0D) THEN
                EXIT(FALSE);
              //08.05.2013 EDMS P8 >>
              EXIT(IsAchievedServStageByInterval(VehicleServicePlanStage));
              //08.05.2013 EDMS P8 <<
              {
              PlanDateFormula := '-' +FORMAT(ServiceSetup."Notify Before (Date Formula)");
              VehicleServicePlanStage.SETRANGE("Expected Service Date",
                                               20010101D,
                                               CALCDATE(ServiceSetup."Notify Before (Date Formula)","Order Date"));
              IF VehicleServicePlanStage.FINDFIRST THEN
                IF (VehicleServicePlanStage."Expected Service Date" = 0D) THEN
                  EXIT(FALSE);
              }
            END;
        END;
        */
        exit(VehicleServicePlanStage.FindFirst);

    end;

    local procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
            CurrencyDate := WorkDate;
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        Confirmed := ConfirmLoc(Text021, false, '');
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Warranty Document Header", FieldNo));
    end;
}

