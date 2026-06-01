Table 25006134 "Service Package"
{
    // 09.05.2008. EDMS P2
    //   * Added code Make Code - OnValidate

    Caption = 'Service Package';
    LookupPageID = "Service Package List";

    fields
    {
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;

            trigger OnValidate()
            var
                ServicePackageVersion: Record "Service Package Version";
            begin
                //09.05.2008. EDMS P2>>
                if "Make Code" <> xRec."Make Code" then begin
                    ServicePackageVersion.Reset;
                    ServicePackageVersion.SetRange("Package No.", "No.");
                    if ServicePackageVersion.FindFirst then
                        repeat
                            ServicePackageVersion.Validate("Make Code", "Make Code");
                            ServicePackageVersion.Modify;
                        until ServicePackageVersion.Next = 0;
                end;
                //09.05.2008. EDMS P2<<
            end;
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = CopyStr(UpperCase(xRec.Description), 1, 30)) or ("Search Description" = '') then
                    "Search Description" := CopyStr(Description, 1, 30);
            end;
        }
        field(40; "Search Description"; Code[30])
        {
            Caption = 'Search Description';
        }
        field(50; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(60; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
            TableRelation = "Service Labor Group".Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            begin
                if "Group Code" <> xRec."Group Code" then
                    Validate("Subgroup Code", '');
            end;
        }
        field(70; "Subgroup Code"; Code[10])
        {
            Caption = 'Subgroup Code';
            TableRelation = "Service Labor Subgroup".Code where("Group Code" = field("Group Code"),
                                                                 "Make Code" = field("Make Code"));
        }
        field(80; Comment; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = const("Service Package"),
                                                                   "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Free of Charge"; Boolean)
        {
            Caption = 'Free of Charge';
        }
        field(100; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(150; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(200; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Campaign Service Package,Service Package,Instruction';
            OptionMembers = "Campaign Service Package","Service Package",Instruction;
        }
        field(210; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(220; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(230; "Currency Code"; Code[10])
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
                        // RecreateSPLines(FIELDCAPTION("Currency Code"));
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(240; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdateSPLines(FieldCaption("Currency Factor"), false);
            end;
        }
        field(250; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
            begin
                /*
                
                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                  SalesLine.SETRANGE("Document Type","Document Type");
                  SalesLine.SETRANGE("Document No.","No.");
                  SalesLine.SETFILTER("Unit Price",'<>%1',0);
                  SalesLine.SETFILTER("VAT %",'<>%1',0);
                  IF SalesLine.FIND('-') THEN BEGIN
                    RecalculatePrice :=
                      CONFIRM(
                        STRSUBSTNO(
                          Text024 +
                          Text026,
                          FIELDCAPTION("Prices Including VAT"),SalesLine.FIELDCAPTION("Unit Price")),
                        TRUE);
                    SalesLine.SetSalesHeader(Rec);
                
                    IF "Currency Code" = '' THEN
                      Currency.InitRoundingPrecision
                    ELSE
                      Currency.GET("Currency Code");
                
                    REPEAT
                      SalesLine.TESTFIELD("Quantity Invoiced",0);
                      SalesLine.TESTFIELD("Prepmt. Amt. Inv.",0); //08-05-2007 EDMS P3 PREPMT
                      IF NOT RecalculatePrice THEN BEGIN
                        SalesLine."VAT Difference" := 0;
                        SalesLine.InitOutstandingAmount;
                        VehPriceMgt.UpdAssemblyHdrField(Rec,SalesLine,FIELDNO("Prices Including VAT"));   //23.11.2007 EDMS P3
                      END ELSE BEGIN
                        IF "Prices Including VAT" THEN BEGIN
                          SalesLine."Unit Price" :=
                            ROUND(
                              SalesLine."Unit Price" * (1 + (SalesLine."VAT %" / 100)),
                              Currency."Unit-Amount Rounding Precision");
                          IF SalesLine.Quantity <> 0 THEN BEGIN
                            SalesLine."Line Discount Amount" :=
                              ROUND(
                                SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            SalesLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                SalesLine."Inv. Discount Amount" * (1 + (SalesLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                          END;
                        END ELSE BEGIN
                          SalesLine."Unit Price" :=
                            ROUND(
                              SalesLine."Unit Price" / (1 + (SalesLine."VAT %" / 100)),
                              Currency."Unit-Amount Rounding Precision");
                          IF SalesLine.Quantity <> 0 THEN BEGIN
                            SalesLine."Line Discount Amount" :=
                              ROUND(
                                SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                Currency."Amount Rounding Precision");
                            SalesLine.VALIDATE("Inv. Discount Amount",
                              ROUND(
                                SalesLine."Inv. Discount Amount" / (1 + (SalesLine."VAT %" / 100)),
                                Currency."Amount Rounding Precision"));
                          END;
                        END;
                        VehPriceMgt.ChkAssemblyHdrSalesLine(SalesLine) //23.11.2007 EDMS P3
                      END;
                      SalesLine.MODIFY;
                    UNTIL SalesLine.NEXT = 0;
                  END;
                END;
                */

            end;
        }
        field(300; "Fixed Prices and Discounts"; Boolean)
        {
            Caption = 'Fixed Prices and Discounts';
        }
        field(310; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                TestField(Type, Type::"Campaign Service Package");
            end;
        }
        field(320; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(400; "Recall Campaign No."; Code[20])
        {
            Caption = 'Recall Campaign No.';
            TableRelation = "Recall Campaign";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Make Code")
        {
        }
        key(Key3; Type)
        {
        }
        key(Key4; "Recall Campaign No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        SPVersion.Reset;
        SPVersion.SetRange("Package No.", "No.");
        SPVersion.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            ServSetup.Get();
            ServSetup.TestField("Service Package Nos.");
            "No." := NoSeriesMgt.GetNextNo(ServSetup."Service Package Nos.", 0D, true);
        end;
        "Last Date Modified" := WorkDate();
    end;

    var
        ServSetup: Record "Service Mgt. Setup EDMS";
        CurrExchRate: Record "Currency Exchange Rate";
        NoSeriesMgt: Codeunit "No. Series";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text001: label 'Do you want to update the exchange rate?';
        Text002: label 'You have modified %1.\\';
        Text003: label 'Do you want to update the lines?';
        SPVersion: Record "Service Package Version";
        SPVersionSpec: Record "Service Package Version Line";
        HasServSetup: Boolean;

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        if "Currency Code" <> '' then begin
            CurrencyDate := WorkDate;
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        if HideValidationDialog then
            Confirmed := true
        else
            Confirmed := Confirm(Text001, false);
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;


    procedure UpdateSPLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        if SPLinesExist and AskQuestion then begin
            Question := StrSubstNo(
              Text002 +
              Text003, ChangedFieldName);
            if GuiAllowed and not Dialog.Confirm(Question, true) then
                exit
            else
                UpdateLines := true;
        end;
        if SPLinesExist then begin

            SPVersion.LockTable;
            SPVersionSpec.LockTable;
            Modify;

            SPVersion.Reset;
            SPVersion.SetRange("Package No.", "No.");
            if SPVersion.FindSet then
                repeat
                    SPVersionSpec.Reset;
                    SPVersionSpec.SetRange("Package No.", "No.");
                    SPVersionSpec.SetRange("Version No.", SPVersion."Version No.");
                    if SPVersionSpec.FindSet then
                        repeat
                            case ChangedFieldName of
                                FieldCaption("Currency Factor"):
                                    if SPVersionSpec.Type <> SPVersionSpec.Type::"Comment" then begin
                                        SPVersionSpec.Validate("Unit Price");
                                    end;
                            end;
                            SPVersionSpec.Modify(true);
                        until SPVersionSpec.Next = 0;
                until SPVersion.Next = 0;
        end;
    end;


    procedure SPLinesExist(): Boolean
    var
        Res: Boolean;
    begin
        Res := false;
        SPVersion.Reset;
        SPVersion.SetRange("Package No.", "No.");
        if SPVersion.FindSet then
            repeat
                SPVersionSpec.Reset;
                SPVersionSpec.SetRange("Package No.", "No.");
                SPVersionSpec.SetRange("Version No.", SPVersion."Version No.");
                Res := Res or SPVersionSpec.FindFirst
            until SPVersion.Next = 0;
        exit(Res);
    end;


    procedure AssistEdit(): Boolean
    begin
        GetServSetup;
        ServSetup.TestField("Labor Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(ServSetup."Service Package Nos.", ServSetup."Service Package Nos.", ServSetup."Service Package Nos.") then begin
            "No." := NoSeriesMgt.GetNextNo(ServSetup."Service Package Nos.", WorkDate(), true);
            exit(true);
        end;
    end;


    procedure GetServSetup()
    begin
        if not HasServSetup then begin
            ServSetup.Get;
            HasServSetup := true;
        end;
    end;
}

