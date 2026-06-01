Table 25006045 "Contract Archive"
{
    Caption = 'Contract Archive';
    DataCaptionFields = "Contract No.", Description;
    DrillDownPageID = "Contract List Archive";
    LookupPageID = "Contract List Archive";

    fields
    {
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(30; "Description 2"; Text[50])
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
        field(110; "Bill-to City"; Text[30])
        {
            CalcFormula = lookup(Customer.City where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to City';
            Editable = false;
            FieldClass = FlowField;
        }
        field(115; "Bill-to County"; Text[30])
        {
            CalcFormula = lookup(Customer.County where("No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to County';
            Editable = false;
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
        }
        field(2000; "Document Profille"; Option)
        {
            Caption = 'Document Profille';
            OptionCaption = ' ,Spare Parts Trade,,Service';
            OptionMembers = " ","Spare Parts Trade",,Service;
        }
        field(5043; "Interaction Exist"; Boolean)
        {
            Caption = 'Interaction Exist';
        }
        field(5044; "Time Archived"; Time)
        {
            Caption = 'Time Archived';
        }
        field(5045; "Date Archived"; Date)
        {
            Caption = 'Date Archived';
        }
        field(5046; "Archived By"; Code[50])
        {
            Caption = 'Archived By';
        }
        field(5047; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
    }

    keys
    {
        key(Key1; "Contract No.", "Doc. No. Occurrence", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ContractSignerArch: Record "Contract Signer Archive";
        ContractSalesPriceArch: Record "Contract Sales Price Archive";
        ContractSalesLineDiscArch: Record "Contract Sales Line Disc.Arch.";
        ServCommentLineArch: Record "Serv. Comment Line Arch. EDMS";
    begin
        ContractSignerArch.SetRange("Contract No.", "Contract No.");
        ContractSignerArch.SetRange("Doc. No. Occurrence", "Doc. No. Occurrence");
        ContractSignerArch.SetRange("Version No.", "Version No.");
        ContractSignerArch.DeleteAll(true);

        ContractSalesPriceArch.SetRange("Contract No.", "Contract No.");
        ContractSalesPriceArch.SetRange("Doc. No. Occurrence", "Doc. No. Occurrence");
        ContractSalesPriceArch.SetRange("Version No.", "Version No.");
        ContractSalesPriceArch.DeleteAll(true);

        ContractSalesLineDiscArch.SetRange("Contract No.", "Contract No.");
        ContractSalesLineDiscArch.SetRange("Doc. No. Occurrence", "Doc. No. Occurrence");
        ContractSalesLineDiscArch.SetRange("Version No.", "Version No.");
        ContractSalesLineDiscArch.DeleteAll(true);

        ServCommentLineArch.SetRange(Type, ServCommentLineArch.Type::Contract);
        ServCommentLineArch.SetRange("No.", "Contract No.");
        ServCommentLineArch.SetRange("Doc. No. Occurrence", "Doc. No. Occurrence");
        ServCommentLineArch.SetRange("Version No.", "Version No.");
        ServCommentLineArch.DeleteAll(true);
    end;
}

