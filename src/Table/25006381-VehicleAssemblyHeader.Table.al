//Table 25006381 "Vehicle Assembly Header"
Table 25006148 "Vehicle Assembly Header"
{
    Caption = 'Vehicle Assembly Header';

    fields
    {
        field(10; "Assembly ID"; Code[20])
        {
            Caption = 'Assembly ID';
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if "Currency Code" <> xRec."Currency Code" then
                    UpdateAssemblyLines(FieldCaption("Currency Code"), false);
            end;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdateAssemblyLines(FieldCaption("Currency Factor"), false);
            end;
        }
        field(40; "Exchange Date"; Date)
        {
            Caption = 'Exchange Date';
        }
        field(50; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                Currency: Record Currency;
                RecalculatePrice: Boolean;
            begin
                if "Prices Including VAT" <> xRec."Prices Including VAT" then begin
                    VehAssembly.Reset;
                    VehAssembly.SetRange("Assembly ID", "Assembly ID");
                    VehAssembly.SetFilter("Sales Price", '<>%1', 0);

                    if VehAssembly.FindSet(true, false) then begin
                        RecalculatePrice := true;
                        VehAssembly.SetAssemblyHeader(Rec);

                        if "Currency Code" = '' then
                            Currency.InitRoundingPrecision
                        else
                            Currency.Get("Currency Code");

                        repeat

                            if "Prices Including VAT" then begin
                                VehAssembly."Sales Price" :=
                                  ROUND(
                                    VehAssembly."Sales Price" * (1 + ("VAT %" / 100)),
                                    Currency."Unit-Amount Rounding Precision");
                                VehAssembly."Line Discount Amount" :=
                                  ROUND(
                                    VehAssembly."Sales Price" * VehAssembly."Line Discount %" / 100,
                                    Currency."Amount Rounding Precision");
                            end else begin
                                VehAssembly."Sales Price" :=
                                  ROUND(
                                    VehAssembly."Sales Price" / (1 + ("VAT %" / 100)),
                                    Currency."Unit-Amount Rounding Precision");

                                VehAssembly."Line Discount Amount" :=
                                  ROUND(
                                    VehAssembly."Sales Price" * VehAssembly."Line Discount %" / 100,
                                    Currency."Amount Rounding Precision");
                            end;
                            VehAssembly.UpdateAmounts;
                            VehAssembly.Modify;
                        until VehAssembly.Next = 0;
                    end;
                end;
            end;
        }
        field(60; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(70; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(80; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(100; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(110; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(120; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(130; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(140; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
        }
        field(150; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(160; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(170; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
        }
        field(180; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(190; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(200; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";

            trigger OnValidate()
            begin
                if "Customer Disc. Group" <> xRec."Customer Disc. Group" then
                    UpdateAssemblyLines(FieldCaption("Customer Disc. Group"), false)
            end;
        }
    }

    keys
    {
        key(Key1; "Assembly ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        VehAssembly: Record "Vehicle Assembly Line";
        Text001: label 'You have modified %1.\\';
        Text002: label 'Do you want to update the lines?';
        Text003: label '%1 and %2 cannot both be empty when %3 is used.';
        Text004: label 'You cannot change %1 if the item charge has already been posted.';


    procedure UpdateAmounts(CalledByFieldNo: Integer)
    begin
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;
    end;


    procedure UpdateAssemblyLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        if AssemblyLinesExist and AskQuestion then begin
            Question := StrSubstNo(
              Text001 +
              Text002, ChangedFieldName);
            if GuiAllowed and not Dialog.Confirm(Question, true) then
                exit
            else
                UpdateLines := true;
        end;
        if AssemblyLinesExist then begin
            VehAssembly.LockTable;
            Modify;

            VehAssembly.Reset;
            VehAssembly.SetRange("Assembly ID", "Assembly ID");
            if VehAssembly.FindSet then
                repeat
                    case ChangedFieldName of
                        FieldCaption("Currency Factor"):
                            begin
                                VehAssembly.Validate("Sales Price");
                                VehAssembly.Validate("Direct Purchase Cost");
                            end;
                        FieldCaption("Currency Code"):
                            begin
                                VehAssembly.UpdateSalesPrice(FieldNo("Currency Code"));
                                VehAssembly.UpdatePurchasePrice(FieldNo("Currency Code"));
                            end;
                    end;

                    VehAssembly.Modify(true);
                until VehAssembly.Next = 0;
        end;
    end;


    procedure AssemblyLinesExist(): Boolean
    begin
        VehAssembly.Reset;
        VehAssembly.SetRange(VehAssembly."Assembly ID");
        exit(VehAssembly.FindFirst)
    end;
}

