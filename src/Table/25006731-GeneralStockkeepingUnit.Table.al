Table 25006731 "General Stockkeeping Unit"
{
    // 20.11.2014 EB.P8 MERGE

    Caption = 'General Stockkeeping Unit';
    DrillDownPageID = "General Stockkeeping Unit List";
    LookupPageID = "General Stockkeeping Unit List";

    fields
    {
        field(1; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            NotBlank = true;
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                Item: Record Item;
            begin
                CalcFields(Description);
            end;
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            begin
                if "Location Code" = '' then
                    Validate("Replenishment System");
            end;
        }
        field(4; Description; Text[100])
        {
            CalcFormula = lookup("Item Category".Description where(Code = field("Item Category Code")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(33; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(34; "Reorder Point"; Decimal)
        {
            Caption = 'Reorder Point';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Maximum Inventory"; Decimal)
        {
            Caption = 'Maximum Inventory';
            DecimalPlaces = 0 : 5;
        }
        field(36; "Reorder Quantity"; Decimal)
        {
            Caption = 'Reorder Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(62; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(64; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(65; "Global Dimension 1 Filter"; Code[20])
        {
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(66; "Global Dimension 2 Filter"; Code[20])
        {
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(5400; "Transfer-Level Code"; Integer)
        {
            Caption = 'Transfer-Level Code';
            Editable = false;
        }
        field(5410; "Discrete Order Quantity"; Integer)
        {
            Caption = 'Discrete Order Quantity';
            MinValue = 0;
        }
        field(5411; "Minimum Order Quantity"; Decimal)
        {
            Caption = 'Minimum Order Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5412; "Maximum Order Quantity"; Decimal)
        {
            Caption = 'Maximum Order Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5413; "Safety Stock Quantity"; Decimal)
        {
            Caption = 'Safety Stock Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5414; "Order Multiple"; Decimal)
        {
            Caption = 'Order Multiple';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5415; "Safety Lead Time"; DateFormula)
        {
            Caption = 'Safety Lead Time';
        }
        field(5419; "Replenishment System"; Option)
        {
            Caption = 'Replenishment System';
            OptionCaption = 'Purchase,Prod. Order,Transfer';
            OptionMembers = Purchase,"Prod. Order",Transfer;

            trigger OnValidate()
            begin
                if ("Replenishment System" = "replenishment system"::Transfer) and
                  ("Location Code" = '')
                then
                    Error(
                      Text004,
                      FieldCaption("Location Code"), TableCaption,
                      "Replenishment System", FieldCaption("Replenishment System"));
                if "Replenishment System" in ["replenishment system"::Purchase, "replenishment system"::"Prod. Order"]
                then begin
                    "Transfer-Level Code" := 0;
                    FromLocation := "Transfer-from Code";
                    if not UpdateTransferLevels(Rec) then
                        ShowLoopError;
                end
                else
                    if "Replenishment System" = "replenishment system"::Transfer then
                        Validate("Transfer-from Code");
            end;
        }
        field(5423; "Bin Filter"; Code[20])
        {
            Caption = 'Bin Filter';
            FieldClass = FlowFilter;
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));
        }
        field(5428; "Reorder Cycle"; DateFormula)
        {
            Caption = 'Reorder Cycle';
        }
        field(5440; "Reordering Policy"; Option)
        {
            Caption = 'Reordering Policy';
            OptionCaption = ' ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot';
            OptionMembers = " ","Fixed Reorder Qty.","Maximum Qty.","Order","Lot-for-Lot";

            trigger OnValidate()
            begin
                if "Reordering Policy" <> "reordering policy"::"Lot-for-Lot" then
                    "Include Inventory" :=
                      ("Reordering Policy" <> "reordering policy"::" ") and
                      ("Reordering Policy" <> "reordering policy"::Order);
            end;
        }
        field(5441; "Include Inventory"; Boolean)
        {
            Caption = 'Include Inventory';
        }
        field(5700; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                FromGlobalSKU: Record "General Stockkeeping Unit";
            begin
                FromGlobalSKU.SetRange("Location Code", "Transfer-from Code");
                FromGlobalSKU.SetRange("Item Category Code", "Item Category Code");
                if not FromGlobalSKU.FindFirst then
                    "Transfer-Level Code" := -1
                else
                    "Transfer-Level Code" := FromGlobalSKU."Transfer-Level Code" - 1;
                FromLocation := "Transfer-from Code";
                Modify(true);
                if not UpdateTransferLevels(Rec) then
                    ShowLoopError;

                if ("Transfer-from Code" <> '') then
                    if not TransferRouteExists("Transfer-from Code", "Location Code") then
                        Error(
                          Text005,
                          TransferRoute.TableCaption,
                          FieldCaption("Location Code"),
                          "Transfer-from Code",
                          "Location Code");
            end;
        }
        field(7301; "Special Equipment Code"; Code[10])
        {
            Caption = 'Special Equipment Code';
            TableRelation = "Special Equipment";
        }
        field(7302; "Put-away Template Code"; Code[10])
        {
            Caption = 'Put-away Template Code';
            TableRelation = "Put-away Template Header";
        }
        field(7380; "Phys Invt Counting Period Code"; Code[10])
        {
            Caption = 'Phys Invt Counting Period Code';
            TableRelation = "Phys. Invt. Counting Period";

            trigger OnValidate()
            var
                PhysInvtCountPeriod: Record "Phys. Invt. Counting Period";
                PhysInvtCountPeriodMgt: Codeunit "Phys. Invt. Count.-Management";
                NextStartDate: Date;
                NextEndDate: Date;
            begin
                if "Phys Invt Counting Period Code" <> '' then begin
                    PhysInvtCountPeriod.Get("Phys Invt Counting Period Code");
                    PhysInvtCountPeriod.TestField("Count Frequency per Year");
                    if "Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code" then begin
                        if CurrFieldNo <> 0 then
                            if not Confirm(
                              Text7380,
                              false,
                              FieldCaption("Phys Invt Counting Period Code"),
                              FieldCaption("Next Counting Period"))
                            then
                                Error(Text7381);

                        //20.11.2014 EB.P8 MERGE >>
                        NextStartDate := 0D;
                        NextEndDate := 99991231D;
                        //Merge NAV 2017 W1 CU8 >>
                        //    PhysInvtCountPeriodMgt.CalcPeriod(
                        //      "Last Counting Period Update", NextStartDate, NextEndDate,
                        //      PhysInvtCountPeriod."Count Frequency per Year",
                        //      ("Last Counting Period Update" = 0D) OR
                        //      ("Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code"));
                        //Merge NAV 2017 W1 CU8 <<
                        PhysInvtCountPeriodMgt.CalcPeriod(
                          "Last Counting Period Update", NextStartDate, NextEndDate,
                          PhysInvtCountPeriod."Count Frequency per Year");
                        if ((NextStartDate = 0D) and (NextEndDate = 99991231D)) then
                            "Next Counting Period" := ''
                        else
                            "Next Counting Period" := Format(NextStartDate) + '..' + Format(NextEndDate);
                        //20.11.2014 EB.P8 MERGE <<
                    end;
                end else begin
                    if not Confirm(Text003, false, FieldCaption("Phys Invt Counting Period Code")) then
                        Error(Text7380);
                    "Next Counting Period" := '';
                    "Last Counting Period Update" := 0D;
                end;
            end;
        }
        field(7381; "Last Counting Period Update"; Date)
        {
            Caption = 'Last Counting Period Update';
            Editable = false;
        }
        field(7382; "Next Counting Period"; Text[250])
        {
            Caption = 'Next Counting Period';
            Editable = false;
        }
        field(7384; "Use Cross-Docking"; Boolean)
        {
            Caption = 'Use Cross-Docking';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Location Code", "Item Category Code")
        {
            Clustered = true;
        }
        key(Key2; "Replenishment System", "Vendor No.", "Transfer-from Code")
        {
        }
        key(Key3; "Item Category Code", "Location Code")
        {
        }
        key(Key4; "Item Category Code", "Transfer-Level Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        StockkeepingCommentLine: Record "Stockkeeping Unit Comment Line";
    begin
    end;

    trigger OnInsert()
    begin
        if ("Location Code" = '')
        then
            Error(
              Text000,
              FieldCaption("Location Code"), TableCaption);

        "Last Date Modified" := Today;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        if ("Location Code" = '')
        then
            Error(
              Text000,
              FieldCaption("Location Code"), TableCaption);

        "Last Date Modified" := Today;
    end;

    var
        Text000: label 'You must specify a %1 or a %2 for each %3.';
        Text003: label 'Do you want to change %1?';
        Text004: label 'You must specify a %1 for this %2 to use %3 as %4.';
        Text005: label 'You must specify a %1 from %2 %3 to %2 %4.';
        Text006: label 'A circular reference in %1 has been detected:\';
        TransferRoute: Record "Transfer Route";
        Item: Record Item;
        FromLocation: Code[10];
        ErrorString: Text[80];
        Text7380: label 'If you change the %1, the %2 is calculated.\Do you still want to change the %1?';
        Text7381: label 'Cancelled.';

    local procedure TransferRouteExists(TransferFromCode: Code[10]; TransferToCode: Code[10]): Boolean
    begin
        TransferRoute.SetRange("Transfer-from Code", TransferFromCode);
        TransferRoute.SetRange("Transfer-to Code", TransferToCode);
        exit(not TransferRoute.IsEmpty);
    end;


    procedure UpdateTransferLevels(FromGlobalSKU: Record "General Stockkeeping Unit"): Boolean
    var
        ToGlobalSKU: Record "General Stockkeeping Unit";
    begin
        ToGlobalSKU.SetCurrentkey("Replenishment System", "Vendor No.", "Transfer-from Code");
        ToGlobalSKU.SetRange("Replenishment System", "replenishment system"::Transfer);
        ToGlobalSKU.SetRange("Transfer-from Code", FromGlobalSKU."Location Code");
        ToGlobalSKU.SetRange("Item Category Code", FromGlobalSKU."Item Category Code");
        if ToGlobalSKU.FindSet(true, false) then
            repeat
                if ToGlobalSKU."Location Code" = FromLocation then begin
                    ErrorString := ToGlobalSKU."Location Code";
                    exit(false);
                end;
                ToGlobalSKU."Transfer-Level Code" := FromGlobalSKU."Transfer-Level Code" - 1;
                ToGlobalSKU.Modify;
                if not UpdateTransferLevels(ToGlobalSKU) then begin
                    if (StrLen(ErrorString) + StrLen(ToGlobalSKU."Location Code")) >
                       (MaxStrLen(ErrorString) - 9)
                    then begin
                        ErrorString := ErrorString + ' ->...';
                        ShowLoopError;
                    end;
                    ErrorString := ErrorString + ' ->' + ToGlobalSKU."Location Code";
                    exit(false);
                end;
            until ToGlobalSKU.Next = 0;
        exit(true);
    end;


    procedure ShowLoopError()
    begin
        Error(
          Text006 +
          '%2 ->%3 ->%4',
          FieldCaption("Transfer-from Code"),
          ErrorString,
          "Location Code",
          "Transfer-from Code");
    end;


    procedure UpdateTempSKUTransferLevels(FromGlobalSKU: Record "General Stockkeeping Unit"; var ToGlobalSKU: Record "General Stockkeeping Unit" temporary; FromLocationCode: Code[10]): Boolean
    begin
        // Used by the planning engine to update the transfer level codes on a temporary SKU record set
        // generated based on actual transfer orders.

        ToGlobalSKU.Reset;
        ToGlobalSKU.SetCurrentkey("Item Category Code", "Location Code");
        ToGlobalSKU.SetRange("Transfer-from Code", FromGlobalSKU."Location Code");
        ToGlobalSKU.SetRange("Item Category Code", FromGlobalSKU."Item Category Code");
        if ToGlobalSKU.FindSet(true, false) then
            repeat
                if ToGlobalSKU."Location Code" = FromLocationCode then begin
                    ErrorString := ToGlobalSKU."Location Code";
                    exit(false);
                end;
                ToGlobalSKU."Transfer-Level Code" := FromGlobalSKU."Transfer-Level Code" - 1;
                ToGlobalSKU.Modify;
                if not ToGlobalSKU.UpdateTempSKUTransferLevels(ToGlobalSKU, ToGlobalSKU, FromLocationCode) then begin
                    if (StrLen(ErrorString) + StrLen(ToGlobalSKU."Location Code")) >
                       (MaxStrLen(ErrorString) - 9)
                    then begin
                        ErrorString := ErrorString + ' ->...';
                        Error(
                          Text006 +
                          '%2 ->%3 ->%4',
                          FieldCaption("Transfer-from Code"),
                          ErrorString,
                          "Location Code",
                          "Transfer-from Code");
                    end;
                    ErrorString := ErrorString + ' ->' + ToGlobalSKU."Location Code";
                    exit(false);
                end;
            until ToGlobalSKU.Next = 0;
        exit(true);
    end;
}

