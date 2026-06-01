tableextension 25006004 "Customer" extends Customer //18
{
    // 24.11.2015 EB.P7 #T017
    //   OnInsert Modified, code moved to Events
    //   Added function GetInsertFromContacts
    //   Moved function CustomerUpdateFromTemplate to Events
    //   OnDelete Modified code moved to events
    //   Blocked field OnValidate Code moved to events
    // 
    // 09.03.2015 EDMS P21
    //   Added field:
    //     25006120 "Item Charge Invoice Deal Type"
    // 
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified functions:
    //     GetActiveContractQty
    //     ShowActiveContracts
    //     SetContractFilter
    // 
    // 18.02.2014 Elva Baltic P15 #F100 MMG7.00
    //   * Added functions:
    //     - BillToNoActiveContracts(BillToNo, Suspend)
    // 
    // 04.02.2014 Elva Baltic P7 #F044 MMG7.00
    //   * OnInsert modified to add customer template functionality
    // 
    // 12.08.2013 EDMS P8
    //   * Added fields "No. of Serv. Quotes"
    // 
    // 26.07.2007. EDMS P2
    //   * Added function - GetFirstBankAccount
    // 
    // 21.06.2007. EDMS P2
    //   * Added new key - Name
    fields
    {
        field(25006010; "No. of Active Contracts"; Integer)
        {
            CalcFormula = count(Contract where("Bill-to Customer No." = field("No."),
                                                Status = const(Active)));
            Caption = 'No. of Serv. Orders';
            FieldClass = FlowField;
        }
        field(25006100; "Corresponding Vendor No."; Code[20])
        {
            Caption = 'Corresponding Vendor No.';
            TableRelation = Vendor;
        }
        field(25006110; "Default Service Item Charge"; Code[20])
        {
            Caption = 'Default Service Item Charge';
            TableRelation = "Item Charge";
        }
        field(25006120; "Item Charge Invoice Deal Type"; Code[10])
        {
            Caption = 'Item Charge Invoice Deal Type';
            TableRelation = "Deal Type";
        }
        field(25006160; Internal; Boolean)
        {
            Caption = 'Internal';
            Description = 'TRUE means that customer is not a real customer';
        }
        field(25006200; "Form Initiated"; Boolean)
        {
            Caption = 'Form Initiated';
        }
        field(25006210; "No. of Serv. Quotes"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const(Quote),
                                                             "Sell-to Customer No." = field("No.")));
            Caption = 'No. of Serv. Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006211; "No. of Serv. Orders"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const(Order),
                                                             "Sell-to Customer No." = field("No.")));
            Caption = 'No. of Serv. Orders';
            FieldClass = FlowField;
        }
        field(25006212; "No. of Serv. Invoices"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Invoice),
                                                      "Sell-to Customer No." = field("No."),
                                                      "Document Profile" = const(Service)));
            Caption = 'No. of Serv. Invoices';
            FieldClass = FlowField;
        }
        field(25006213; "No. of Serv. Return Orders"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const("Return Order"),
                                                             "Sell-to Customer No." = field("No.")));
            Caption = 'No. of Serv. Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006214; "No. of Serv. Credit Memos"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const("Credit Memo"),
                                                      "Sell-to Customer No." = field("No."),
                                                      "Document Profile" = const(Service)));
            Caption = 'No. of Serv. Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006215; "No. of Serv. Pstd. Orders"; Integer)
        {
            CalcFormula = count("Posted Serv. Order Header" where("Sell-to Customer No." = field("No.")));
            Caption = 'No. of Serv. Pstd. Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006216; "No. of Serv. Pstd. Invoices"; Integer)
        {
            CalcFormula = count("Sales Invoice Header" where("Sell-to Customer No." = field("No."),
                                                              "Document Profile" = const(Service)));
            Caption = 'No. of Serv. Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006217; "No. of Serv. Pstd. Ret. Orders"; Integer)
        {
            CalcFormula = count("Posted Serv. Ret. Order Header" where("Sell-to Customer No." = field("No.")));
            Caption = 'No. of Serv. Pstd. Ret. Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006218; "No. of Serv. Pstd. Cr. Memos"; Integer)
        {
            CalcFormula = count("Sales Cr.Memo Header" where("Sell-to Customer No." = field("No."),
                                                              "Document Profile" = const(Service)));
            Caption = 'No. of Serv. Pstd. Cr. Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006219; "No. of Serv. Pstd. Shipments"; Integer)
        {
            CalcFormula = count("Sales Shipment Header" where("Sell-to Customer No." = field("No."),
                                                               "Document Profile" = const(Service)));
            Caption = 'No. of Serv. Pstd. Shipments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006220; "Bill-To No. of S. Quotes"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const(Quote),
                                                             "Bill-to Customer No." = field("No.")));
            Caption = 'Bill-To No. of Serv. Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006221; "Bill-To No. of S. Orders"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const(Order),
                                                             "Bill-to Customer No." = field("No.")));
            Caption = 'Bill-To No. of Serv. Orders';
            FieldClass = FlowField;
        }
        field(25006222; "Bill-To No. of S. Invoices"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const(Invoice),
                                                      "Bill-to Customer No." = field("No."),
                                                      "Document Profile" = const(Service)));
            Caption = 'Bill-To No. of Serv. Invoices';
            FieldClass = FlowField;
        }
        field(25006223; "Bill-To No. of S. Ret. Orders"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const("Return Order"),
                                                             "Bill-to Customer No." = field("No.")));
            Caption = 'Bill-To No. of Serv. Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006224; "Bill-To No. of S. Credit Memos"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = const("Credit Memo"),
                                                      "Bill-to Customer No." = field("No."),
                                                      "Document Profile" = const(Service)));
            Caption = 'Bill-To No. of Serv. Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006225; "Bill-To No. of S. Pstd. Orders"; Integer)
        {
            CalcFormula = count("Posted Serv. Order Header" where("Bill-to Customer No." = field("No.")));
            Caption = 'Bill-To No. of Serv. Pstd. Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006226; "Bill-To No. of S. Pstd. Inv."; Integer)
        {
            CalcFormula = count("Sales Invoice Header" where("Bill-to Customer No." = field("No."),
                                                              "Document Profile" = const(Service)));
            Caption = 'Bill-To No. of Serv. Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006227; "Bill-To No. of S. Pstd. R.Ord."; Integer)
        {
            CalcFormula = count("Posted Serv. Ret. Order Header" where("Bill-to Customer No." = field("No.")));
            Caption = 'Bill-To No. of Serv. Pstd. Ret. Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006228; "Bill-To No. of S. Pstd. C.Mem."; Integer)
        {
            CalcFormula = count("Sales Cr.Memo Header" where("Bill-to Customer No." = field("No."),
                                                              "Document Profile" = const(Service)));
            Caption = 'Bill-To No. of Serv. Pstd. Cr. Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006229; "Bill-To No. of S. Pstd. Shipm."; Integer)
        {
            CalcFormula = count("Sales Shipment Header" where("Bill-to Customer No." = field("No."),
                                                               "Document Profile" = const(Service)));
            Caption = 'Bill-To No. of Pstd. Shipments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006230; "Outstanding Orders SP (LCY)"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Sales Line"."Outstanding Amount (LCY)" where("Document Type" = const(Order),
                                                                             "Bill-to Customer No." = field("No."),
                                                                             "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Currency Code" = field("Currency Filter"),
                                                                             "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Outstanding Orders Spare Parts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006231; "Shipped Not Invoiced SP (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Sales Line"."Shipped Not Invoiced (LCY)" where("Document Type" = const(Order),
                                                                               "Bill-to Customer No." = field("No."),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Currency Code" = field("Currency Filter"),
                                                                               "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Shipped Not Invoiced Spare Parts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006232; "Outstanding Invoices SP (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Sales Line"."Outstanding Amount (LCY)" where("Document Type" = const(Invoice),
                                                                             "Bill-to Customer No." = field("No."),
                                                                             "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Currency Code" = field("Currency Filter"),
                                                                             "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Outstanding Invoices Spare Parts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006233; "Outst. Serv. Orders EDMS (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Service Line EDMS"."Amount Including VAT" where("Document Type" = const(Order),
                                                                                "Bill-to Customer No." = field("No."),
                                                                                "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                                "Currency Code" = field("Currency Filter")));
            Caption = 'Outstanding Serv. Orders (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006234; "Outst. Serv.Invoices EDMS(LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Sales Line"."Outstanding Amount (LCY)" where("Document Type" = const(Invoice),
                                                                             "Bill-to Customer No." = field("No."),
                                                                             "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                             "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                             "Currency Code" = field("Currency Filter"),
                                                                             "Document Profile" = const(Service)));
            Caption = 'Outstanding Serv. Invoices (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006240; "No. of S.Pstd. Return Receipts"; Integer)
        {
            CalcFormula = count("Return Receipt Header" where("Sell-to Customer No." = field("No."),
                                                               "Document Profile" = const(Service)));
            Caption = 'No. of Pstd. Return Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006241; "Bill-To No. of S.Pstd. Ret. R."; Integer)
        {
            CalcFormula = count("Return Receipt Header" where("Bill-to Customer No." = field("No."),
                                                               "Document Profile" = const(Service)));
            Caption = 'Bill-To No. of Pstd. Return R.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006970; "GDPR Consent Form Signed"; Boolean)
        {
            Caption = 'GDPR Consent Form Signed';
            DataClassification = ToBeClassified;
        }

    }

    var
        UserSetup: Record "User Setup";
        Contract: Record Contract;

    procedure GetLinkedVendor(): Code[20]
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        ContBusRel.SetCurrentkey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
        ContBusRel.SetRange("No.", "No.");
        if ContBusRel.Find('-') then begin
            ContBusRel.SetRange("Contact No.", ContBusRel."Contact No.");
            ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Vendor);
            ContBusRel.SetRange("No.");
            if ContBusRel.Find('-') then
                exit(ContBusRel."No.");
        end;
    end;

    procedure GetFirstBankAccount(Customer: Record Customer): Text[30]
    var
        CustBankAccount: Record "Customer Bank Account";
    begin
        CustBankAccount.Reset;
        CustBankAccount.SetRange("Customer No.", Customer."No.");
        if CustBankAccount.FindFirst then
            exit(CustBankAccount.Iban)
        else
            exit('');
    end;

    procedure ShowVehicles()
    var
        ContBusRel: Record "Contact Business Relation";
        VehicleContact: Record "Vehicle Contact";
    begin
        ContBusRel.Reset;
        ContBusRel.SetCurrentkey("Link to Table", "No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
        ContBusRel.SetRange("No.", "No.");
        if ContBusRel.FindFirst then begin
            VehicleContact.Reset;
            VehicleContact.SetCurrentkey("Contact No.");
            VehicleContact.SetRange("Contact No.", ContBusRel."Contact No.");
            Page.RunModal(Page::"Contact Vehicles", VehicleContact);
        end;
    end;

    procedure GetActiveContractQty(StatusPar: Option Inactive,Active; SuspendedPar: Boolean; DocumentProfile: Option " ","Spare Parts Trade",,Service; Date: Date; VehicleSerialNo: Code[20]) RetVal: Integer
    var
        ContractTemp: Record Contract temporary;
    begin
        SetContractFilter(ContractTemp, StatusPar, SuspendedPar, DocumentProfile, Date, VehicleSerialNo);
        exit(ContractTemp.Count);
    end;

    procedure ShowActiveContracts(StatusPar: Option Inactive,Active; SuspendedPar: Boolean; DocumentProfile: Option " ","Spare Parts Trade",,Service; Date: Date; VehicleSerialNo: Code[20])
    var
        ContractQty: Integer;
        ContractTemp: Record Contract temporary;
    begin
        SetContractFilter(ContractTemp, StatusPar, SuspendedPar, DocumentProfile, Date, VehicleSerialNo);
        ContractQty := ContractTemp.Count;
        if ContractQty = 0 then
            exit;
        if ContractQty = 1 then begin
            if Contract.Get(ContractTemp."Contract No.") then
                Page.RunModal(Page::Contract, Contract);
        end else
            Page.RunModal(Page::"Contract List EDMS", ContractTemp);
    end;

    procedure SetContractFilter(var ContractTemp: Record Contract temporary; StatusPar: Option Inactive,Active; SuspendedPar: Boolean; DocumentProfile: Option " ","Spare Parts Trade",,Service; Date: Date; VehicleSerialNo: Code[20])
    var
        ContractVehicle: Record "Contract Vehicle";
    begin
        Clear(ContractTemp);
        Contract.Reset;
        Contract.SetRange("Bill-to Customer No.", "No.");
        Contract.SetFilter("Document Profile", '%1|%2', Contract."document profile"::" ", DocumentProfile);
        Contract.SetRange("Starting Date", 0D, Date);
        Contract.SetFilter("Expiration Date", '%1|>=%2', 0D, Date);
        Contract.SetRange(Status, StatusPar);
        Contract.SetRange(Suspended, SuspendedPar);
        if Contract.FindSet then
            repeat
                if (VehicleSerialNo <> '') then begin
                    ContractVehicle.Reset;
                    ContractVehicle.SetRange("Contract No.", Contract."Contract No.");
                    if ContractVehicle.IsEmpty then begin
                        ContractTemp.Init;
                        ContractTemp := Contract;
                        ContractTemp.Insert;
                    end else begin
                        ContractVehicle.SetRange("Vehicle Serial No.", VehicleSerialNo);
                        if ContractVehicle.FindFirst then begin
                            ContractTemp.Init;
                            ContractTemp := Contract;
                            ContractTemp.Insert;
                        end;
                    end;
                end else begin
                    ContractTemp.Init;
                    ContractTemp := Contract;
                    ContractTemp.Insert;
                end;
            until Contract.Next = 0;
    end;

}