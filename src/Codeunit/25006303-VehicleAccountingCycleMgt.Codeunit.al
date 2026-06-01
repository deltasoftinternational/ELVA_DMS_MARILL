Codeunit 25006303 "VehicleAccountingCycleMgt"
{
    // 30.04.2014 Elva Baltic P8 #F058 MMG7.00
    //   * ADDED PERMISSIONS
    // 
    // 31.07.2007. EDMS P2
    //   * Added functions
    //       ChangeCycleInItemLedgerEntry
    //       ChangeCycleInGLEntry
    //       ChangeCycleInPIL
    //       ChangeCycleInPCL
    //       ChangeCycleInSIL
    //       ChangeCycleInSCL
    //       ChangeCycleInSSL
    //       ChangeCycleInPRL
    //       ChangeFunctionIsAllowed

    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Item Ledger Entry" = rimd;

    trigger OnRun()
    begin
    end;


    procedure GetNewCycleNo(): Code[20]
    var
        recInventorySetup: Record "Inventory Setup";
        codSerialNos: Code[20];
        cuNoSeriesMgt: Codeunit "No. Series";
        codNewNo: Code[20];
    begin
        recInventorySetup.Get;
        if recInventorySetup."Vehicle Acc. Cycle Nos." = '' then
            exit('');

        codSerialNos := recInventorySetup."Vehicle Acc. Cycle Nos.";
        codNewNo := cuNoSeriesMgt.GetNextNo(codSerialNos, WorkDate(), true);
        exit(codNewNo);
    end;


    procedure CheckCycleRelation(codSerialNo: Code[20]; codCycleNo: Code[20])
    var
        recVehAccCycle: Record "Vehicle Accounting Cycle";
    begin
        if codCycleNo = '' then
            exit;
        recVehAccCycle.Reset;
        recVehAccCycle.Get(codCycleNo);
        recVehAccCycle.TestField("Vehicle Serial No.", codSerialNo);
    end;


    procedure GetDefaultCycle(codSerialNo: Code[20]; codCycleNo: Code[20]): Code[20]
    var
        recVehAccCycle: Record "Vehicle Accounting Cycle";
    begin
        if codCycleNo = '' then
            exit('');

        if codSerialNo = '' then
            exit('');

        recVehAccCycle.Reset;
        recVehAccCycle.SetCurrentkey("Vehicle Serial No.");
        recVehAccCycle.SetRange("Vehicle Serial No.", codSerialNo);
        recVehAccCycle.SetRange(Default, true);
        if recVehAccCycle.FindFirst then
            exit(recVehAccCycle."No.")
        else
            exit('');
    end;


    procedure CreateNewCycle_User(var VehAccCycle: Record "Vehicle Accounting Cycle")
    var
        VehAccCycle2: Record "Vehicle Accounting Cycle";
    begin
        if VehAccCycle."Vehicle Serial No." = '' then
            exit;

        VehAccCycle2.Init;
        VehAccCycle2."No." := GetNewCycleNo;
        VehAccCycle2."Vehicle Serial No." := VehAccCycle."Vehicle Serial No.";
        VehAccCycle2.Insert;

        if VehAccCycle."No." = '' then
            SetAsDefault(VehAccCycle2);

        if VehAccCycle.Get(VehAccCycle2."No.") then;
    end;


    procedure SetAsDefault(VehAccCycle: Record "Vehicle Accounting Cycle")
    var
        VehAccCycle2: Record "Vehicle Accounting Cycle";
    begin
        VehAccCycle.TestField("No.");
        VehAccCycle.TestField("Vehicle Serial No.");
        VehAccCycle2.LockTable;
        VehAccCycle2.SetCurrentkey("Vehicle Serial No.");
        VehAccCycle2.SetRange("Vehicle Serial No.", VehAccCycle."Vehicle Serial No.");
        if VehAccCycle2.FindFirst then
            repeat
                if VehAccCycle2.Default then begin
                    VehAccCycle2.Default := false;
                    VehAccCycle2.Modify;
                end;
            until VehAccCycle2.Next = 0;

        VehAccCycle2.Get(VehAccCycle."No.");
        VehAccCycle2.Default := true;
        VehAccCycle2.Modify;
    end;


    procedure ChangeCycleInItemLedgerEntry(SourceILE: Record "Item Ledger Entry")
    var
        ILE: Record "Item Ledger Entry";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "Change Vehicle Cycle";
    begin
        ChangeFunctionIsAllowed;
        SourceILE.TestField("Entry No.");
        ILE.Reset;
        ILE.Get(SourceILE."Entry No.");

        Clear(ChangeCycle);

        ChangeCycle.SetData(Format(Database::"Item Ledger Entry"),
          Format(ILE."Entry No."),
          '',
           '',
          SourceILE."Serial No.",
          SourceILE."Vehicle Accounting Cycle No.");

        ChangeCycle.LookupMode(true);
        if ChangeCycle.RunModal = Action::LookupOK then begin
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            if CurrCycle <> NewCycle then begin
                ILE.Validate("Vehicle Accounting Cycle No.", NewCycle);
                ILE.Modify;
            end;
        end;
    end;

    procedure ChangeCycleInGLEntry(SourceGLE: Record "G/L Entry")
    var
        GLE: Record "G/L Entry";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "Change Vehicle Cycle";
    begin
        ChangeFunctionIsAllowed;
        SourceGLE.TestField("Entry No.");
        GLE.Reset;
        GLE.Get(SourceGLE."Entry No.");

        Clear(ChangeCycle);

        ChangeCycle.SetData(Format(Database::"G/L Entry"),
         Format(GLE."Entry No."),
         '',
         '',
         SourceGLE."Vehicle Serial No.",
         SourceGLE."Vehicle Accounting Cycle No.");

        ChangeCycle.LookupMode(true);
        if ChangeCycle.RunModal = Action::LookupOK then begin
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            if CurrCycle <> NewCycle then begin
                GLE.Validate("Vehicle Accounting Cycle No.", NewCycle);
                GLE.Modify;
            end;
        end;
    end;


    procedure ChangeCycleInPIL(SourcePIL: Record "Purch. Inv. Line")
    var
        PIL: Record "Purch. Inv. Line";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "Change Vehicle Cycle";
    begin
        ChangeFunctionIsAllowed;
        SourcePIL.TestField("Document No.");
        SourcePIL.TestField("Line No.");
        PIL.Reset;
        PIL.Get(SourcePIL."Document No.", SourcePIL."Line No.");

        Clear(ChangeCycle);

        ChangeCycle.SetData(Format(Database::"Purch. Inv. Line"),
         Format(PIL."Document No."),
         Format(PIL."Line No."),
         '',
         SourcePIL."Vehicle Serial No.",
         SourcePIL."Vehicle Accounting Cycle No.");

        ChangeCycle.LookupMode(true);
        if ChangeCycle.RunModal = Action::LookupOK then begin
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            if CurrCycle <> NewCycle then begin
                PIL.Validate("Vehicle Accounting Cycle No.", NewCycle);
                PIL.Modify;
            end;
        end;
    end;


    procedure ChangeCycleInPCL(SourcePCL: Record "Purch. Cr. Memo Line")
    var
        PCL: Record "Purch. Cr. Memo Line";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "Change Vehicle Cycle";
    begin
        ChangeFunctionIsAllowed;
        SourcePCL.TestField("Document No.");
        SourcePCL.TestField("Line No.");
        PCL.Reset;
        PCL.Get(SourcePCL."Document No.", SourcePCL."Line No.");

        Clear(ChangeCycle);

        ChangeCycle.SetData(Format(Database::"Purch. Cr. Memo Line"),
         Format(PCL."Document No."),
         Format(PCL."Line No."),
         '',
         SourcePCL."Vehicle Serial No.",
         SourcePCL."Vehicle Accounting Cycle No.");

        ChangeCycle.LookupMode(true);
        if ChangeCycle.RunModal = Action::LookupOK then begin
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            if CurrCycle <> NewCycle then begin
                PCL.Validate("Vehicle Accounting Cycle No.", NewCycle);
                PCL.Modify;
            end;
        end;
    end;


    procedure ChangeCycleInSIL(SourceSIL: Record "Sales Invoice Line")
    var
        SIL: Record "Sales Invoice Line";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "Change Vehicle Cycle";
    begin
        ChangeFunctionIsAllowed;
        SourceSIL.TestField("Document No.");
        SourceSIL.TestField("Line No.");
        SIL.Reset;
        SIL.Get(SourceSIL."Document No.", SourceSIL."Line No.");

        Clear(ChangeCycle);

        ChangeCycle.SetData(Format(Database::"Sales Invoice Line"),
         Format(SIL."Document No."),
         Format(SIL."Line No."),
         '',
         SourceSIL."Vehicle Serial No.",
         SourceSIL."Vehicle Accounting Cycle No.");

        ChangeCycle.LookupMode(true);
        if ChangeCycle.RunModal = Action::LookupOK then begin
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            if CurrCycle <> NewCycle then begin
                SIL.Validate("Vehicle Accounting Cycle No.", NewCycle);
                SIL.Modify;
            end;
        end;
    end;


    procedure ChangeCycleInSCL(SourceSCL: Record "Sales Cr.Memo Line")
    var
        SCL: Record "Sales Cr.Memo Line";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "Change Vehicle Cycle";
    begin
        ChangeFunctionIsAllowed;
        SourceSCL.TestField("Document No.");
        SourceSCL.TestField("Line No.");
        SCL.Reset;
        SCL.Get(SourceSCL."Document No.", SourceSCL."Line No.");

        Clear(ChangeCycle);

        ChangeCycle.SetData(Format(Database::"Sales Cr.Memo Line"),
         Format(SCL."Document No."),
         Format(SCL."Line No."),
         '',
         SourceSCL."Vehicle Serial No.",
         SourceSCL."Vehicle Accounting Cycle No.");

        ChangeCycle.LookupMode(true);
        if ChangeCycle.RunModal = Action::LookupOK then begin
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            if CurrCycle <> NewCycle then begin
                SCL.Validate("Vehicle Accounting Cycle No.", NewCycle);
                SCL.Modify;
            end;
        end;
    end;


    procedure ChangeCycleInSSL(SourceSSL: Record "Sales Shipment Line")
    var
        SSL: Record "Sales Shipment Line";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "Change Vehicle Cycle";
    begin
        ChangeFunctionIsAllowed;
        SourceSSL.TestField("Document No.");
        SourceSSL.TestField("Line No.");
        SSL.Reset;
        SSL.Get(SourceSSL."Document No.", SourceSSL."Line No.");

        Clear(ChangeCycle);

        ChangeCycle.SetData(Format(Database::"Sales Shipment Line"),
         Format(SSL."Document No."),
         Format(SSL."Line No."),
         '',
         SourceSSL."Vehicle Serial No.",
         SourceSSL."Vehicle Accounting Cycle No.");

        ChangeCycle.LookupMode(true);
        if ChangeCycle.RunModal = Action::LookupOK then begin
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            if CurrCycle <> NewCycle then begin
                SSL.Validate("Vehicle Accounting Cycle No.", NewCycle);
                SSL.Modify;
            end;
        end;
    end;


    procedure ChangeCycleInPRL(SourcePRL: Record "Purch. Rcpt. Line")
    var
        PRL: Record "Purch. Rcpt. Line";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "Change Vehicle Cycle";
    begin
        ChangeFunctionIsAllowed;
        SourcePRL.TestField("Document No.");
        SourcePRL.TestField("Line No.");
        PRL.Reset;
        PRL.Get(SourcePRL."Document No.", SourcePRL."Line No.");

        Clear(ChangeCycle);

        ChangeCycle.SetData(Format(Database::"Purch. Rcpt. Line"),
         Format(PRL."Document No."),
         Format(PRL."Line No."),
         '',
         SourcePRL."Vehicle Serial No.",
         SourcePRL."Vehicle Accounting Cycle No.");

        ChangeCycle.LookupMode(true);
        if ChangeCycle.RunModal = Action::LookupOK then begin
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            if CurrCycle <> NewCycle then begin
                PRL.Validate("Vehicle Accounting Cycle No.", NewCycle);
                PRL.Modify;
            end;
        end;
    end;


    procedure ChangeFunctionIsAllowed()
    var
        UserSetup: Record "User Setup";
        Text001: label 'You non''t have permission to run this function';
    begin
        UserSetup.Reset;
        UserSetup.Get(UserId);
        if not UserSetup."Veh. Acc. Cycle Change Funct." then
            Error(Text001);
    end;
}

