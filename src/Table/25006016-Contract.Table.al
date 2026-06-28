Table 25006016 "Contract"
{
    // 10.10.2017 EB.AKR Billing Modify
    //   Added Fields:
    //    51108External Doc. No. For Invoices
    //    55000Contract Category Code
    //     55010Use For Billing
    //   55020External Contract No.
    //   55100Next Review Date
    //   55200Separate Invoice Per Vehicle
    //   Modified Key:
    // 
    // 
    // 03.07.2015 EB.P30
    //   Specified Table DrillDownPageID
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added TableRelation to field:
    //     "Fin. Charge Terms Code"
    //   Modified trigger:
    //     OnModify()
    // 
    // 19.03.2014 Elva Baltic P8 #S0006 MMG7.00
    //   * Added fields:
    //     "Conclusion of Contract Date"
    //     "Contract Location"
    //     "Accepted Amount"
    //     "Fin. Charge Terms Code"

    Caption = 'Contract';
    DataCaptionFields = "Contract No.", Description;
    DrillDownPageID = "Contract List EDMS";
    LookupPageID = "Contract List EDMS";

    fields
    {
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';

            trigger OnValidate()
            begin
                if "Contract No." <> xRec."Contract No." then begin
                    ServMgtSetup.Get;
                    "No. Series" := '';
                end;
            end;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(40; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Inactive,Active';
            OptionMembers = Inactive,Active;
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = const(Contract),
                                                                   "No." = field("Contract No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                Cust.Get("Bill-to Customer No.");
                ServContractLine.SetRange("Contract No.", "Contract No.");
                if ServContractLine.Find('-') then
                    Error(text013, "Contract No.");
                if "Bill-to Customer No." <> xRec."Bill-to Customer No." then
                    CalcFields("Bill-to Name", "Bill-to Name 2", "Bill-to Address", "Bill-to Address 2", "Bill-to Post Code", "Bill-to City",
                    "Bill-to County", "Bill-to Country/Region");
                "Payment Terms Code" := Cust."Payment Terms Code";
            end;
        }
        field(70; "Bill-to Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "Bill-to Name 2"; Text[50])
        {
            CalcFormula = lookup(Customer."Name 2" where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Bill-to Address"; Text[100])
        {
            CalcFormula = lookup(Customer.Address where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Bill-to Address 2"; Text[50])
        {
            CalcFormula = lookup(Customer."Address 2" where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Address 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Bill-to Post Code"; Code[20])
        {
            CalcFormula = lookup(Customer."Post Code" where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Post Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Bill-to City"; Text[50])
        {
            CalcFormula = lookup(Customer.City where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(115; "Bill-to County"; Text[50])
        {
            CalcFormula = lookup(Customer.County where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to County';
            FieldClass = FlowField;
        }
        field(120; "Bill-to Country/Region"; Code[10])
        {
            CalcFormula = lookup(Customer."Country/Region Code" where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Country/Region';
            Editable = false;
            FieldClass = FlowField;
        }
        field(140; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(310; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(320; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(340; "Max. Labor Unit Price"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Max. Labor Unit Price';
        }
        field(380; "Combine Invoices"; Boolean)
        {
            Caption = 'Combine Invoices';
        }
        field(420; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(430; "Cancel Reason Code"; Code[10])
        {
            Caption = 'Cancel Reason Code';
            TableRelation = "Reason Code";
        }
        field(510; "Service Period"; DateFormula)
        {
            Caption = 'Service Period';
        }
        field(520; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(580; "Accept Before"; Date)
        {
            Caption = 'Accept Before';
        }
        field(600; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(610; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(900; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if ("Bill-to Customer No." <> '') and (Cont.Get("Contact No.")) then
                    Cont.SetRange("Company No.", Cont."Company No.")
                else
                    if "Bill-to Customer No." <> '' then begin
                        ContBusinessRelation.Reset;
                        ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                        ContBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                        if ContBusinessRelation.FindFirst then
                            Cont.SetRange("Company No.", ContBusinessRelation."Contact No.");
                    end
                    else
                        Cont.SetFilter("Company No.", '<>''''');

                if "Contact No." <> '' then
                    if Cont.Get("Contact No.") then;

                if Page.RunModal(0, Cont) = Action::LookupOK then begin
                    xRec := Rec;
                    Validate("Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if ("Contact No." <> xRec."Contact No.") and (xRec."Contact No." <> '') then begin
                    if not Confirm(Text014, false, FieldCaption("Contact No.")) then begin
                        "Contact No." := xRec."Contact No.";
                        exit;
                    end;
                end;

                if ("Bill-to Customer No." <> '') and ("Contact No." <> '') then begin
                    Cont.Get("Contact No.");
                    ContBusinessRelation.Reset;
                    ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                    ContBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                    if ContBusinessRelation.FindFirst then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            Error(Text045, Cont."No.", Cont.Name, "Bill-to Customer No.");
                end;

                UpdateCust;
            end;
        }
        field(2000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service,Rent';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service,Rent;
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            CalcFormula = max("Contract Archive"."Version No." where("Contract No." = field("Contract No."),
                                                                      "Doc. No. Occurrence" = field("Doc. No. Occurrence")));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(51108; "External Doc. No. For Invoices"; Code[20])
        {
            Caption = 'External Document No. for Invoices';
        }
        field(55000; "Contract Category Code"; Code[20])
        {
            Caption = 'Contract Category Code';
            TableRelation = "BLS Contract Category";

            trigger OnValidate()
            begin
                if xRec."Contract Category Code" <> "Contract Category Code" then begin
                    "Use For Billing" := false;

                    if "Contract Category Code" <> '' then begin
                        ContractCategory.Get("Contract Category Code");
                        "Use For Billing" := ContractCategory."Use For Billing";
                    end;
                end;
            end;
        }
        field(55010; "Use For Billing"; Boolean)
        {
            Caption = 'Use For Billing';
        }
        field(55020; "External Contract No."; Code[50])
        {
            Caption = 'External Contract No.';
        }
        field(55100; "Next Review Date"; Date)
        {
            Caption = 'Next Review Date';
        }
        field(55200; "Separate Invoice Per Vehicle"; Boolean)
        {
            Caption = 'Separate Invoice Per Vehicle';
        }
        field(25006000; Suspended; Boolean)
        {
            Caption = 'Suspended';
        }
        field(25006010; "Conclusion of Contract Date"; Date)
        {
            Caption = 'Conclusion of Contract Date';
        }
        field(25006020; "Contract Location"; Text[30])
        {
            Caption = 'Contract Location';
        }
        field(25006030; "Accepted Amount"; Decimal)
        {
            Caption = 'Accepted Amount';
        }
        field(25006040; "Fin. Charge Terms Code"; Code[10])
        {
            Caption = 'Fin. Charge Terms Code';
            TableRelation = "Finance Charge Terms";
        }
        field(25006050; "Deal Type For Invoices"; Code[10])
        {
            Caption = 'Deal Type For Invoices';
            TableRelation = "Deal Type";
        }
        field(25006060; "Contract Description"; Blob)
        {
            Caption = 'Contract Description';
        }
    }

    keys
    {
        key(Key1; "Contract No.")
        {
            Clustered = true;
        }
        key(Key2; "Bill-to Customer No.")
        {
        }
        key(Key3; "Document Profile")
        {
        }

    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Status = Status::Active then
            Error(Text003, Format(Status), TableCaption);
        ServContractLine.Reset;
        ServContractLine.SetRange("Contract No.", "Contract No.");
        ServContractLine.DeleteAll;

        BLSCalculationLedgerEntry.Reset;
        BLSCalculationLedgerEntry.SetRange("Contract No.", "Contract No.");
        IF BLSCalculationLedgerEntry.FindFirst THEN
            Error(Text004, "Contract No.");

        ContractBillingServiceLines.Reset;
        ContractBillingServiceLines.SetRange("DMS Contract No.", "Contract No.");
        ContractBillingServiceLines.DeleteAll;

        ContractVehicle.Reset;
        ContractVehicle.SetRange("Contract No.", "Contract No.");
        ContractVehicle.DeleteAll;
    end;

    trigger OnInsert()
    begin
        SalesSetup.Get;
        if "Contract No." = '' then begin
            SalesSetup.TestField("Contract Nos.");
            "Contract No." := NoSeriesMgt.GetNextNo(SalesSetup."Contract Nos.", 0D, true);
            "No. Series" := SalesSetup."Contract Nos.";
        end;
        "Starting Date" := WorkDate;

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(Database::Contract, 0, "Contract No.");
    end;

    trigger OnModify()
    begin
        // TESTFIELD(Status, Status::Inactive);                                                 // 15.04.2014 Elva Baltic P21
    end;

    var
        text013: label 'Can''t change customer No. %1, because there exist contract lines for this customer.';
        Text014: label 'Do you want to change %1?';
        Text045: label 'Contact %1 %2 is related to a different company than customer %3.';
        Text044: label 'Contact %1 %2 is not related to customer %3.';
        SalesSetup: Record "Sales & Receivables Setup";
        SkipContact: Boolean;
        Text051: label 'Contact %1 %2 is not related to a customer.';
        Cust: Record Customer;
        DimMgt: Codeunit DimensionManagement;
        ServOrderMgt: Codeunit ServOrderManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        ContactNo: Code[20];
        ServMgtSetup: Record "Service Mgt. Setup EDMS";
        NoSeriesMgt: Codeunit "No. Series";
        Text003: label 'You cannot delete %1 %2.';
        ServContractLine: Record "Contract Sales Line Discount";
        ContractCategory: Record "BLS Contract Category";
        BLSCalculationLedgerEntry: Record "BLS Calculation Ledger Entry";
        ContractBillingServiceLines: Record "DMS Contract Line";
        ContractVehicle: Record "Contract Vehicle";
        Text004: Label 'You cannot delete contract %1, it has calculation entries.';


    procedure UpdateCust()
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
        CustTemplate: Record "Customer Templ.";
        ContComp: Record Contact;
    begin

        ContBusinessRelation.Reset;
        ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
        ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
        if ContBusinessRelation.FindFirst then begin
            if ("Bill-to Customer No." <> '') and
               ("Bill-to Customer No." <> ContBusinessRelation."No.")
            then
                Error(Text044, Cont."No.", Cont.Name, "Bill-to Customer No.")
            else
                if "Bill-to Customer No." = '' then begin
                    SkipContact := true;
                    Validate("Bill-to Customer No.", ContBusinessRelation."No.");
                    SkipContact := false;
                end;
        end else
            Error(Text051, Cont."No.", Cont.Name);
    end;


    procedure UpdateCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        Cust: Record Customer;
    begin
        if Cust.Get(CustomerNo) then begin
            Clear(ServOrderMgt);
            ContactNo := ServOrderMgt.FindContactInformation(Cust."No.");
            if Cont.Get(ContactNo) then begin
                "Contact No." := Cont."No.";
            end else begin
                if Cust."Primary Contact No." <> '' then
                    "Contact No." := Cust."Primary Contact No."
                else begin
                    ContBusRel.Reset;
                    ContBusRel.SetCurrentkey("Link to Table", "No.");
                    ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
                    ContBusRel.SetRange("No.", "Bill-to Customer No.");
                    if ContBusRel.FindFirst then
                        "Contact No." := ContBusRel."Contact No.";
                end;
            end;
        end;
    end;

    procedure SetContractDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Contract Description");
        "Contract Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetContractDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Contract Description");
        "Contract Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;
}

