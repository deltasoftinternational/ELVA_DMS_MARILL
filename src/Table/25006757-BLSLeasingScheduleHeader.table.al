table 25006757 "BLS Leasing Schedule Header"
{
    Caption = 'Leasing Schedule Header';
    DrillDownPageID = 25006572;
    LookupPageID = 25006572;

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    BLSSetup.GET;
                    NoSeriesMgt.TestManual(BLSSetup."Leasing Schedule Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(1000; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(1010; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(1020; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(2000; "Loan Amount"; Decimal)
        {
            Caption = 'Loan Amount';
            Editable = false;
            trigger OnValidate()
            begin
                IF "Loan Amount" < 0 THEN
                    ERROR(NegativeValueErr);
            end;
        }
        field(2009; "Residual %"; Decimal)
        {
            Caption = 'Residual %';

            trigger OnValidate()
            begin
                if ("Residual %" < 0) or ("Residual %" > 100) then
                    error(PercentRangeErr);
                "Residual Value" := Round("Sales Amount" * "Residual %" / 100, 0.01);
                "Repayment Amount" := "Loan Amount" - "Residual Value";
            end;
        }
        field(2010; "Residual Value"; Decimal)
        {
            Caption = 'Residual Value';

            trigger OnValidate()
            begin
                IF "Residual Value" < 0 THEN
                    ERROR(NegativeValueErr);

                IF ("Residual Value" > "Loan Amount") THEN
                    ERROR(RetailIsLessReturnErr);
                if "Sales Amount" <> 0 then
                    "Residual %" := Round(("Residual Value" / "Sales Amount") * 100, 0.01);
                "Repayment Amount" := "Loan Amount" - "Residual Value";
            end;
        }
        field(2020; "Repayment Amount"; Decimal)
        {
            Caption = 'Repayment Amount';
        }
        field(2030; "Term Of Lease, Months"; Integer)
        {
            Caption = 'Term Of Lease, Months';

            trigger OnValidate()
            begin
                IF NOT ("Term Of Lease, Months" IN [1 .. 240]) THEN
                    ERROR(IncorrectLeaseTermErr);

                CalcPeriod(FALSE);
                CalcInterestPercent(FALSE);
                CalcAmounts;
            end;
        }
        field(2032; "Period Type"; Option)
        {
            Caption = 'Period Type';
            OptionCaption = 'Monthly,Quarterly,Semi-Annual,Annual';
            OptionMembers = "Monthly","Quarterly","Semi-Annual","Annual";
        }
        field(2033; "Schedule Type"; Option)
        {
            Caption = 'Schedule Type';
            OptionCaption = 'Annuity,Linear';
            OptionMembers = "Annuity","Linear";
        }
        field(2040; "Interest, % (Annual)"; Decimal)
        {
            Caption = 'Interest, % (Annual)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Interest, % (Annual)" < 0 THEN
                    ERROR(NegativeInterestErr);

                CalcInterestPercent(TRUE);
            end;
        }
        field(2050; "Interest, % (Monthly)"; Decimal)
        {
            Caption = 'Interest, % (Monthly)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Interest, % (Monthly)" < 0 THEN
                    ERROR(NegativeInterestErr);

                CalcInterestPercent(FALSE);
            end;
        }
        field(2060; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF "Starting Date" = 0D THEN
                    "Starting Date" := WORKDATE;

                CalcPeriod(FALSE);
            end;
        }
        field(2070; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(2080; "Amounts Including VAT"; Boolean)
        {
            Caption = 'Amounts Including VAT';
        }
        field(2090; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;
        }
        field(2100; "Machine Hours"; Integer)
        {
            Caption = 'Machine Hours';
            MinValue = 0;
        }
        field(3000; "Lease Amount (Mounthly)"; Decimal)
        {
            Caption = 'Lease Amount (Mounthly)';
        }
        field(3010; "Service Amount (Mounthly)"; Decimal)
        {
            Caption = 'Service Amount (Mounthly)';

            trigger OnValidate()
            begin
                IF "Service Amount (Mounthly)" < 0 THEN
                    ERROR(NegativeValueErr);

                CalcAmounts;
            end;
        }
        field(3020; "Total Amount (Mounthly)"; Decimal)
        {
            Caption = 'Total Amount (Mounthly)';
        }
        field(4000; "Interest Amount"; Decimal)
        {
            Caption = 'Interest Amount';
        }
        field(4010; "Finance Value"; Decimal)
        {
            Caption = 'Finance Value';
        }
        field(4020; "Service Amount"; Decimal)
        {
            Caption = 'Service Amount';
        }
        field(4030; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
        }
        field(4035; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
            trigger OnValidate()
            begin
                Validate("Down Payment Amount");
                Validate("Residual Value");
            end;
        }
        field(4040; "Down Payment %"; Decimal)
        {
            Caption = 'Down Payment %';
            trigger OnValidate()
            begin
                if ("Down Payment %" < 0) or ("Down Payment %" > 100) then
                    error(PercentRangeErr);
                "Down Payment Amount" := Round("Sales Amount" * "Down Payment %" / 100, 0.01);
                "Loan Amount" := "Sales Amount" - "Down Payment Amount";
                "Repayment Amount" := "Loan Amount" - "Residual Value";
            end;
        }
        field(4041; "Down Payment Amount"; Decimal)
        {
            Caption = 'Down Payment Amount';
            trigger OnValidate()
            begin
                if "Loan Amount" <> 0 then
                    "Down Payment %" := Round(("Down Payment Amount" / "Loan Amount") * 100, 0.01);
                "Loan Amount" := "Sales Amount" - "Down Payment Amount";
                "Repayment Amount" := "Loan Amount" - "Residual Value";
            end;
        }
        field(5010; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." where("Bill-to Customer No." = field("Customer No."));

            trigger OnValidate()
            begin
                IF "Contract No." <> '' THEN BEGIN
                    DMSContract.GET("Contract No.");
                    DMSContract.TESTFIELD(Status, DMSContract.Status::Active);
                    VALIDATE("Customer No.", DMSContract."Bill-to Customer No.");
                END;
            end;
        }
        field(5020; "Contract Lease Line No."; Integer)
        {
            Caption = 'Contract Lease Line No.';
        }
        field(5030; "Contract Service Line No."; Integer)
        {
            Caption = 'Contract Service Line No.';
        }
        field(6000; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF "Customer No." = '' THEN BEGIN
                    "Customer Name" := '';
                    VALIDATE("VAT Bus. Posting Group", '');
                END ELSE BEGIN
                    Customer.GET("Customer No.");
                    "Customer Name" := Customer.Name;
                    VALIDATE("VAT Bus. Posting Group", Customer."VAT Bus. Posting Group");
                    "Currency Code" := Customer."Currency Code";
                END;
            end;
        }
        field(6010; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(6020; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                VALIDATE("LO VAT Prod. Posting Group");
                VALIDATE("ASO VAT Prod. Posting Group");
            end;
        }
        field(7000; "Leasing Service Code"; Code[20])
        {
            Caption = 'Leasing Service Code';
            TableRelation = "BLS Service".Code;

            trigger OnValidate()
            begin
                IF "Leasing Service Code" = '' THEN
                    VALIDATE("LO VAT Prod. Posting Group", '')
                ELSE BEGIN
                    BLSService.GET("Leasing Service Code");
                    VALIDATE("LO VAT Prod. Posting Group", BLSService.GetVATProdPostingGroup);
                END;
            end;
        }
        field(7001; "Leasing Interest Service Code"; Code[20])
        {
            Caption = 'Leasing Interest Service Code';
            TableRelation = "BLS Service".Code;

            trigger OnValidate()
            begin
                IF "Leasing Interest Service Code" = '' THEN
                    VALIDATE("L. Interest VAT Pr. Post. Gr.", '')
                ELSE BEGIN
                    BLSService.GET("Leasing Interest Service Code");
                    VALIDATE("L. Interest VAT Pr. Post. Gr.", BLSService.GetVATProdPostingGroup);
                END;
            end;
        }
        field(7010; "Additional Service Code"; Code[20])
        {
            Caption = 'Additional Service Code';
            TableRelation = "BLS Service".Code;

            trigger OnValidate()
            begin
                IF "Additional Service Code" = '' THEN
                    VALIDATE("ASO VAT Prod. Posting Group", '')
                ELSE BEGIN
                    BLSService.GET("Additional Service Code");
                    VALIDATE("ASO VAT Prod. Posting Group", BLSService.GetVATProdPostingGroup);
                END;
            end;
        }
        field(7020; "Leasing VAT %"; Decimal)
        {
            Caption = 'Leasing VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(7030; "Additional Service VAT %"; Decimal)
        {
            Caption = 'Additional Service VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(7040; "Leasing VAT Calculation Type"; Option)
        {
            Caption = 'Leasing VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(7050; "Add. Serv VAT Calculation Type"; Option)
        {
            Caption = 'Additiona Service VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(7060; "LO VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Leasing Original VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                "Leas. VAT Prod. Posting Group" := "LO VAT Prod. Posting Group";
            end;
        }


        field(7070; "ASO VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Additional Service Original VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                "AddSer VAT Prod. Posting Group" := "ASO VAT Prod. Posting Group";
                VALIDATE("AddSer VAT Prod. Posting Group");
            end;
        }
        field(7080; "Leas. VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Leasing VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                "Leasing VAT %" := 0;
                "Leasing VAT Calculation Type" := "Leasing VAT Calculation Type"::"Normal VAT";
                IF VATPostingSetup.GET("VAT Bus. Posting Group", "Leas. VAT Prod. Posting Group") THEN BEGIN
                    "Leasing VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                    CASE "Leasing VAT Calculation Type" OF
                        "Leasing VAT Calculation Type"::"Normal VAT":
                            "Leasing VAT %" := VATPostingSetup."VAT %";
                    END;
                END;
                VALIDATE("Leasing VAT %");
            end;
        }
        field(7081; "L. Interest VAT Pr. Post. Gr."; Code[10])
        {
            Caption = 'Leasing Interest VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                "Leasing VAT %" := 0;
                "Leasing VAT Calculation Type" := "Leasing VAT Calculation Type"::"Normal VAT";
                IF VATPostingSetup.GET("VAT Bus. Posting Group", "L. Interest VAT Pr. Post. Gr.") THEN BEGIN
                    "Leasing VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                    CASE "Leasing VAT Calculation Type" OF
                        "Leasing VAT Calculation Type"::"Normal VAT":
                            "Leasing VAT %" := VATPostingSetup."VAT %";
                    END;
                END;
                VALIDATE("Leasing VAT %");
            end;
        }
        field(7090; "AddSer VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Additional Service VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                "Additional Service VAT %" := 0;
                "Add. Serv VAT Calculation Type" := "Add. Serv VAT Calculation Type"::"Normal VAT";
                IF VATPostingSetup.GET("VAT Bus. Posting Group", "AddSer VAT Prod. Posting Group") THEN BEGIN
                    "Add. Serv VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                    CASE "Add. Serv VAT Calculation Type" OF
                        "Add. Serv VAT Calculation Type"::"Normal VAT":
                            "Additional Service VAT %" := VATPostingSetup."VAT %";
                    END;
                END;
                VALIDATE("Additional Service VAT %");
            end;
        }
        field(8000; "Lease Base"; Decimal)
        {
            Caption = 'Lease Base';
        }
        field(8010; "Lease VAT Amount"; Decimal)
        {
            Caption = 'Lease VAT Amount';
        }
        field(8020; "Lease Amount Incl. VAT"; Decimal)
        {
            Caption = 'Lease Amount Incl. VAT';
        }
        field(8100; "Add. Service Base"; Decimal)
        {
            Caption = 'Add. Service Base';
        }
        field(8110; "Add. Service VAT Amount"; Decimal)
        {
            Caption = 'Add. Service VAT Amount';
        }
        field(8120; "Add. Service Amount Incl. VAT"; Decimal)
        {
            Caption = 'Add. Service Amount Incl. VAT';
        }
        field(8200; "Total Base"; Decimal)
        {
            Caption = 'Total Base';
        }
        field(8210; "Total VAT Amount"; Decimal)
        {
            Caption = 'Total VAT Amount';
        }
        field(8220; "Total Amount Incl. VAT"; Decimal)
        {
            Caption = 'Total Amount Incl. VAT';
        }
        field(9000; FX; Decimal)
        {
        }
        field(9010; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                IF "Vehicle Serial No." <> '' THEN BEGIN
                    Vehicle.GET("Vehicle Serial No.");
                    Vehicle.TESTFIELD(Blocked, FALSE);
                    "Veh. Make Code" := Vehicle."Make Code";
                    "Veh. Model Code" := Vehicle."Model Code";
                    "Veh. Model Version No." := Vehicle."Model Version No.";
                END;
            end;
        }
        field(9020; "Veh. Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make.Code where("Code" = field("Veh. Make Code"));
            trigger OnValidate()
            begin
                if Rec."Veh. Make Code" <> xRec."Veh. Make Code" then begin
                    "Veh. Model Code" := '';
                    "Veh. Model Version No." := '';
                end;
            end;
        }
        field(9030; "Veh. Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Veh. Make Code"));
            trigger OnValidate()
            begin
                if Rec."Veh. Model Code" <> xRec."Veh. Model Code" then begin
                    "Veh. Model Version No." := '';
                end;
            end;
        }
        field(9040; "Veh. Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Veh. Make Code"),
                                              "Model Code" = field("Veh. Model Code"));
        }
        field(9050; VIN; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));
            Caption = 'VIN';
            FieldClass = FlowField;
            Editable = false;
        }
        field(10050; "Sales Doc. Type"; Option)
        {
            OptionCaption = ',Quote,Order,Posted Invoice';
            OptionMembers = " ",Quote,"Order","Posted Invoice";
        }
        field(10051; "Sales Doc. No."; Code[20])
        {
            Caption = 'Sales Document No.';
        }
        field(10052; "Contract Category Code"; Code[20])
        {
            Caption = 'Contract Category Code';
            TableRelation = "BLS Contract Category";

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
    begin
        TESTFIELD(Status, Status::Open);
        DeleteScheduleLines;
    end;

    trigger OnInsert()
    begin
        IF "Starting Date" = 0D THEN
            "Starting Date" := WORKDATE;

        BLSSetup.GET;

        IF "No." = '' THEN BEGIN
            BLSSetup.TESTFIELD("Leasing Schedule Nos.");
            "No. Series" := BLSSetup."Leasing Schedule Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series", "Starting Date", true);
        END;

        IF "Leasing Service Code" = '' THEN
            "Leasing Service Code" := BLSSetup."Leasing Service Code";
        VALIDATE("Leasing Service Code");

        IF "Leasing Interest Service Code" = '' THEN
            "Leasing Interest Service Code" := BLSSetup."Lease Interest Service Code";
        VALIDATE("Leasing Interest Service Code");

        IF "Additional Service Code" = '' THEN
            "Additional Service Code" := BLSSetup."Additional Service Code";
        VALIDATE("Additional Service Code");
    end;

    var
        NegativeValueErr: Label 'Value is negative';
        RetailIsLessReturnErr: Label 'Residual Value is less that Retail Value';
        IncorrectLeaseTermErr: Label 'Incorrect Term of Lease';
        NegativeInterestErr: Label 'Interest is negative';
        NoParamsErr: Label 'Enter all required parameters for calculation';
        LeasingCalculatorTxt: Label 'Leasing Calculator';
        BLSSetup: Record "BLS Setup";
        LeasingSchedule: Record "BLS Leasing Schedule Header";
        VATPostingSetup: Record "VAT Posting Setup";
        Customer: Record "Customer";
        DMSContract: Record Contract;
        BLSService: Record "BLS Service";
        Vehicle: Record Vehicle;
        NoSeriesMgt: Codeunit "No. Series";
        IncorrectAdvPeriodNumberErr: Label 'Incorrect number of advance periods';
        PercentRangeErr: Label 'Value must be in range 0-100%';

    procedure AssistEdit(OldLeasingSchedule: Record "BLS Leasing Schedule Header"): Boolean
    begin
        LeasingSchedule := Rec;
        BLSSetup.GET;
        BLSSetup.TESTFIELD("Leasing Schedule Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(BLSSetup."Leasing Schedule Nos.", OldLeasingSchedule."No. Series", LeasingSchedule."No. Series") then begin
            BLSSetup.Get();
            BLSSetup.TestField("Leasing Schedule Nos.");
            LeasingSchedule."No." := NoSeriesMgt.GetNextNo(LeasingSchedule."No. Series", WorkDate(), true);
            Rec := LeasingSchedule;
            exit(true);
        end;
    end;

    local procedure CalcPeriod(OnEndingDate: Boolean)
    var
        DateX: Date;
    begin
        TESTFIELD(Status, Status::Open);
        IF ("Starting Date" = 0D) THEN
            "Starting Date" := WORKDATE;

        IF ("Ending Date" = 0D) AND OnEndingDate THEN
            "Term Of Lease, Months" := 0
        ELSE BEGIN
            DateX := "Starting Date";
            IF DATE2DMY(DateX, 1) <> 1 THEN
                DateX := CALCDATE('<CM+1D-1M>', DateX);
            IF OnEndingDate THEN BEGIN
                "Term Of Lease, Months" := DATE2DMY("Ending Date", 3) * 12 + DATE2DMY("Ending Date", 2) - DATE2DMY(DateX, 3) * 12 + DATE2DMY(DateX, 2) + 1;
            END ELSE
                "Ending Date" := CALCDATE(STRSUBSTNO('<%1M+CM>', "Term Of Lease, Months" - 1), DateX);
        END;
    end;

    local procedure CalcInterestPercent(OnYearBase: Boolean)
    begin
        TESTFIELD(Status, Status::Open);
        IF "Term Of Lease, Months" <= 0 THEN
            ERROR(IncorrectLeaseTermErr);

        IF OnYearBase THEN
            "Interest, % (Monthly)" := ROUND("Interest, % (Annual)" / 12, 0.00001)
        ELSE
            "Interest, % (Annual)" := ROUND("Interest, % (Monthly)" * 12, 0.00001);

        CalcAmounts;
    end;

    local procedure CalcAmounts()
    var

    begin
        TESTFIELD(Status, Status::Open);

        IF ("Term Of Lease, Months" <= 0) OR ("Interest, % (Monthly)" <= 0) THEN BEGIN
            "Interest Amount" := 0;
            "Finance Value" := "Repayment Amount";
            "Lease Amount (Mounthly)" := 0;
            "Service Amount" := 0;
            "Total Amount" := "Finance Value";
            "Total Amount (Mounthly)" := 0;
        END;

    end;

    procedure CreateScheduleLinesCustom()
    var
        ScheduleLine: Record "BLS Leasing Schedule Line";
        FromDate: Date;
        ToDate: Date;
        PeriodNo: Integer;
        PaidAmount: Decimal;
    begin
        TESTFIELD(Status, Status::Open);
        DeleteScheduleLines;

        ScheduleLine.RESET;
        IF ("Term Of Lease, Months" = 0) OR
           ("Loan Amount" = 0) OR
           ("Starting Date" = 0D)
        THEN
            ERROR(NoParamsErr);

        PeriodNo := 0;
        IF DATE2DMY("Starting Date", 1) = 1 THEN
            FromDate := "Starting Date"
        ELSE
            FromDate := CALCDATE('<CM+1D-1M>', "Starting Date");
        PaidAmount := 0;
        if "Down Payment Amount" <> 0 then begin
            ScheduleLine.INIT;
            ScheduleLine."Leasing Schedule No." := "No.";
            ScheduleLine."Line No." := PeriodNo;
            ScheduleLine."Payment Date" := "Starting Date";

            ScheduleLine."Lease Amount" := "Down Payment Amount";
            ScheduleLine."Interest Amount" := 0;
            ScheduleLine."Base Amount" := "Down Payment Amount";
            //ScheduleLine."Begining Balance" := RemainingAmt + "Down Payment Amount";
            //ScheduleLine."Ending Balance" := RemainingAmt;
            ScheduleLine."Add. Service Amount Incl. VAT" := "Service Amount (Mounthly)";
            ScheduleLine.CalcTotals;

            ScheduleLine.INSERT;
        end;
        WHILE (PeriodNo < "Term Of Lease, Months") DO BEGIN
            PeriodNo += 1;
            ToDate := CALCDATE('<CM>', FromDate);

            ScheduleLine.INIT;
            ScheduleLine."Leasing Schedule No." := "No.";
            ScheduleLine."Line No." := PeriodNo;
            //IF FromDate < "Starting Date" THEN
            //    ScheduleLine."From Date" := "Starting Date"
            //ELSE
            //    ScheduleLine."From Date" := FromDate;
            ScheduleLine."Payment Date" := ToDate;
            //ScheduleLine."Period From" := CALCDATE(STRSUBSTNO('<%1M>', PeriodNo - 1), "Starting Date");
            //ScheduleLine."Period To" := CALCDATE(STRSUBSTNO('<%1M-1D>', PeriodNo), "Starting Date");
            ScheduleLine."Ending Balance" := ROUND("Finance Value" * ("Term Of Lease, Months" - PeriodNo) / "Term Of Lease, Months");
            ScheduleLine."Lease Amount" := "Finance Value" - PaidAmount - ScheduleLine."Ending Balance";
            ScheduleLine."Add. Service Amount Incl. VAT" := "Service Amount (Mounthly)";

            ScheduleLine.CalcTotals;
            ScheduleLine.INSERT;

            PaidAmount += ScheduleLine."Lease Amount";
            FromDate := CALCDATE('<1M>', FromDate);
        END;
        /*
                ScheduleLine.RESET;
                ScheduleLine.SETRANGE("Leasing Schedule No.", "No.");
                ScheduleLine.CALCSUMS("Lease Base", "Lease VAT Amount", "Lease Amount Incl. VAT",
                                      "Add. Service Base", "Add. Service VAT Amount", "Add. Service Amount Incl. VAT",
                                      "Total Base", "Total VAT Amount", "Total Amount Incl. VAT");

                "Lease Base" := ScheduleLine."Lease Base";
                "Lease VAT Amount" := ScheduleLine."Lease VAT Amount";
                "Lease Amount Incl. VAT" := ScheduleLine."Lease Amount Incl. VAT";
                "Add. Service Base" := ScheduleLine."Add. Service Base";
                "Add. Service VAT Amount" := ScheduleLine."Add. Service VAT Amount";
                "Add. Service Amount Incl. VAT" := ScheduleLine."Add. Service Amount Incl. VAT";
                "Total Base" := ScheduleLine."Total Base";
                "Total VAT Amount" := ScheduleLine."Total VAT Amount";
                "Total Amount Incl. VAT" := ScheduleLine."Total Amount Incl. VAT";*/
        MODIFY;
    end;


    procedure CreateScheduleLinesLinear()
    var
        ScheduleLine: Record "BLS Leasing Schedule Line";
        FromDate: Date;
        ToDate: Date;
        PeriodNo: Integer;
        PaidAmount: Decimal;
        Rate: Decimal;
        RemainingAmt: Decimal;
        BaseAmt: Decimal;
        GLSetup: Record "General Ledger Setup";
        Currency: Record "Currency";
        RoundingPrecision: Decimal;
    begin
        TESTFIELD(Status, Status::Open);
        DeleteScheduleLines;
        GLSetup.Get;
        ScheduleLine.RESET;
        IF ("Term Of Lease, Months" = 0) OR
           ("Loan Amount" = 0) OR
           ("Starting Date" = 0D) or
           ("Interest, % (Annual)" = 0)
        THEN
            ERROR(NoParamsErr);

        PeriodNo := 0;
        //IF DATE2DMY("Starting Date", 1) = 1 THEN
        FromDate := "Starting Date";
        //ELSE
        //FromDate := CALCDATE('<CM+1D-1M>', "Starting Date");
        //PaidAmount := 0;

        Rate := "Interest, % (Annual)" / 100 / 12;
        RemainingAmt := "Loan Amount";
        if "Currency Code" = '' then
            RoundingPrecision := GLSetup."Amount Rounding Precision"
        else begin
            Currency.GET("Currency Code");
            RoundingPrecision := Currency."Amount Rounding Precision";
        end;
        BaseAmt := Round(("Loan Amount" - "Residual Value") / "Term Of Lease, Months", RoundingPrecision);
        if "Down Payment Amount" <> 0 then begin
            ScheduleLine.INIT;
            ScheduleLine."Leasing Schedule No." := "No.";
            ScheduleLine."Line No." := PeriodNo;
            ScheduleLine."Payment Date" := "Starting Date";

            ScheduleLine."Lease Amount" := "Down Payment Amount";
            ScheduleLine."Interest Amount" := 0;
            ScheduleLine."Base Amount" := "Down Payment Amount";
            ScheduleLine."Begining Balance" := RemainingAmt + "Down Payment Amount";
            ScheduleLine."Ending Balance" := RemainingAmt;
            ScheduleLine."Add. Service Amount Incl. VAT" := "Service Amount (Mounthly)";
            ScheduleLine.CalcTotals;

            ScheduleLine.INSERT;
        end;
        ToDate := CALCDATE('<1M>', FromDate);
        WHILE (PeriodNo < "Term Of Lease, Months") DO BEGIN
            PeriodNo += 1;

            ScheduleLine.INIT;
            ScheduleLine."Leasing Schedule No." := "No.";
            ScheduleLine."Line No." := PeriodNo;

            ScheduleLine."Payment Date" := ToDate;


            ScheduleLine."Interest Amount" := Round(RemainingAmt * Rate, RoundingPrecision);
            if PeriodNo = "Term Of Lease, Months" then
                BaseAmt := RemainingAmt - "Residual Value";

            ScheduleLine."Base Amount" := BaseAmt;
            ScheduleLine."Ending Balance" := RemainingAmt - BaseAmt;
            ScheduleLine."Begining Balance" := RemainingAmt;
            ScheduleLine."Lease Amount" := ScheduleLine."Base Amount" + ScheduleLine."Interest Amount";
            ScheduleLine."Add. Service Amount Incl. VAT" := "Service Amount (Mounthly)";
            ScheduleLine.CalcTotals;
            ScheduleLine.INSERT;

            RemainingAmt := ScheduleLine."Ending Balance";
            //PaidAmount += ScheduleLine."Lease Amount (Calc.)";
            ToDate := CALCDATE('<1M>', ToDate);
        END;

        /*ScheduleLine.RESET;
        ScheduleLine.SETRANGE("Leasing Schedule No.", "No.");
        ScheduleLine.CALCSUMS("Lease Base", "Lease VAT Amount", "Lease Amount Incl. VAT",
                              "Add. Service Base", "Add. Service VAT Amount", "Add. Service Amount Incl. VAT",
                              "Total Base", "Total VAT Amount", "Total Amount Incl. VAT");

        
        "Total Interest" := ScheduleLine."Total Base";
        "Total VAT Amount" := ScheduleLine."Total VAT Amount";
        "Total Amount Incl. VAT" := ScheduleLine."Total Amount Incl. VAT";*/
        MODIFY;
    end;

    procedure CreateScheduleLinesAnnuity()
    var
        ScheduleLine: Record "BLS Leasing Schedule Line";
        FromDate: Date;
        ToDate: Date;
        PeriodNo: Integer;
        PaidAmount: Decimal;
        Rate: Decimal;
        Denominator: Decimal;
        RemainingAmt: Decimal;
        PMT: Decimal;
        GLSetup: Record "General Ledger Setup";
        Currency: Record "Currency";
        RoundingPrecision: Decimal;
    begin
        TESTFIELD(Status, Status::Open);
        DeleteScheduleLines;

        ScheduleLine.RESET;
        IF ("Term Of Lease, Months" = 0) OR
           ("Loan Amount" = 0) OR
           ("Starting Date" = 0D) or
           ("Interest, % (Annual)" = 0)
        THEN
            ERROR(NoParamsErr);

        PeriodNo := 0;
        //IF DATE2DMY("Starting Date", 1) = 1 THEN
        FromDate := "Starting Date";
        //ELSE
        //    FromDate := CALCDATE('<CM+1D-1M>', "Starting Date");
        PaidAmount := 0;
        GLSetup.Get();
        if "Currency Code" = '' then
            RoundingPrecision := GLSetup."Amount Rounding Precision"
        else begin
            Currency.GET("Currency Code");
            RoundingPrecision := Currency."Amount Rounding Precision";
        end;

        Rate := "Interest, % (Annual)" / 100 / 12;
        Denominator := Power((1 + rate), "Term Of Lease, Months") - 1;
        RemainingAmt := "Loan Amount";
        PMT := ROUND(-Rate / Denominator * (-("Loan Amount" * Power((1 + rate), "Term Of Lease, Months")) + "Residual Value"), RoundingPrecision);
        "Lease Amount (Mounthly)" := PMT;
        "Total Amount (Mounthly)" := "Lease Amount (Mounthly)" + "Service Amount (Mounthly)";
        if "Down Payment Amount" <> 0 then begin
            ScheduleLine.INIT;
            ScheduleLine."Leasing Schedule No." := "No.";
            ScheduleLine."Line No." := PeriodNo;
            ScheduleLine."Payment Date" := "Starting Date";

            ScheduleLine."Lease Amount" := "Down Payment Amount";
            ScheduleLine."Interest Amount" := 0;
            ScheduleLine."Base Amount" := "Down Payment Amount";
            ScheduleLine."Begining Balance" := RemainingAmt + "Down Payment Amount";
            ScheduleLine."Ending Balance" := RemainingAmt;
            ScheduleLine."Add. Service Amount Incl. VAT" := "Service Amount (Mounthly)";
            ScheduleLine.CalcTotals;

            ScheduleLine.INSERT;
        end;
        ToDate := CALCDATE('<1M>', FromDate);
        WHILE (PeriodNo < "Term Of Lease, Months") DO BEGIN
            PeriodNo += 1;

            ScheduleLine.INIT;
            ScheduleLine."Leasing Schedule No." := "No.";
            ScheduleLine."Line No." := PeriodNo;
            ScheduleLine."Payment Date" := ToDate;

            ScheduleLine."Lease Amount" := PMT;
            //ScheduleLine."Lease Amount (Calc.)" := (Rate + (Rate / Denominator)) * "Lease Value";
            ScheduleLine."Interest Amount" := ROUND(RemainingAmt * Rate, RoundingPrecision);
            if PeriodNo = "Term Of Lease, Months" then begin
                ScheduleLine."Base Amount" := RemainingAmt - "Residual Value";
                ScheduleLine."Lease Amount" := ScheduleLine."Base Amount" + ScheduleLine."Interest Amount";
            end else
                ScheduleLine."Base Amount" := ScheduleLine."Lease Amount" - ScheduleLine."Interest Amount";
            ScheduleLine."Begining Balance" := RemainingAmt;
            ScheduleLine."Ending Balance" := RemainingAmt - ScheduleLine."Base Amount";
            ScheduleLine."Add. Service Amount Incl. VAT" := "Service Amount (Mounthly)";
            ScheduleLine.CalcTotals;

            ScheduleLine.INSERT;
            RemainingAmt := ScheduleLine."Ending Balance";
            //PaidAmount += ScheduleLine."Base Amount";
            ToDate := CALCDATE('<1M>', ToDate);
        END;

        /*ScheduleLine.RESET;
        ScheduleLine.SETRANGE("Leasing Schedule No.", "No.");
        ScheduleLine.CALCSUMS("Lease Base", "Lease VAT Amount", "Lease Amount Incl. VAT",
                              "Add. Service Base", "Add. Service VAT Amount", "Add. Service Amount Incl. VAT",
                              "Total Base", "Total VAT Amount", "Total Amount Incl. VAT", "Interest Amount", "Add. Service Amount (Calc.)");


        "Lease Base" := ScheduleLine."Lease Base";
        "Lease VAT Amount" := ScheduleLine."Lease VAT Amount";
        "Lease Amount Incl. VAT" := ScheduleLine."Lease Amount Incl. VAT";
        "Add. Service Base" := ScheduleLine."Add. Service Base";
        "Add. Service VAT Amount" := ScheduleLine."Add. Service VAT Amount";
        "Add. Service Amount Incl. VAT" := ScheduleLine."Add. Service Amount Incl. VAT";
        "Total Base" := ScheduleLine."Total Base";
        "Total VAT Amount" := ScheduleLine."Total VAT Amount";
        "Total Amount Incl. VAT" := ScheduleLine."Total Amount Incl. VAT";
        "Interest Amount" := ScheduleLine."Interest Amount";
        "Service Amount" := ScheduleLine."Add. Service Amount (Calc.)";
        MODIFY;*/
    end;

    procedure CreateScheduleLines()
    begin
        if "Schedule Type" = "Schedule Type"::Linear then
            CreateScheduleLinesLinear()
        else
            if "Schedule Type" = "Schedule Type"::Annuity then
                CreateScheduleLinesAnnuity()
            else
                CreateScheduleLinesCustom();
    end;

    procedure DeleteScheduleLines()
    var
        ScheduleLine: Record "BLS Leasing Schedule Line";
    begin
        TESTFIELD(Status, Status::Open);

        ScheduleLine.RESET;
        ScheduleLine.SETRANGE("Leasing Schedule No.", "No.");
        ScheduleLine.DELETEALL;
    end;

    procedure Release()
    var
        DMSContractLine: Record "DMS Contract Line";
        ScheduleLine: Record "BLS Leasing Schedule Line";
    begin
        TESTFIELD(Status, Status::Open);
        //TESTFIELD("Contract No.");
        TESTFIELD("Customer No.");

        //DeleteScheduleLines;
        ///CreateScheduleLines;

        ScheduleLine.RESET;
        ScheduleLine.SETRANGE("Leasing Schedule No.", "No.");
        ScheduleLine.FINDFIRST;

        TESTFIELD("Vehicle Serial No.");
        /* 
        DMSContract.GET(DMSContract."Contract Type"::Contract, "Contract No.");
        DMSContract.TESTFIELD("Bill-to Customer No.", "Customer No.");
        DMSContract.TESTFIELD(Status, DMSContract.Status::Active);

        IF "Lease Amount Incl. VAT" <> 0 THEN BEGIN
            TESTFIELD("Leasing Service Code");
            DMSContractLine.INIT;
            DMSContractLine."DMS Contract No." := "Contract No.";
            DMSContractLine.VALIDATE("Service Code", "Leasing Service Code");
            DMSContractLine."Object Code" := '';
            DMSContractLine.VALIDATE("Starting Date", ScheduleLine."From Date");
            DMSContractLine."Ending Date" := "Ending Date";
            DMSContractLine."Quantity Source" := DMSContractLine."Quantity Source"::Contract;
            DMSContractLine.VALIDATE(Quantity, 1);
            DMSContractLine."Price Source" := DMSContractLine."Price Source"::Contract;
            DMSContractLine.VALIDATE(Price, "Lease Amount (Mounthly)");
            DMSContractLine."Price Including VAT" := "Amounts Including VAT";
            DMSContractLine."Vehicle Serial No." := "Vehicle Serial No.";
            DMSContractLine."Leasing Schedule No." := "No.";
            DMSContractLine.INSERT;
        END;

        IF "Add. Service Amount Incl. VAT" <> 0 THEN BEGIN
            TESTFIELD("Additional Service Code");
            DMSContractLine.INIT;
            DMSContractLine."DMS Contract No." := "Contract No.";
            DMSContractLine.VALIDATE("Service Code", "Additional Service Code");
            DMSContractLine."Object Code" := '';
            DMSContractLine.VALIDATE("Starting Date", ScheduleLine."From Date");
            DMSContractLine."Ending Date" := "Ending Date";
            DMSContractLine."Quantity Source" := DMSContractLine."Quantity Source"::Contract;
            DMSContractLine.VALIDATE(Quantity, 1);
            DMSContractLine."Price Source" := DMSContractLine."Price Source"::Contract;
            DMSContractLine.VALIDATE(Price, "Service Amount (Mounthly)");
            DMSContractLine."Price Including VAT" := "Amounts Including VAT";
            DMSContractLine."Vehicle Serial No." := "Vehicle Serial No.";
            DMSContractLine."Leasing Schedule No." := "No.";
            DMSContractLine.INSERT;
        END;
 */


        Status := Status::Released;
        MODIFY;
    end;


    procedure Reopen()
    var
        DMSContractLine: Record "DMS Contract Line";
    begin
        TESTFIELD(Status, Status::Released);
        //TESTFIELD("Contract No.");
        /* 
                DMSContract.GET(DMSContract."Contract Type"::Contract, "Contract No.");
                DMSContract.TESTFIELD(Status, DMSContract.Status::Active);
                DMSContractLine.RESET;
                DMSContractLine.SETRANGE("DMS Contract No.", "Contract No.");
                DMSContractLine.SETRANGE("Leasing Schedule No.", "No.");
                IF DMSContractLine.FINDSET(TRUE) THEN BEGIN
                    REPEAT
                        DMSContractLine.TESTFIELD("Last Calculation Date", 0D);
                    UNTIL DMSContractLine.NEXT = 0;
                    DMSContractLine.DELETEALL(TRUE);
                END;

         */
        Status := Status::Open;
        MODIFY;
    end;

    local procedure CalcVATAmounts(InAmount: Decimal; VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax"; VATRate: Decimal; var BaseAmount: Decimal; var VATAmount: Decimal; var AmountInclVAT: Decimal)
    begin
        IF "Amounts Including VAT" THEN BEGIN
            AmountInclVAT := InAmount;
            CASE VATCalcType OF
                VATCalcType::"Normal VAT",
              VATCalcType::"Reverse Charge VAT":
                    BaseAmount := ROUND(AmountInclVAT / (100 + VATRate) * 100);
                VATCalcType::"Full VAT":
                    BaseAmount := 0;
                ELSE
                    BaseAmount := AmountInclVAT;
            END;
        END ELSE BEGIN
            BaseAmount := InAmount;
            CASE VATCalcType OF
                VATCalcType::"Normal VAT",
              VATCalcType::"Reverse Charge VAT":
                    AmountInclVAT := ROUND(BaseAmount * (100 + VATRate) / 100);
                VATCalcType::"Full VAT":
                    BaseAmount := 0;
                ELSE
                    AmountInclVAT := BaseAmount;
            END;
        END;
        VATAmount := AmountInclVAT - BaseAmount;
    end;
}

