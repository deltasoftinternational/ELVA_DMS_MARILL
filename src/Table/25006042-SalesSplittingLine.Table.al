Table 25006042 "Sales Splitting Line"
{
    Caption = 'Sales Line';
    DrillDownPageID = "Sales Lines";
    LookupPageID = "Sales Lines";
    PasteIsValid = false;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if "Temp. Document No." = GetSourceTempDocNo then
                    Error(Text008);
                GetCust("Sell-to Customer No.");
                if Cust."Bill-to Customer No." <> '' then
                    Validate("Bill-to Customer No.", Cust."Bill-to Customer No.")
                else begin
                    if "Bill-to Customer No." = "Sell-to Customer No." then
                        SkipBillToContact := true;
                    Validate("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := false;
                end;
                UpdateLines(FieldCaption("Sell-to Customer No."), CurrFieldNo <> 0);
            end;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." where("Document Type" = field("Document Type"));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",,"External Service";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item),
                                     "Line Type" = const(Vehicle)) Item where("Item Type" = const("Model Version"))
            else
            if (Type = const(Item),
                                              "Line Type" = filter(<> Vehicle)) Item where("Item Type" = filter(" " | Item))
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const("External Service")) "External Service";

            trigger OnValidate()
            var
                SalesSetup: Record "Sales & Receivables Setup";
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
            begin
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                NewLocationCode: Code[20];
            begin
            end;
        }
        field(8; "Temp. Document No."; Integer)
        {

            trigger OnValidate()
            begin
                if "Temp. Document No." = 0 then begin
                    //  SalesSplittingLine := Rec;

                    if Line then begin
                        if "Document No." = '' then begin
                            SalesSplittingLine.Reset;
                            if SalesSplittingLine.FindLast then begin
                                "Document No." := SalesSplittingLine."Document No.";
                                "Temp. Document No." := SalesSplittingLine."Temp. Document No.";
                            end;
                        end else begin
                            SalesSplittingLine.Reset;
                            //SalesSplittingLine.SETRANGE(Line, FALSE);
                            SalesSplittingLine.SetRange("Document Type", "Document Type");
                            SalesSplittingLine.SetRange("Document No.", "Document No.");
                            if SalesSplittingLine.FindLast then
                                "Temp. Document No." := SalesSplittingLine."Temp. Document No.";
                        end;
                    end else begin
                        if "Document No." = '' then begin
                            SalesSplittingLine.Reset;
                            if SalesSplittingLine.FindLast then begin
                                "Document No." := SalesSplittingLine."Document No.";
                            end;
                        end;
                        SalesSplittingLine.Reset;
                        //SalesSplittingLine.SETRANGE(Line, FALSE);
                        SalesSplittingLine.SetRange("Document Type", "Document Type");
                        SalesSplittingLine.SetRange("Document No.", "Document No.");
                        if SalesSplittingLine.FindLast then
                            "Temp. Document No." := SalesSplittingLine."Temp. Document No.";
                        "Temp. Document No." += 10000;
                    end;
                    if "Temp. Document No." = 0 then
                        "Temp. Document No." := 10000;
                end;
            end;
        }
        field(9; "Temp. Line No."; Integer)
        {

            trigger OnValidate()
            begin
                if "Temp. Line No." = 0 then begin
                    SalesSplittingLine.Reset;
                    SalesSplittingLine.SetRange("Document Type", "Document Type");
                    SalesSplittingLine.SetRange("Document No.", "Document No.");
                    SalesSplittingLine.SetRange("Temp. Document No.", "Temp. Document No.");
                    if SalesSplittingLine.FindLast then
                        "Temp. Line No." := SalesSplittingLine."Temp. Line No.";
                    "Temp. Line No." += 10000;
                end;
            end;
        }
        field(10; Line; Boolean)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
            end;
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(12; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(13; "Unit of Measure"; Text[10])
        {
            Caption = 'Unit of Measure';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
            end;
        }
        field(29; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(30; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(68; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if "Temp. Document No." = GetSourceTempDocNo then
                    Error(Text008);
                GetCust("Bill-to Customer No.");
                "Currency Code" := Cust."Currency Code";
                UpdateLines(FieldCaption("Bill-to Customer No."), CurrFieldNo <> 0);
            end;
        }
        field(91; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(7160; "Quantity Share %"; Decimal)
        {
            Caption = 'Quantity Share %';
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Line Type" = "line type"::Vehicle then
                    if not (("Quantity Share %" = 0) or ("Quantity Share %" = 100)) then
                        Error(Text105, TableCaption, Format("Document Type") + ', ' + Format("Document No.") + ', ' + Format("Temp. Document No.") + ', ' + Format(Line) + ', ' + Format("Temp. Line No."),
                         FieldCaption("Quantity Share %"));
                "New Quantity" := ROUND(Quantity * "Quantity Share %" / 100, 0.00001);
                DecimalTemp := ROUND(Quantity * "Quantity Share %" / 100, 0.00001);
                if "Quantity Share %" > 0 then begin
                    "Amount Share %" := 0;
                    "New Amount" := 0;
                end;
                UpdateLines(FieldCaption("Quantity Share %"), CurrFieldNo <> 0);
            end;
        }
        field(7170; "New Quantity"; Decimal)
        {
            Caption = 'New Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if Quantity > 0 then
                    Validate("Quantity Share %", ROUND(100 * "New Quantity" / Quantity, 0.00001))
                else
                    Validate("Quantity Share %", 0);
            end;
        }
        field(7180; "Amount Share %"; Decimal)
        {
            Caption = 'Amount Share';
            MinValue = 0;

            trigger OnValidate()
            begin
                //logic taken from Sales Line:
                GetHeader;
                "New Amount" := ROUND(Amount * "Amount Share %" / 100, Currency."Amount Rounding Precision");
                if "Amount Share %" > 0 then begin
                    "Quantity Share %" := 0;
                    "New Quantity" := 0;
                end;
                UpdateLines(FieldCaption("Amount Share %"), CurrFieldNo <> 0);
            end;
        }
        field(7190; "New Amount"; Decimal)
        {
            Caption = 'New Amount';
            MinValue = 0;

            trigger OnValidate()
            begin
                if Amount > 0 then begin
                    GetHeader;
                    Validate("Amount Share %", ROUND(100 * "New Amount" / Amount, Currency."Amount Rounding Precision"));
                end else
                    Validate("Amount Share %", 0);
            end;
        }
        field(7200; "New Document No."; Code[20])
        {
            Caption = 'New Document No.';
            Description = 'supposed to be filled only at processing';
        }
        field(7210; Include; Boolean)
        {
            Caption = 'Include';

            trigger OnValidate()
            begin
                if Include then begin
                    Validate("New Quantity", Quantity);
                    ChangeIncludeInfo(0);
                end else begin
                    Validate("New Quantity", 0);
                    ChangeIncludeInfo(Quantity);
                end;
            end;
        }
        field(25006372; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset";

            trigger OnValidate()
            var
                cuDocMgtDMS: Codeunit DocumentManagementDMS;
            begin
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Temp. Document No.", Line, "Temp. Line No.")
        {
            Clustered = true;
        }
        key(Key2; Line, "Document Type", "Document No.", "Temp. Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "Capable to Promise";
        ItemJnlLine: Record "Item Journal Line";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        DealApplEntry: Record "Deal Application Entry";
        SalesCommentLine: Record "Sales Comment Line";
        DealApplType: Record "Deal Application Type";
    begin
        if not Line then begin
            SalesSplittingLine.Reset;
            SalesSplittingLine.SetRange(Line, true);
            SalesSplittingLine.SetRange("Document Type", "Document Type");
            SalesSplittingLine.SetRange("Document No.", "Document No.");
            SalesSplittingLine.SetRange("Temp. Document No.", "Temp. Document No.");
            SalesSplittingLine.DeleteAll;
        end;
    end;

    trigger OnInsert()
    var
        SalesHeader2: Record "Sales Header";
    begin
        Validate("Temp. Document No.");
        Validate("Temp. Line No.");
    end;

    trigger OnModify()
    var
        DealApplEntry: Record "Deal Application Entry";
        DealApplType: Record "Deal Application Type";
    begin
    end;

    var
        SalesSplittingLine: Record "Sales Splitting Line";
        SalesSplittingHeader: Record "Sales Splitting Line";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        DecimalTemp: Decimal;
        SalesHeader: Record "Sales Header";
        Cust: Record Customer;
        SkipBillToContact: Boolean;
        Text0001: label 'Would you like to copy that value to lines?';
        Text0002: label 'There is problem no initialise %1.';
        Text0003: label 'There is nothing to process.';
        Text0004: label 'Is not possible to find %1 record with %2.';
        Text007: label 'Exist Service Labor Allocation entry, which is not finished.';
        Text008: label 'The field in that record is not allowed modify.';
        Text031: label 'You have modified %1.\\';
        Text032: label 'Do you want to update the lines?';
        Text103: label 'Would you like to delete created split prepare lines?';
        Text104: label 'There is difference in amounts: in source document %1 %3, in split %2 %3. Are you sure to continue?';
        Text105: label '%1 with %2 value for field %3 could be only 0 or 100.';

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        PricesIncVar: Integer;
        SalesHeaderLoc: Record "Sales Header";
    begin
        if not SalesHeaderLoc.Get("Document Type", "Document No.") then begin
            SalesHeaderLoc."No." := '';
            SalesHeaderLoc.Init;
        end;
        if SalesHeaderLoc."Prices Including VAT" then
            PricesIncVar := 1
        else
            PricesIncVar := 0;
        Clear(SalesHeaderLoc);
        exit('2,' + Format(PricesIncVar) + ',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "Field";
    begin
        Field.Get(Database::"Sales Splitting Line", FieldNumber);
        exit(Field."Field Caption");
    end;


    procedure ApplyInsertAsWholeDoc()
    var
        SalesSplittingLineL: Record "Sales Splitting Line";
        TempDocNo: Integer;
    begin
        SalesSplittingLineL.Reset;
        SalesSplittingLineL.SetRange("Document Type", "Document Type");
        SalesSplittingLineL.SetRange("Document No.", "Document No.");
        SalesSplittingLineL.SetRange("Temp. Document No.", "Temp. Document No.");
        if SalesSplittingLineL.FindFirst then begin
            Validate("Temp. Document No.", 0);
            TempDocNo := "Temp. Document No.";
            repeat
                Init;
                TransferFields(SalesSplittingLineL);
                "Temp. Document No." := TempDocNo;
                Validate("Temp. Line No.", 0);
                Insert;
            until SalesSplittingLineL.Next = 0;
            SalesSplittingLineL.SetRange("Temp. Document No.", TempDocNo);
            SalesSplittingLineL.SetRange(Line, false);
            if SalesSplittingLineL.FindFirst then begin
                SalesSplittingLineL.Validate("Quantity Share %", 0);
                SalesSplittingLineL.Validate("Amount Share %", 0);
                SalesSplittingLineL.Modify;
            end;
        end;
    end;


    procedure ApplyInsertAsHeaderByDoc(DocType: Integer; DocNo: Code[20])
    var
        SalesHeaderL: Record "Sales Header";
        SalesLineL: Record "Sales Line";
        SalesSplittingLineL: Record "Sales Splitting Line";
        TempDocNo: Integer;
        TempLineNo: Integer;
    begin
        if SalesHeaderL.Get(DocType, DocNo) then begin
            SalesLineL.Reset;
            SalesLineL.SetRange("Document Type", SalesHeaderL."Document Type");
            SalesLineL.SetRange("Document No.", SalesHeaderL."No.");
            if SalesLineL.FindFirst then begin
                SalesSplittingLineL.Init;
                CopyFldsSalesH2SplitLine(SalesHeaderL, SalesSplittingLineL);
                SalesSplittingLineL.Validate(Line, false);
                SalesSplittingLineL.Validate("Line No.", 0);
                SalesSplittingLineL.Validate("Document Type", DocType);
                SalesSplittingLineL.Validate("Document No.", DocNo);
                SalesSplittingLineL.Validate("Temp. Document No.", 0);
                SalesSplittingLineL."Temp. Line No." := 0;
                SalesSplittingLineL.Insert(true);
                TempDocNo := SalesSplittingLineL."Temp. Document No.";
                repeat
                    SalesSplittingLineL.Init;
                    CopyFldsSalesL2SplitLine(SalesLineL, SalesSplittingLineL);
                    SalesSplittingLineL."Temp. Document No." := TempDocNo;
                    SalesSplittingLineL."Temp. Line No." := 0;
                    SalesSplittingLineL.Line := true;
                    if SalesSplittingLineL."Temp. Document No." = 10000 then
                        SalesSplittingLineL.Include := true;
                    SalesSplittingLineL.Insert(true);
                until SalesLineL.Next = 0;
                Get(SalesSplittingLineL."Document Type", SalesSplittingLineL."Document No.", SalesSplittingLineL."Temp. Document No.",
                  true, SalesSplittingLineL."Temp. Line No.");
            end;
        end;
    end;


    procedure ProceedDocSplit()
    var
        SalesHeaderL: Record "Sales Header";
        SalesHeaderL2: Record "Sales Header";
        SalesLineL: Record "Sales Line";
        SalesLineL2: Record "Sales Line";
        SalesLineDest: Record "Sales Line";
        SalesLineSourceTmp: Record "Sales Line" temporary;
        FirstTempDocumentNo: Integer;
        PreviousTempDocumentNo: Integer;
        MessageText: Text[250];
        Text101: label 'There are created additional documents with %1: %2';
        DocNoFilterString: Text[100];
        DocNoFilterString2: Text[100];
        SourceDocHours: Decimal;
        SplittingHeaderRecNo: Integer;
        SalesSplittingLineSource: Record "Sales Splitting Line";
        SalesSplittingLineDest: Record "Sales Splitting Line";
        ShareToAdjustQtySrc: Decimal;
        ShareToAdjustQtyDest: Decimal;
        ShareOfLineInAlloc: Decimal;
        NewDocNo: Code[20];
        NewLineNo: Integer;
        NewLineQtyShare: Decimal;
        SrcAmt: Decimal;
        DstAmt: Decimal;
        DiffAmt: Decimal;
        LoopCurrCnt: Integer;
        SeparateFunctPars: Text[30];
    begin
        //at first do compare values

        //prepare source Sales line
        SalesLineL.Reset;
        SalesLineL.SetRange("Document Type", "Document Type");
        SalesLineL.SetRange("Document No.", "Document No.");
        SalesLineSourceTmp.Reset;
        SalesLineSourceTmp.DeleteAll;
        if SalesLineL.FindFirst then
            repeat
                SalesLineSourceTmp := SalesLineL;
                SalesLineSourceTmp.Insert;
            until SalesLineL.Next = 0;

        if not SalesHeaderL.Get("Document Type", "Document No.") then
            Error(Text0002, SalesHeaderL.TableCaption);

        SalesSplittingHeader.Reset;
        SalesSplittingHeader.SetRange(Line, false);
        SalesSplittingHeader.SetRange("Document Type", "Document Type");
        SalesSplittingHeader.SetRange("Document No.", "Document No.");

        // that part creates all "Sales Header EDMS" + "Sales Line EDMS"
        // and put correcr quantities
        SalesSplittingLine.Reset;
        SalesSplittingLine.SetRange(Line, true);
        SalesSplittingLine.SetRange("Document Type", "Document Type");
        SalesSplittingLine.SetRange("Document No.", "Document No.");
        if not SalesSplittingLine.FindFirst then
            Error(Text0003);
        FirstTempDocumentNo := SalesSplittingLine."Temp. Document No.";
        PreviousTempDocumentNo := FirstTempDocumentNo;
        DocNoFilterString := '''' + SalesSplittingLine."Document No." + '''';
        DocNoFilterString2 := ''; // it stores the same filter but only without original document
        repeat
            if FirstTempDocumentNo = SalesSplittingLine."Temp. Document No." then begin
                // just modify values of lines - for original document
                if not SalesLineL.Get(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
                    SalesSplittingLine."Line No.") then
                    Error(Text0004, SalesLineL.TableCaption, Format(SalesSplittingLine."Document Type") + ', ' +
                      SalesSplittingLine."Document No." + ', ' + Format(SalesSplittingLine."Line No."));
                SalesLineL.Validate(Quantity, SalesSplittingLine."New Quantity");
                SalesLineL.Modify;
                // modify allocation
            end else begin
                if PreviousTempDocumentNo <> SalesSplittingLine."Temp. Document No." then begin
                    // NEED CREATE HEADER RECORD AT FIRST
                    SalesHeaderL2.Init;
                    SalesHeaderL2.Validate("Document Type", SalesHeader."Document Type");
                    SalesHeaderL2.Validate("No.", '');
                    SalesHeaderL2.Insert(true);
                    SalesSplittingHeader.SetRange("Temp. Document No.", SalesSplittingLine."Temp. Document No.");
                    SalesSplittingHeader.FindFirst;
                    SalesSplittingHeader."New Document No." := SalesHeaderL2."No.";
                    SalesSplittingHeader.Modify;

                    SalesHeaderL2.TransferFields(SalesHeaderL, false);
                    if SalesHeaderL."Posting No." <> '' then
                        SalesHeaderL2.Validate("Posting No.", SalesHeaderL2."No.");

                    SalesHeaderL2."No." := SalesSplittingHeader."New Document No.";
                    if SalesHeaderL."Sell-to Customer No." <> SalesSplittingHeader."Sell-to Customer No." then begin
                        SalesHeaderL2."Sell-to Customer No." := '';
                        SalesHeaderL2."Bill-to Customer No." := '';
                        SalesHeaderL2.Validate("Sell-to Customer No.", SalesSplittingHeader."Sell-to Customer No.");
                    end;
                    if SalesHeaderL2."Bill-to Customer No." <> SalesSplittingHeader."Bill-to Customer No." then begin
                        SalesHeaderL2."Bill-to Customer No." := '';
                        SalesHeaderL2.Validate("Bill-to Customer No.", SalesSplittingHeader."Bill-to Customer No.");
                    end;
                    if SalesHeaderL."Currency Code" <> SalesSplittingHeader."Currency Code" then begin
                        SalesHeaderL2."Currency Code" := '';
                        SalesHeaderL2.Validate("Currency Code", SalesSplittingHeader."Currency Code");
                    end;
                    SalesHeaderL2.Modify(true);
                    PreviousTempDocumentNo := SalesSplittingLine."Temp. Document No.";
                    if MessageText <> '' then
                        MessageText += ', ';
                    MessageText += Format(SalesHeaderL2."No.");
                    DocNoFilterString += '|''' + SalesHeaderL2."No." + '''';
                    if DocNoFilterString2 <> '' then
                        DocNoFilterString2 += '|';
                    DocNoFilterString2 += '''' + SalesHeaderL2."No." + '''';
                end;
                // create lines
                if not SalesLineL.Get(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
                    SalesSplittingLine."Line No.") then
                    Error(Text0004, SalesLineL.TableCaption, Format(SalesSplittingLine."Document Type") + ', ' +
                      SalesSplittingLine."Document No." + ', ' + Format(SalesSplittingLine."Line No."));
                if //(SalesSplittingLine.Type = 0) OR
                   //(SalesSplittingLine."New Quantity" <> 0)
                  SalesSplittingLine.Include
                then begin
                    SalesLineL2.Init;
                    SalesLineL2.TransferFields(SalesLineL, false);
                    SalesLineL2."Document Type" := SalesSplittingHeader."Document Type";
                    SalesLineL2."Document No." := SalesSplittingHeader."New Document No.";
                    SalesLineL2."Line No." := SalesSplittingLine."Line No.";
                    SalesLineL2."Sell-to Customer No." := SalesSplittingHeader."Sell-to Customer No.";
                    SalesLineL2."Bill-to Customer No." := SalesSplittingHeader."Bill-to Customer No.";
                    SalesLineL2."Currency Code" := SalesSplittingHeader."Currency Code";
                    //SalesLineL2.VALIDATE("No.", SalesLineL."No.");
                    //SalesLineL2.VALIDATE("Location Code", SalesSplittingLine."Location Code");
                    SalesLineL2.Validate(Quantity, SalesSplittingLine."New Quantity");
                    //SalesLine2.VALIDATE("Unit Price", SalesSplittingLine."Unit Price");
                    SalesLineL2.Description := SalesSplittingLine.Description;
                    SalesLineL2.Insert(true);
                    // set doc link to new created
                    SalesSplittingLine."New Document No." := SalesSplittingHeader."New Document No.";
                    SalesSplittingLine.Modify;
                end;
            end;
        until SalesSplittingLine.Next = 0;
        SalesSplittingHeader.SetRange("Temp. Document No.");
        // adjust reservations
        if SalesSplittingLine.FindFirst then begin
            SalesLineL.Reset;
            SalesLineL.SetRange("Document Type", SalesSplittingLine."Document Type");
            SalesLineL.SetFilter("Document No.", DocNoFilterString);
            SalesLineL.SetRange(Type, SalesSplittingLine.Type::Item);
            if SalesLineL.FindFirst then begin
                repeat
                    if SalesLineL."Document No." <> SalesSplittingLine."Document No." then
                        // do not proceed line of original document
                        if SalesLineL.Reserve <> SalesLineL.Reserve::Never then  //02.07.2013 EDMS P8
                            SalesLineL.AutoReserve;
                until SalesLineL.Next = 0;
            end;
        end;

        // delete lines with 0 Quantity in original Doc.
        SalesLineL.Reset;
        SalesLineL.SetRange("Document Type", SalesSplittingLine."Document Type");
        SalesLineL.SetFilter("Document No.", "Document No.");
        SalesLineL.SetFilter(Type, '<>0');
        SalesLineL.SetRange(Quantity, 0);
        if SalesLineL.FindFirst then
            repeat
                SalesLineL.Delete(true);
            until SalesLineL.Next = 0;

        Message(Text101, SalesHeaderL2.FieldCaption("No."), MessageText);
        DeleteDocSplit;
    end;


    procedure DeleteDocSplit()
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceHeader2: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceLine2: Record "Service Line EDMS";
        FirstTempDocumentNo: Integer;
        LastTempDocumentNo: Integer;
    begin
        SalesSplittingLine.Reset;
        SalesSplittingLine.SetRange(Line, false);
        SalesSplittingLine.SetRange("Document Type", "Document Type");
        SalesSplittingLine.SetRange("Document No.", "Document No.");
        SalesSplittingLine.DeleteAll(true);
    end;

    local procedure GetHeader()
    begin
        TestField("Document No.");
        if SalesSplittingHeader.Line or ("Document Type" <> SalesSplittingHeader."Document Type") or
            ("Temp. Document No." <> SalesSplittingHeader."Temp. Document No.") then begin
            SalesSplittingHeader.SetRange(Line, false);
            SalesSplittingHeader.SetRange("Document Type", "Document Type");
            SalesSplittingHeader.SetRange("Temp. Document No.", "Temp. Document No.");
            if SalesSplittingHeader.FindFirst then
                Currency.InitRoundingPrecision
            else begin
                if SalesSplittingHeader."Currency Code" = '' then
                    Currency.InitRoundingPrecision
                else begin
                    //SalesSplittingHeader.TESTFIELD("Currency Factor");
                    Currency.Get(SalesSplittingHeader."Currency Code");
                    Currency.TestField("Amount Rounding Precision");
                end;
            end;
        end;
    end;


    procedure GetSourceTempDocNo(): Integer
    var
        ServiceSplittingLine: Record "Service Splitting Line";
    begin
        SalesSplittingLine.SetRange("Document Type", "Document Type");
        SalesSplittingLine.SetRange("Document No.", "Document No.");
        SalesSplittingLine.SetRange(Line, false);
        SalesSplittingLine.FindFirst;
        exit(SalesSplittingLine."Temp. Document No.");
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        if not (("Document Type" = "document type"::Quote) and (CustNo = '')) then begin
            if CustNo <> Cust."No." then
                Cust.Get(CustNo);
        end else
            Clear(Cust);
    end;


    procedure UpdateLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        ChangeLogMgt: Codeunit "Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        Question: Text[250];
    begin
        if Line then exit;
        if not (ChangedFieldName in
          [FieldCaption("Sell-to Customer No."),
          FieldCaption("Location Code"),
          FieldCaption("Bill-to Customer No."),
          FieldCaption("Currency Code"),
          FieldCaption("Quantity Share %")]) then
            exit;

        if AskQuestion then begin
            Question := StrSubstNo(
                Text031 +
                Text032, ChangedFieldName);
            if GuiAllowed then
                if not Dialog.Confirm(Question, true) then
                    exit;
        end;

        SalesSplittingLine.LockTable;
        SalesSplittingLine.Reset;
        SalesSplittingLine.SetRange(Line, true);
        SalesSplittingLine.SetRange("Document Type", "Document Type");
        SalesSplittingLine.SetRange("Document No.", "Document No.");
        SalesSplittingLine.SetRange("Temp. Document No.", "Temp. Document No.");
        if SalesSplittingLine.FindSet then
            repeat
                case ChangedFieldName of
                    FieldCaption("Sell-to Customer No."):
                        SalesSplittingLine.Validate("Sell-to Customer No.", "Sell-to Customer No.");
                    FieldCaption("Location Code"):
                        SalesSplittingLine.Validate("Location Code", "Location Code");
                    FieldCaption("Bill-to Customer No."):
                        SalesSplittingLine.Validate("Bill-to Customer No.", "Bill-to Customer No.");
                    FieldCaption("Currency Code"):
                        SalesSplittingLine.Validate("Currency Code", "Currency Code");
                    FieldCaption("Quantity Share %"):
                        SalesSplittingLine.Validate("Quantity Share %", "Quantity Share %");
                end;
                SalesSplittingLine.Modify(true);
            until SalesSplittingLine.Next = 0;
    end;


    procedure CreateSplitingForDoc(var SalesHeaderPar: Record "Sales Header")
    begin
        SalesSplittingLine.Reset;
        SalesSplittingLine.SetRange(Line, false);
        SalesSplittingLine.SetRange("Document Type", SalesHeaderPar."Document Type");
        SalesSplittingLine.SetRange("Document No.", SalesHeaderPar."No.");
        if not SalesSplittingLine.FindFirst then
            ApplyInsertAsHeaderByDoc(SalesHeaderPar."Document Type".AsInteger(), SalesHeaderPar."No.");
        if SalesSplittingLine.Count < 2 then begin
            ApplyInsertAsHeaderByDoc(SalesHeaderPar."Document Type".AsInteger(), SalesHeaderPar."No.");
            DocsShareMakeFirstFull;
        end;
        if SalesSplittingLine.FindFirst then begin
            Get(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
              SalesSplittingLine."Temp. Document No.", SalesSplittingLine.Line, SalesSplittingLine."Temp. Line No.");
        end;
    end;


    procedure CreateSpliting()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        Evaluate("Document Type", GetFilter("Document Type"));
        "Document No." := GetFilter("Document No.");
        SalesHeader.Get("Document Type", "Document No.");
        CreateSplitingForDoc(SalesHeader);
    end;


    procedure DocsShareMakeEqual()
    var
        RecCount: Integer;
        TotalUsedPercent: Decimal;
    begin
        if SalesSplittingLine.FindFirst then begin
            RecCount := SalesSplittingLine.Count;
            TotalUsedPercent := 0;
            repeat
                SalesSplittingLine.Validate("Quantity Share %", ROUND(100 / RecCount, 0.01));
                SalesSplittingLine.Modify;
                TotalUsedPercent += SalesSplittingLine."Quantity Share %";
            until SalesSplittingLine.Next = 0;
            if TotalUsedPercent <> 100 then begin
                SalesSplittingLine.FindLast;
                SalesSplittingLine.Validate("Quantity Share %", SalesSplittingLine."Quantity Share %" + (100 - TotalUsedPercent));
                SalesSplittingLine.Modify;
            end;
        end;
    end;


    procedure DocsShareMakeFirstFull()
    var
        RecCount: Integer;
        TotalUsedPercent: Decimal;
    begin
        if SalesSplittingLine.FindFirst then begin
            RecCount := SalesSplittingLine.Count;
            SalesSplittingLine.Validate("Quantity Share %", 100);
            SalesSplittingLine.Modify;
            if SalesSplittingLine.Next <> 0 then
                repeat
                    SalesSplittingLine.Validate("Quantity Share %", 0);
                    SalesSplittingLine.Modify;
                until SalesSplittingLine.Next = 0;
        end;
    end;


    procedure OpenFormForDoc(var SalesHeaderPar: Record "Sales Header")
    var
        FormRunResult: action;
    begin
        SetRange(Line, false);
        SetRange("Document Type", SalesHeaderPar."Document Type");
        SetRange("Document No.", SalesHeaderPar."No.");
        Page.Run(Page::"Sales Splitting", Rec);
        //FormRunResult := PAGE.RUNMODAL(PAGE::"Sales Splitting", Rec);
        //SETRANGE(Line, FALSE);
        //SETRANGE("Document Type", SalesHeaderPar."Document Type");
        //SETRANGE("Document No.", SalesHeaderPar."No.");

        //IF FINDFIRST THEN
        //IF FormRunResult IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
        //ProceedDocSplit;
        //  END ELSE
        //  IF CONFIRM(Text103, TRUE) THEN BEGIN
        //  DeleteDocSplit;
        //END;
    end;


    procedure CheckDocTotalAmount(var SourceDocAmount: Decimal; var DestDocAmount: Decimal) AmountDiff: Decimal
    var
        SalesHeaderTmp: Record "Sales Header" temporary;
        SalesLineTmp: Record "Sales Line" temporary;
        SalesLineL: Record "Sales Line";
        CurrLineNo: Integer;
        LinesCount: Integer;
    begin
        SourceDocAmount := 0;
        if SalesHeader.Get("Document Type", "Document No.") then begin
            SalesHeader.CalcFields(Amount);
            if SalesHeader."Currency Factor" = 0 then
                SalesHeader."Currency Factor" := 1;
            //  SourceDocAmount := ROUND(SalesHeader.Amount/SalesHeader."Currency Factor");
            SalesLineL.Reset;
            SalesLineL.SetRange("Document Type", SalesHeader."Document Type");
            SalesLineL.SetRange("Document No.", SalesHeader."No.");
            if SalesLineL.FindFirst then
                repeat
                    SourceDocAmount += ROUND(SalesLineL."Line Amount" / SalesHeader."Currency Factor");
                until SalesLineL.Next = 0;

            SalesHeaderTmp.Reset;
            SalesHeaderTmp.DeleteAll;
            SalesHeaderTmp := SalesHeader;
            SalesHeaderTmp.Insert;
            SalesLineTmp.Reset;
            SalesLineTmp.DeleteAll;

            SalesSplittingHeader.Reset;
            SalesSplittingHeader.SetRange(Line, false);
            SalesSplittingHeader.SetRange("Document Type", "Document Type");
            SalesSplittingHeader.SetRange("Document No.", "Document No.");
            SalesSplittingLine.Reset;
            SalesSplittingLine.SetRange(Line, true);
            SalesSplittingLine.SetRange("Document Type", "Document Type");
            SalesSplittingLine.SetRange("Document No.", "Document No.");
            if not SalesSplittingLine.FindFirst then
                Error(Text0003);
            LinesCount := SalesSplittingLine.Count;
            DestDocAmount := 0;
            CurrLineNo := 0;
            repeat
                if not SalesLineL.Get(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
                      SalesSplittingLine."Line No.") then
                    Error(Text0004, SalesLineL.TableCaption, Format(SalesSplittingLine."Document Type") + ', ' +
                      SalesSplittingLine."Document No." + ', ' + Format(SalesSplittingLine."Line No."));

                SalesSplittingHeader.SetRange("Temp. Document No.", SalesSplittingLine."Temp. Document No.");
                SalesSplittingHeader.FindFirst;

                SalesLineTmp.Init;
                SalesLineTmp.TransferFields(SalesLineL, false);
                SalesLineTmp."Document Type" := SalesSplittingHeader."Document Type";
                SalesLineTmp."Document No." := SalesSplittingHeader."Document No.";
                CurrLineNo += 10000;
                SalesLineTmp."Line No." := CurrLineNo;
                SalesLineTmp."Sell-to Customer No." := SalesSplittingHeader."Sell-to Customer No.";
                SalesLineTmp."Bill-to Customer No." := SalesSplittingHeader."Bill-to Customer No.";
                SalesLineTmp."Currency Code" := SalesSplittingHeader."Currency Code";
                //SalesLineTmp.VALIDATE("No.", SalesSplittingLine."No.");
                //SalesLineTmp.VALIDATE("Location Code", SalesSplittingLine."Location Code");
                SalesLineTmp.Validate(Quantity, SalesSplittingLine."New Quantity");
                SalesLineTmp.Insert(true);
                //    SalesLineTmp.MODIFY(TRUE);

                SalesHeaderTmp.Validate("Currency Code", SalesSplittingHeader."Currency Code");
                if SalesHeaderTmp."Currency Factor" = 0 then
                    SalesHeaderTmp."Currency Factor" := 1;

                DestDocAmount += ROUND(SalesLineTmp."Line Amount" / SalesHeaderTmp."Currency Factor");
            until SalesSplittingLine.Next = 0;
            AmountDiff := SourceDocAmount - DestDocAmount;
        end else
            Error(Text0004, SalesHeader.TableCaption, Format("Document Type") + ', ' + "Document No.");
        exit(AmountDiff);
    end;


    procedure CopyFldsSalesL2SplitLine(SalesLinePar: Record "Sales Line"; var SalesSplittingLinePar: Record "Sales Splitting Line"): Integer
    begin
        SalesSplittingLinePar."Document Type" := SalesLinePar."Document Type";
        SalesSplittingLinePar."Document No." := SalesLinePar."Document No.";
        SalesSplittingLinePar."Sell-to Customer No." := SalesLinePar."Sell-to Customer No.";
        SalesSplittingLinePar."Line No." := SalesLinePar."Line No.";
        SalesSplittingLinePar.Type := SalesLinePar.Type;
        SalesSplittingLinePar."No." := SalesLinePar."No.";
        SalesSplittingLinePar."Location Code" := SalesLinePar."Location Code";
        SalesSplittingLinePar.Description := SalesLinePar.Description;
        SalesSplittingLinePar."Description 2" := SalesLinePar."Description 2";
        SalesSplittingLinePar."Unit of Measure" := SalesLinePar."Unit of Measure";
        SalesSplittingLinePar.Quantity := SalesLinePar.Quantity;
        SalesSplittingLinePar.Amount := SalesLinePar.Amount;
        SalesSplittingLinePar."Amount Including VAT" := SalesLinePar."Amount Including VAT";
        SalesSplittingLinePar."Bill-to Customer No." := SalesLinePar."Bill-to Customer No.";
        SalesSplittingLinePar."Currency Code" := SalesLinePar."Currency Code";
        SalesSplittingLinePar."Dimension Set ID" := SalesLinePar."Dimension Set ID";
        SalesSplittingLinePar."Line Type" := SalesLinePar."Line Type";
        SalesSplittingLinePar.Include := false;
        exit(0);
    end;


    procedure CopyFldsSalesH2SplitLine(SalesHeaderPar: Record "Sales Header"; var SalesSplittingLinePar: Record "Sales Splitting Line"): Integer
    begin
        SalesSplittingLinePar.Init;
        SalesSplittingLinePar."Document Type" := SalesHeaderPar."Document Type";
        SalesSplittingLinePar."Document No." := SalesHeaderPar."No.";
        SalesSplittingLinePar."Sell-to Customer No." := SalesHeaderPar."Sell-to Customer No.";
        SalesSplittingLinePar."Line No." := 0;
        SalesSplittingLinePar."Location Code" := SalesHeaderPar."Location Code";
        SalesSplittingLinePar.Description := Description;
        SalesSplittingLinePar.Amount := SalesHeaderPar.Amount;
        SalesSplittingLinePar."Amount Including VAT" := SalesHeaderPar."Amount Including VAT";
        SalesSplittingLinePar."Bill-to Customer No." := SalesHeaderPar."Bill-to Customer No.";
        SalesSplittingLinePar."Currency Code" := SalesHeaderPar."Currency Code";
        SalesSplittingLinePar."Dimension Set ID" := SalesHeaderPar."Dimension Set ID";
        exit(0);
    end;


    procedure ChangeIncludeInfo(NewQty: Decimal)
    begin
        SalesSplittingLine.Reset;
        SalesSplittingLine.SetRange("Document Type", "Document Type");
        SalesSplittingLine.SetRange("Document No.", "Document No.");
        SalesSplittingLine.SetRange("Line No.", "Line No.");
        SalesSplittingLine.SetFilter("Temp. Document No.", '<>%1&<>%2', "Temp. Document No.", 0);
        SalesSplittingLine.SetRange(Include, Include);
        if SalesSplittingLine.FindFirst then begin
            SalesSplittingLine.Validate("New Quantity", NewQty);
            SalesSplittingLine.Include := not Include;
            SalesSplittingLine.Modify;
        end;
    end;
}

