Codeunit 25006515 "BLS Jnl.-Check Line"
{

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        Contract: Record Contract;
        Customer: Record Customer;
        BLSObject: Record "BLS Object";
        Service: Record "BLS Service";
        vendor: Record Vendor;
        DimMgt: Codeunit DimensionManagement;
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        Text000: label 'cannot be a closing date';
        Text001: label 'is not within your range of allowed posting dates';
        Text002: label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text003: label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';


    procedure RunCheck(var BLSJnlLine: Record "BLS Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        if BLSJnlLine.EmptyLine then
            exit;

        BLSJnlLine.TestField("Posting Date");
        BLSJnlLine.TestField("Document No.");

        if BLSJnlLine."Posting Date" <> NormalDate(BLSJnlLine."Posting Date") then
            BLSJnlLine.FieldError("Posting Date", Text000);

        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            if UserId <> '' then
                if UserSetup.Get(UserId) then begin
                    AllowPostingFrom := UserSetup."Allow Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                end;
            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                GLSetup.Get;
                AllowPostingFrom := GLSetup."Allow Posting From";
                AllowPostingTo := GLSetup."Allow Posting To";
            end;
            if AllowPostingTo = 0D then
                AllowPostingTo := 99991231D;
        end;
        if (BLSJnlLine."Posting Date" < AllowPostingFrom) or (BLSJnlLine."Posting Date" > AllowPostingTo) then
            BLSJnlLine.FieldError("Posting Date", Text001);

        if BLSJnlLine."Document Date" <> 0D then
            if BLSJnlLine."Document Date" <> NormalDate(BLSJnlLine."Document Date") then
                BLSJnlLine.FieldError("Document Date", Text000);

        BLSJnlLine.TestField("Customer No.");
        Customer.Get(BLSJnlLine."Customer No.");
        Customer.TestField(Blocked, Customer.Blocked::" ");

        if BLSJnlLine."Contract No." <> '' then begin
            begin
                Contract.Get(BLSJnlLine."Contract No.");
                BLSJnlLine.TestField("Customer No.", Contract."Bill-to Customer No.");
                Contract.TestField(Status, Contract.Status::Active);
            end;
        end;

        BLSJnlLine.TestField("Service Code");
        //TESTFIELD(Quantity);  //15.08.2017 EB.RC POD.Billing P439.WSH49
        Service.Get(BLSJnlLine."Service Code");
        Service.TestField(Blocked, false);

        if Service."Service Variant Mandatory" then
            BLSJnlLine.TestField("Service Variant Code");
        if BLSJnlLine."Service Variant Code" <> '' then begin
            // ServiceVariant.GET("Service Code", "Service Variant Code");
            // ServiceVariant.TESTFIELD(Blocked, FALSE);
        end;

        if Service."Object Mandatory" then begin
            BLSJnlLine.TestField("Object Code");
            BLSObject.Get(BLSJnlLine."Object Code");
            BLSObject.TestField("Object Type", BLSObject."object type"::Standard);
            BLSObject.TestField(Blocked, false);
        end;
        /*
          IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
            ERROR(
              Text002,
              TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
              DimMgt.GetDimCombErr);

          TableID[1] := DATABASE::Resource;
          No[1] := "Resource No.";
          TableID[2] := DATABASE::"Resource Group";
          No[2] := "Resource Group No.";
          IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
            IF "Line No." <> 0 THEN
              ERROR(
                Text003,
                TABLECAPTION,"Journal Template Name","Journal Batch Name","Line No.",
                DimMgt.GetDimValuePostingErr)
            ELSE
              ERROR(DimMgt.GetDimValuePostingErr);
         */

    end;
}

