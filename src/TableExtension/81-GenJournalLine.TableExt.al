tableextension 25006012 "Gen. Journal Line" extends "Gen. Journal Line"//81
{
    // 08.06.2022 EB EDMS
    //   Added field:
    //     25006010 "Contract No."
    //
    // 03.05.2019 EB.P7 EDMS
    //   Added field:
    //     25006601"Document Profile"
    // 
    // 20.08.2018 EB EDMS
    //   Added field:
    //     25006010 "Deal Type"
    // 
    // 02.08.2018 EB.P30 EDMS Rent
    //   Added field:
    //     25006600 "Rent Order No."
    //   Modified function:
    //     CopyFromSalesHeader
    // 
    // 30.07.2007. EDMS P2
    //    * Commented lines in trigger Account No. - OnValidate()
    // 
    // 23.07.2007. EDMS P2
    //   * Added functions
    //      GetLedgDim
    //      InsertJournDim
    //   * Added code in trigger
    //      Applies-to Doc. No. - OnLookup()
    // 
    // 22.06.2007. EDMS P2
    //   * Added functions
    //        ApplyLines
    //        UpdateBankCode
    //        SplitDocNo
    //        ExtractDocSer
    //        ExtractDocNo
    //        AppendStr
    // 
    // //03-04-2007 EDMS P3 Cost
    //  Added field Vehicle Cost Group
    //  Changed standart onvalidate code for gen.prod.group and gen.bus.group
    // //16-04-2007 EDMS P3 Obsolete ^

    fields
    {
        field(25006001; VIN; Code[20])
        {
            Caption = 'VIN';

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
                recVehicle.Reset;
                if cuLookUpMgt.LookUpVehicleAMT(recVehicle, VIN) then begin
                    Validate(VIN, recVehicle.VIN);
                end;
            end;

            trigger OnValidate()
            var
                recSalesLine: Record "Sales Line";
                tcAMT001: label 'This VIN is being used in %1. Are you shore that you want to use exactly this VIN?';
                Vehicle: Record Vehicle;
                tcAMT002: label 'Serial No. in Vehicle table differs from Serial No. in Sales Line.';
            begin
                if VIN <> '' then begin
                    Vehicle.Reset;
                    Vehicle.SetCurrentkey(VIN);
                    Vehicle.SetRange(VIN, VIN);
                    if Vehicle.FindFirst then begin
                        Validate("Vehicle Serial No.", Vehicle."Serial No.");
                        Validate("Make Code", Vehicle."Make Code");
                    end;
                end
                else begin
                    Validate("Vehicle Serial No.", '');
                    Validate("Make Code", '');
                end;
            end;
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006004; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                /*recItem.RESET;
                IF cuLookUpMgt.fLookUpModelVersion(recItem,"Model Version No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",recItem."No.");
                 */

            end;

            trigger OnValidate()
            begin
                //VALIDATE("Item No.","Model Version No.");
            end;
        }
        field(25006010; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006050; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                if "Vehicle Serial No." = '' then begin
                    Validate("Vehicle Accounting Cycle No.", '');
                    "Vehicle Registration No." := '';
                end else begin
                    if Vehicle.Get("Vehicle Serial No.") then begin
                        "Vehicle Registration No." := Vehicle."Registration No.";
                        Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                        Validate("Vehicle Accounting Cycle No.", Vehicle."Default Vehicle Acc. Cycle No.");
                    end;
                end;
            end;
        }
        field(25006051; "G/L Entry To Close (Veh. Cost)"; Integer)
        {
            BlankZero = true;
            Caption = 'G/L Entry To Close (Veh. Cost)';
            Description = 'Vehicle Cost Support';
            TableRelation = "G/L Entry";
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

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
                end else
                    Message(StrSubstNo(Text100, "Vehicle Registration No."), '');
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006400; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
        field(25006600; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
            Description = 'Only for Rent';
        }
        field(25006601; "Document Profile"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Spare Parts Trade,Vehicles Trade,Service,Rent';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service,Rent;
        }
    }
    var
        ApplyCustEntries: Page "Apply Customer Entries";
        ApplyVendEntries: Page "Apply Vendor Entries";
        AccNo: Code[20];
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        Text12800: label 'Do You want change "Order Printed" status?';
        Text12801: label 'Incl. VAT';
        Text12802: label 'Reset Order?';
        Text100: label 'Payment for I.%1 of %2 ';
        ErrVendNoIINPayer: label 'Vendor %1 is not %2. You mustn''t enter %3! ';
        TxtIncomeTax: label 'Is it Phys. Person Incomes Tax? ';
        cuLookUpMgt: Codeunit LookUpManagement;

    procedure ApplyLines()
    var
        VendLE: Record "Vendor Ledger Entry";
        Invoices: Record "Purch. Inv. Header";
        pvnentry: Record "VAT Entry";
        BankAcc: Record "Bank Account";
        Valkurss: Record "Currency Exchange Rate";
        old_nr: Code[20];
        LastSerNo: Code[20];
        old: Code[20];
        DokNr: Text[1024];
        PrefixNo: Text[30];
        Val_src: Text[10];
        Val_dst: Text[10];
        kurss_dst: Decimal;
        kurss_src: Decimal;
        PVNsum: Decimal;
        pvnamount: Decimal;
    begin
        Codeunit.Run(Codeunit::"Gen. Jnl.-Apply", Rec);
        old := '';
        old_nr := '';
        DokNr := '';
        LastSerNo := '';
        PVNsum := 0;
        if "Account Type" = "account type"::Vendor then begin
            VendLE.SetFilter(VendLE."Vendor No.", '=%1', "Account No.");
            VendLE.SetFilter(VendLE."Applies-to ID", '=%1', "Document No.");
            if VendLE.FindSet then begin
                repeat
                    if DokNr = '' then
                        PrefixNo := 'R. '
                    else
                        PrefixNo := '';
                    if LastSerNo = ExtractDocSer(VendLE."External Document No.") then
                        DokNr := AppendStr(DokNr, PrefixNo + ExtractDocNo(VendLE."External Document No."), ' ', MaxStrLen(DokNr))
                    else begin
                        DokNr := AppendStr(DokNr, PrefixNo + VendLE."External Document No.", '; ', MaxStrLen(DokNr));
                        LastSerNo := ExtractDocSer(VendLE."External Document No.");
                    end;

                    Invoices.SetFilter(Invoices."No.", '%1', VendLE."Document No.");
                    if Invoices.FindFirst then
                        Invoices.CalcFields(Invoices."Amount Including VAT", Invoices.Amount);

                    Val_src := Rec."Currency Code";
                    if Val_src = '' then begin
                        Val_src := 'LVL';
                        kurss_src := 1;
                    end else begin
                        Valkurss.Reset;
                        Valkurss.SetFilter(Valkurss."Currency Code", '%1', Rec."Currency Code");
                        Valkurss.SetFilter(Valkurss."Starting Date", '%1', Rec."Posting Date");
                        Valkurss.FindFirst;
                        kurss_src := Valkurss."Exchange Rate Amount";
                    end;

                    Val_dst := '';
                    if Val_dst = '' then begin
                        Val_dst := 'LVL';
                        kurss_dst := 1;
                    end else begin
                        Valkurss.Reset;
                        Valkurss.SetFilter(Valkurss."Currency Code", '%1', Val_dst);
                        Valkurss.SetFilter(Valkurss."Starting Date", '%1', VendLE."Posting Date");
                        Valkurss.FindFirst;
                        kurss_dst := Valkurss."Exchange Rate Amount";
                    end;
                    // Look for VAt
                    pvnentry.Reset;
                    pvnentry.SetCurrentkey("Document No.", "Posting Date");
                    pvnentry.SetRange(pvnentry."Document No.", VendLE."Document No.");
                    pvnamount := 0;
                    if pvnentry.FindSet then begin
                        repeat
                            if pvnentry.Amount <> 0 then
                                pvnamount += pvnentry.Amount
                            else
                                pvnamount += pvnentry."Unrealized Amount";
                        until pvnentry.Next = 0;
                    end;
                    VendLE.CalcFields(VendLE."Remaining Amount", VendLE.Amount);

                    PVNsum := PVNsum + (pvnamount * VendLE."Remaining Amount" / VendLE.Amount) * kurss_dst / kurss_src;
                until VendLE.Next = 0;
                Modify;
            end;
        end;
    end;


    procedure ExtractDocSer(pDocNo: Code[35]) Result: Code[35]
    var
        s: Code[35];
    begin
        SplitDocNo(pDocNo, Result, s)
    end;

    procedure ExtractDocNo(pDocNo: Code[35]) Result: Code[35]
    var
        s: Code[35];
    begin
        SplitDocNo(pDocNo, s, Result)
    end;

    procedure AppendStr(s1: Text[1024]; s2: Text[1024]; Separator: Text[1024]; MaxLen: Integer) Result: Text[1024]
    begin
        Result := s1;
        if s2 = '' then
            exit;

        if s1 <> '' then
            if StrLen(Result) + StrLen(Separator) <= MaxLen then
                Result := s1 + Separator;

        if StrLen(Result) + StrLen(s2) <= MaxLen then
            Result := Result + s2;
    end;

    //[Scope('OnPrem')]
    procedure SetDefSalesperson()
    var
        UserSetup: Record "User Setup";
    begin
        //08.04.2014 Elva Baltic P1 #RX MMG7.00 - added
        if UserSetup.Get(UserId) then
            Validate("Salespers./Purch. Code", UserSetup."Salespers./Purch. Code")
    end;

    procedure OnLookupVehicleRegistrationNo()
    var
        Vehicle: Record Vehicle;
        LookUpMgt: Codeunit LookUpManagement;
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

    procedure SplitDocNo(pDocNo: Code[20]; var pSer: Code[20]; var pNo: Code[20])
    var
        n: Integer;
    begin
        pSer := '';
        pNo := pDocNo;
        n := StrPos(pDocNo, ' ');
        if n > 0 then begin
            pSer := DelChr(CopyStr(pDocNo, 1, n - 1), '<>', ' ');
            pNo := DelChr(CopyStr(pDocNo, n + 1, MaxStrLen(pDocNo) - n + 1), '<>', ' ');
        end;
    end;

}
