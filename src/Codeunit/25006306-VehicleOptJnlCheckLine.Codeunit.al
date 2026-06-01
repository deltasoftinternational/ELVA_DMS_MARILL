Codeunit 25006306 "Vehicle Opt. Jnl.-Check Line"
{
    // //==================================================================================================================================
    // Mērķis: Pirms grāmatošanas pārbaudīt žurnāla rindu uz pareizību.
    // //==================================================================================================================================

    TableNo = "Vehicle Opt. Jnl. Line";

    trigger OnRun()
    begin
        recGLSetup.Get;
        fRunCheck(Rec);
    end;

    var
        Text000: label 'cannot be a closing date';
        Text001: label 'is not within your range of allowed posting dates';
        recUserSetup: Record "User Setup";
        datAllowPostingFrom: Date;
        datAllowPostingTo: Date;
        recGLSetup: Record "General Ledger Setup";


    procedure fRunCheck(var recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        recVehOptJnlLine5: Record "Vehicle Opt. Jnl. Line";
        recVehicle: Record Vehicle;
    begin
        //Pārbaudam datumus
        recVehOptJnlLine.TestField("Posting Date");
        recVehOptJnlLine.TestField("Document No.");
        if recVehOptJnlLine."Posting Date" <> NormalDate(recVehOptJnlLine."Posting Date") then
            recVehOptJnlLine.FieldError("Posting Date", Text000);

        recVehOptJnlLine.TestField("Vehicle Serial No.");
        recVehOptJnlLine.TestField("Make Code");
        recVehOptJnlLine.TestField("Model Code");
        recVehOptJnlLine.TestField("Model Version No.");

        //Pārbaudam grāmatošanas datuma robežas
        recGLSetup.Get;
        if (datAllowPostingFrom = 0D) and (datAllowPostingTo = 0D) then begin
            if UserId <> '' then
                if recUserSetup.Get(UserId) then begin
                    datAllowPostingFrom := recUserSetup."Allow Posting From";
                    datAllowPostingTo := recUserSetup."Allow Posting To";
                end;
            if (datAllowPostingFrom = 0D) and (datAllowPostingTo = 0D) then begin
                datAllowPostingFrom := recGLSetup."Allow Posting From";
                datAllowPostingTo := recGLSetup."Allow Posting To";
            end;
            if datAllowPostingTo = 0D then
                datAllowPostingTo := 99991231D;
        end;
        if (recVehOptJnlLine."Posting Date" < datAllowPostingFrom) or (recVehOptJnlLine."Posting Date" > datAllowPostingTo) then
            recVehOptJnlLine.FieldError("Posting Date", Text001);

        if (recVehOptJnlLine."Document Date" <> 0D) then
            if (recVehOptJnlLine."Document Date" <> NormalDate(recVehOptJnlLine."Document Date")) then
                recVehOptJnlLine.FieldError("Document Date", Text000);

        if recVehOptJnlLine."Entry Type" = recVehOptJnlLine."entry type"::Disassemble then
            recVehOptJnlLine.TestField("Applies-to Entry");
        if (recVehOptJnlLine."Entry Type" = recVehOptJnlLine."entry type"::Assemble) and recVehOptJnlLine.Correction then
            recVehOptJnlLine.TestField("Applies-to Entry");

        recVehicle.Reset;
        recVehicle.SetCurrentkey("Serial No.");
        recVehicle.SetRange("Serial No.", recVehOptJnlLine."Vehicle Serial No.");
        if recVehicle.FindFirst then begin
            recVehicle.TestField("Make Code", recVehOptJnlLine."Make Code");
            recVehicle.TestField("Model Code", recVehOptJnlLine."Model Code");
            recVehicle.TestField("Model Version No.", recVehOptJnlLine."Model Version No.");
            /*if "Option Type" = "option type"::"Own Option" then
             begin
              recVehicle.CalcFields(Inventory);
              recVehicle.TestField(recVehicle.Inventory,1);
             end;*/
        end;
    end;
}

