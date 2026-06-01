/*
Codeunit 25006700 "SIE Management"
{
    // 29.12.2014 EDMS P11
    //   Changed version of Timer variable from 7.0.0.0 to 8.0.0.0
    // 
    // 13.11.2007 P3
    //   * Disabled timer stop to retry attempts every 3 minutes

    SingleInstance = true;

    trigger OnRun()
    begin
        SIESetup.Get;
        LogFileName := GetLogFileName();
        BringSystemMsg(Text002);

        // Clear(Timer);
        // Timer := Timer.Timer();
        // Timer.Interval(SIESetup."Synch. Interval (sec)" * 1000);
        // Timer.Start();
    end;

    var
        SpecInvtEquip: Record "Special Inventory Equipment";
        SIESetup: Record "SIE Setup";
        RunTimeParams: Record "SIE Run-Time Params" temporary;
        SIEXMLExch: Codeunit "SIE Exchange Mgt.";
        Text001: label 'This SIE Entry is not active. Are you sure you want to synchronize?';
        Text002: label 'SIE inside NAS has started!';
        DocumentManagementDMS: Codeunit DocumentManagementDMS;
        PingCounter: Integer;
        LogFileName: Text[1024];
    // Timer: dotnet Timer;


    procedure SIESinhronize(SpecInvtEquip: Record "Special Inventory Equipment")
    begin
        with SpecInvtEquip do begin
            if not Active then begin
                if GuiAllowed then
                    if not Dialog.Confirm(Text001, true) then
                        exit
                    else begin
                        BringSystemMsg(Text001);
                        exit;
                    end;
            end;
        end;
        with RunTimeParams do begin
            "DSN Name" := SpecInvtEquip."DSN Name";
            "Run Mode" := RunTimeParams."run mode"::Synchronize;
            Direction := Direction::Export;
            "SIE No." := SpecInvtEquip."No.";
        end;
        Codeunit.Run(SpecInvtEquip."Control Unit", RunTimeParams);
        SIEXMLExch.Run;
    end;


    procedure LookUpSIEObject(var SIEObject: Record "SIE Object"; SIENo: Code[10]; codNo: Code[20]): Boolean
    var
        SIEObjectList: Page "SIE Object List";
    begin
        Clear(SIEObjectList);
        if codNo <> '' then
            if SIEObject.Get(codNo) then
                SIEObjectList.SetRecord(SIEObject);
        SIEObjectList.SetTableview(SIEObject);
        SIEObjectList.LookupMode(true);
        if SIEObjectList.RunModal = Action::LookupOK then begin
            SIEObjectList.GetRecord(SIEObject);
            exit(true)
        end;
        exit(false)
    end;


    procedure SIEValidateField(var JnlLine: Record "SIE Journal Line"; FldNo: Integer)
    begin
        SpecInvtEquip.Reset;
        SpecInvtEquip.Get(JnlLine."SIE No.");
        //COMMENT1
        JnlLine."To Validate Field" := FldNo;
        JnlLine."To Validate Field" := FldNo;
        JnlLine."To Validate Field" := FldNo;
        Codeunit.Run(SpecInvtEquip."Posting Unit", JnlLine);
    end;


    procedure SIEPostJnl(var SIEJnlLine: Record "SIE Journal Line")
    begin
        SpecInvtEquip.Reset;
        SpecInvtEquip.Get(SIEJnlLine."SIE No.");
        SIEJnlLine.SetRange("SIE No.", SIEJnlLine."SIE No.");
        Codeunit.Run(SpecInvtEquip."Posting Unit", SIEJnlLine);
    end;


    procedure CheckReminders()
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) or not UserSetup."SIE management" then exit;
        with SpecInvtEquip do begin
            Reset;
            SetRange(Active, true);
            if FindFirst then
                repeat
                    if ("Check 1" and ("Check 1 Show Reminder" = "check 1 show reminder"::Checked)) or
                       (not "Check 1" and ("Check 1 Show Reminder" = "check 1 show reminder"::Unchecked))
                    then
                        if GuiAllowed then
                            BringSystemMsg(SpecInvtEquip."Check 1 Reminder Msg");
                until Next = 0;
        end
    end;


    procedure GetLogFileName(): Text[1024]
    begin
        SIESetup.Get;
        if SIESetup."Processing Log Active" then
            exit(SIESetup."Processing Log Path" + 'SIEmgtLogFile.log')
        else
            exit('');
    end;


    procedure BringSystemMsg(TextPar: Text[1024])
    var
        BText: Text;
    begin
        if SIESetup."Processing Log Active" then begin
            //BText.AddText('Log at ' + Format(Time()) + ' ');
            BText := BText + 'Log at ' + Format(Time()) + ' ';
            //BText.AddText(' ' + TextPar);
            BText := BText + ' ' + TextPar;
            DocumentManagementDMS.WriteBigTextToFile(BText, LogFileName);
        end else
            Message(TextPar);

        exit;
    end;

    
    // trigger Timer::Elapsed(sender: Variant;e: dotnet EventArgs)
    // begin
    // end;

    // trigger Timer::ExceptionOccurred(sender: Variant;e: dotnet ExceptionOccurredEventArgs)
    // begin
    // end;
    
}
*/