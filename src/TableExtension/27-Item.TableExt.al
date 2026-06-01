tableextension 25006009 "Item" extends "Item" //27
{
    // 07.04.2022 EB.KN 
    //   Added fields:
    //      "Market Recomended Sales Price"
    //      "MRSP Currency Code"
    //      "Item Price Group Code"
    //
    // 10.10.2018 EB.RC DE012WAE3-15
    //   Field modified - Discontinued
    // 
    // 31.08.2018 EB.P30 EDMS
    //   Added fields:
    //     25006770 "ABC Category"
    //     25006771 "Sales EntriesInteger"
    //     25006772 "Sales Return Entries"
    // 
    // 21.08.2018 EB EDMS
    //   Added field:
    //     25006750 "Returnable"
    //     25006760 "Discontinued"
    // 
    // 06.12.2017 EB.P7 #T007
    //   Removed field "Product Subgroup Code"
    // 
    // 05.06.2015 EB.P21 #T0047
    //   Modified function:
    //     FillItemGroupDefDim
    // 
    // 19.11.2014 EB.P8 EDMS
    //   Hotfix in GetSalesQty for multilanguage
    // 
    // 22.05.2014 EDMS P8
    //   * MERGE with last changes
    // 
    // 15.04.2013 EDMS P8
    //   * Removed ISSERVICETIER
    // 
    // 04.02.2013 EDMS P8
    //   * LOOKUP for fld "Qty. on Service Order EDMS"
    // 
    // 27.01.2010 EDMS P2
    //   * Added field "Item Price Group", "Item Category Code"-OnValidate
    // 
    // 22.10.2008. EDMS P2
    //   * Added code "Item Category Code - OnValidate()"
    // 
    // 09.07.08 EDMS P1 - EDMS Service Management integration
    //   * Added fields "Qty. on Service Order EDMS" and "Res. Qty. on Serv. Orders EDMS"
    // 
    // 03.09.2007. EDMS P2
    //   * Added code "Item Category Code - OnValidate()"
    // 
    // 05.07.2007. EDMS P2
    //   * Added function FillItemGroupDefDim
    //   * Added new code on triger Item Category Code - On Validate
    // 
    // 10.05.2007 EDMS P2
    fields
    {
        field(25006000; "EDMS Substitutes Exist"; Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE(Type = CONST(Item),
                                                           "No." = field("No."),
                                                           "Entry Type" = const(Substitution)));
            Caption = 'Substitutes Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Make;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006670; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
        field(25006671; "Replacement Status"; Option)
        {
            Caption = 'Replacement Status';
            OptionCaption = ' ,Is Being Replaced,Replaced';
            OptionMembers = " ",Replaced;
        }
        field(25006673; "Replacements Exist"; Boolean)
        {
            CalcFormula = exist("Item Substitution" where(Type = const("Nonstock Item"),
                                                           "No." = field("No."),
                                                           "Entry Type" = const(Replacement)));
            Caption = 'Replacements Exist';
            Description = 'P15';
            FieldClass = FlowField;
        }
        field(25006676; "Qty. on Service Order EDMS"; Decimal)
        {
            CalcFormula = sum("Service Line EDMS".Quantity where("Document Type" = const(Order),
                                                                  Type = const(Item),
                                                                  "No." = field("No."),
                                                                  "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                  "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                  "Location Code" = field("Location Filter"),
                                                                  "Variant Code" = field("Variant Filter")));
            Caption = 'Qty. on Service Order EDMS';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                ServiceLine: Record "Service Line EDMS";
                ServiceLinesPrep: Page "Posted Transf. Shpmnts (Serv.)";
                ServiceLinesPrepPage: Page "Service Lines Prep EDMS";
            begin
                //04.02.2013 EDMS P8 >>
                ServiceLine.Reset;
                ServiceLine.SetRange("Document Type", ServiceLine."document type"::Order);
                ServiceLine.SetRange(Type, ServiceLine.Type::Item);
                ServiceLine.SetRange("No.", "No.");
                ServiceLine.SetFilter("Shortcut Dimension 1 Code", "Global Dimension 1 Filter");
                ServiceLine.SetFilter("Shortcut Dimension 2 Code", "Global Dimension 2 Filter");
                ServiceLine.SetFilter("Location Code", "Location Filter");
                ServiceLine.SetFilter("Variant Code", "Variant Filter");
                Page.RunModal(Page::"Service Lines Prep EDMS", ServiceLine);  //15.04.2013 EDMS P8
                //04.02.2013 EDMS P8 <<
            end;
        }
        field(25006678; "Res. Qty. on Serv. Orders EDMS"; Decimal)
        {
            CalcFormula = - sum("Reservation Entry"."Quantity (Base)" where("Item No." = field("No."),
                                                                            "Source Type" = const(25006146),
                                                                            "Source Subtype" = const(1),
                                                                            "Reservation Status" = const(Reservation),
                                                                            "Location Code" = field("Location Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Shipment Date" = field("Date Filter")));
            Caption = 'Res. Qty. on Serv. Orders EDMS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006679; "Market Recomended Sales Price"; Decimal)
        {
            Caption = 'Market Recomended Sales Price';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(25006680; "MRSP Currency Code"; Code[10])
        {
            AutoFormatType = 1;
            Caption = 'Market Recomended Sales Price Currency Code';
            TableRelation = Currency;
        }
        field(25006690; "Exchange Unit"; Boolean)
        {
            Caption = 'Exchange Unit';

            trigger OnValidate()
            var
                recNonstockItem: Record "Nonstock Item";
            begin
            end;
        }
        field(25006750; Returnable; Boolean)
        {
        }
        field(25006760; Discontinued; Boolean)
        {
            CalcFormula = exist("Item Substitution" where("No." = field("Nonstock Entry No."),
                                                           "Entry Type" = const(Discontinued),
                                                           Type = const("Nonstock Item")));
            Caption = 'Discontinued';
            FieldClass = FlowField;
        }
        field(25006770; "ABC Category"; Enum "Item ABC Category")
        {
            Caption = 'ABC Category';
            DataClassification = ToBeClassified;
        }
        field(25006771; "Sales Entries"; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Entry Type" = const(Sale),
                                                           "Document Type" = filter("Sales Shipment" | "Sales Invoice"),
                                                           "Item No." = field("No."),
                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                           "Location Code" = field("Location Filter"),
                                                           "Variant Code" = field("Variant Filter"),
                                                           "Posting Date" = field("Date Filter")));
            Caption = 'Sales Entries';
            FieldClass = FlowField;
        }
        field(25006772; "Sales Return Entries"; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Entry Type" = const(Sale),
                                                           "Document Type" = filter("Sales Return Receipt" | "Sales Credit Memo"),
                                                           "Item No." = field("No."),
                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                           "Location Code" = field("Location Filter"),
                                                           "Variant Code" = field("Variant Filter"),
                                                           "Posting Date" = field("Date Filter")));
            Caption = 'Sales Return Entries';
            FieldClass = FlowField;
        }
        field(25006773; "Nonstock Entry No."; Code[20])
        {
            CalcFormula = lookup("Nonstock Item"."Entry No." where("Item No." = field("No.")));
            FieldClass = FlowField;
        }
        field(25006900; "Item Price Group Code"; Code[10])
        {
            Caption = 'Item Price Group Code';
            TableRelation = "Item Price Group";
        }
    }
    keys
    {
        key(Key19; "Item Type")
        {
        }
        key(Key20; "Item Type", "Make Code", "Model Code")
        {
        }
    }
    var
        NewEntry: Boolean;
        NonstockItem: Record "Nonstock Item";

    procedure SetNewEntryVariable(IsNew: Boolean)
    begin
        NewEntry := IsNew;
    end;

    procedure GetNewEntryVariable(): Boolean
    begin
        exit(NewEntry);
    end;

    procedure CalcServiceReturnEDMS(): Decimal
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        ServiceLine.SetCurrentkey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Planned Service Date");
        ServiceLine.SetRange("Document Type", ServiceLine."document type"::"Return Order");
        ServiceLine.SetRange(Type, ServiceLine.Type::Item);
        ServiceLine.SetRange("No.", "No.");
        ServiceLine.SetFilter("Location Code", GetFilter("Location Filter"));
        ServiceLine.SetFilter("Drop Shipment", GetFilter("Drop Shipment Filter"));
        ServiceLine.SetFilter("Variant Code", GetFilter("Variant Filter"));
        ServiceLine.SetRange("Planned Service Date", GetRangeMin("Date Filter"), GetRangemax("Date Filter"));
        ServiceLine.CalcSums("Outstanding Qty. (Base)");
        exit(ServiceLine."Outstanding Qty. (Base)");
    end;


    procedure ShowItemVehicleModels()
    var
        ItemVehicleModel: Record "Item Vehicle Model";
    begin
        ItemVehicleModel.SetRange(Type, ItemVehicleModel.Type::Item);
        ItemVehicleModel.SetRange("No.", "No.");
        if (not ItemVehicleModel.FindFirst) and "Created From Nonstock Item" then begin
            ItemVehicleModel.Reset;
            NonstockItem.SetRange("Item No.", "No.");
            if NonstockItem.FindFirst then begin
                ItemVehicleModel.SetRange(Type, ItemVehicleModel.Type::"Nonstock Item");
                ItemVehicleModel.SetRange("No.", NonstockItem."Entry No.");
            end;
        end;
        Page.Run(Page::"Item Vehicle Models", ItemVehicleModel);
    end;


    procedure GetSalesQty(Criteria: Decimal): Decimal
    var
        datStartingDate: Date;
        datEndingDate: Date;
    begin
        datStartingDate := Dmy2date(1);
        //19.11.2014 EB.P8 EDMS >>
        //datEndingDate := CALCDATE('-1D',CALCDATE('+1M',datStartingDate));
        datEndingDate := CalcDate('<-1D>', CalcDate('<+1M>', datStartingDate));
        if Criteria <> 0 then begin
            datStartingDate := CalcDate('<' + Format(Criteria) + 'M>', datStartingDate);
            datEndingDate := CalcDate('<' + Format(Criteria) + 'M>', datEndingDate);
        end;
        //19.11.2014 EB.P8 EDMS >>

        // 01.04.2014 Elva Baltic P21 >>
        // SETRANGE("Date Filter",datStartingDate,datEndingDate);
        Reset;
        SetFilter("Date Filter", '%1..%2', datStartingDate, datEndingDate);
        // 01.04.2014 Elva Baltic P21 <<

        CalcFields("Sales (Qty.)");
        exit("Sales (Qty.)");
    end;


    procedure GetSourceNonstockEntryNo() RetVal: Code[20]
    var
        NonstockItem: Record "Nonstock Item";
    begin
        if not "Created From Nonstock Item" then
            exit(RetVal);

        NonstockItem.SetRange("Item No.", "No.");
        if NonstockItem.FindFirst then
            RetVal := NonstockItem."Entry No.";

        exit(RetVal);
    end;


    procedure FillItemCategoryDim()
    var
        DefaultDim: Record "Default Dimension";
        NewDefDim: Record "Default Dimension";
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        if "Item Category Code" = '' then
            exit;

        DefaultDim.Reset;
        DefaultDim.SetRange("Table ID", Database::"Item Category");
        DefaultDim.SetRange("No.", "Item Category Code");
        if DefaultDim.Find('-') then
            repeat
                //14.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                NewDefDim.Reset;
                NewDefDim.SetRange("Table ID", Database::Item);
                NewDefDim.SetRange("No.", "No.");
                NewDefDim.SetRange("Dimension Code", DefaultDim."Dimension Code");
                if NewDefDim.FindFirst then
                    NewDefDim.Delete(true);
                NewDefDim.Reset;
                //14.04.2014 Elva Baltic P1 #RX MMG7.00 <<
                NewDefDim.Init;
                NewDefDim.TransferFields(DefaultDim);
                NewDefDim."Table ID" := Database::Item;
                NewDefDim."No." := "No.";
                NewDefDim.Insert(true);
            until DefaultDim.Next = 0;
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;


    procedure NonstockRepleacementExists(ItemNoPar: Code[20]) RetVal: Boolean
    var
        Item1: Record Item;
        ItemSubst1: Record "Item Substitution";
        NonstockEntryNo: Code[20];
    begin
        if not Item1.Get(ItemNoPar) then
            exit(RetVal);

        NonstockEntryNo := Item1.GetSourceNonstockEntryNo();
        if NonstockEntryNo <> '' then begin
            ItemSubst1.Reset;
            ItemSubst1.SetRange(Type, ItemSubst1.Type::"Nonstock Item");
            ItemSubst1.SetRange("No.", NonstockEntryNo);  //try to find by "No."
                                                          //ItemSubst1.SETRANGE("Variant Code", '');
                                                          // 30.06.2014 Elva Baltic P15 #F124 MMG7.00 >>
            if ItemSubst1.FindFirst then
                RetVal := true
            else
                ItemSubst1.SetRange("No.");
            ItemSubst1.SetRange("Substitute No.", NonstockEntryNo); //try to find by "Substitute No."
            //ItemSubst1.SETRANGE("Variant Code", '');
            if ItemSubst1.FindFirst then
                RetVal := true;
            // 30.06.2014 Elva Baltic P15 #F124 MMG7.00 <<
        end;
    end;
}