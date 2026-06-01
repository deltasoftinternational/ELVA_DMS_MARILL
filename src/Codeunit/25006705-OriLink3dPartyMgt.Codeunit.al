/*
Codeunit 25006705 "OriLink 3d Party Mgt."
{
    SingleInstance = true;
    TableNo = "SIE Run-Time Params";

    trigger OnRun()
    begin
        //17.02.2015 Elva Baltic P1 - temp commented
        
        // SIENo := Rec."SIE No.";
        // IF "Run Mode" = "Run Mode"::Post THEN BEGIN
        //   AutoPostJnl("Posting Unit");
        //   IF "Asignment Unit" > 0 THEN
        //     AutoAsign("Asignment Unit");
        //   EXIT
        // END;
        
        // IF ISCLEAR(CC2) THEN
        //   CREATE(CC2, FALSE, TRUE);
        
        // IF ISCLEAR(SBA) THEN
        //   CREATE(SBA, FALSE, TRUE);
        
        // //IF ISCLEAR(XMLDom) THEN
        // //  CREATE(XMLDom);
        
        // CC2.AddBusAdapter(SBA, 0);
        
        // IF NOT SocketOpened THEN BEGIN
        //  SBA.OpenSocket(8077, ' ');
        //  SocketOpened := TRUE;
        // END;    
    end;

    var
        SocketOpened: Boolean;
        Text010: label '';
        //XMLElement: Automation ;
        //XMLNode: Automation ;
        //XMLNodeList: Automation ;
        RequestType: Option Unknown,JobNo,FWT;
        txt: Text[30];
        Text011: label '';
        Text020: label 'Error in parsing Job No.';
        SIENo: Code[10];
        Text030: label 'Is going to AutoPostJnl via C %1 with SIEJnl filtered by %2, first record No: %3.';


    procedure GetRequestType(): Integer
    begin
    end;


    procedure ProcessJobValidation(var OutS: OutStream)
    var
        JobNo: Code[20];
        ResponseNo: Integer;
        ResponseText: Text[1000];
        TestFile: File;
        ServHeader: Record "Service Header EDMS";
        CustName: Text[30];
    begin
    end;


    procedure ProcessFWT(var OutS: OutStream)
    var
        ResponseText: Text[1000];
        TestFile: File;
    begin

        FillSIEJnl;

        //Creating Response Text
        ResponseText := '<?xml version="1.0" encoding="ISO-8859-1"?> ';
        ResponseText += '<Oil_Issue>';
        ResponseText += '<Result>0</Result>';
        ResponseText += '<Description>Accepted</Description>';
        ResponseText += '</Oil_Issue>';
        ResponseText += '                                                             ';
        ResponseText += '                                                             ';
        ResponseText += '                                                             ';
        ResponseText += '                                                             ';
        OutS.WriteText(ResponseText);
    end;


    procedure FillSIEJnl()
    var
        SIEJnlLine: Record "SIE Journal Line";
        LineNo: Integer;
        Day: Integer;
        Month: Integer;
        Year: Integer;
        HoursText: Text[2];
        MinutesText: Text[2];
        SecondsText: Text[2];
        NewTime: Time;
    begin
    end;


    procedure AutoPostJnl(PostingUnit: Integer)
    var
        JnlLine: Record "SIE Journal Line";
        SAMOAJnlPost: Codeunit "SAMOA SIE Jnl.-Post";
    begin
        Clear(JnlLine);
        JnlLine.SetRange("SIE No.", SIENo);
        if not JnlLine.FindFirst then exit;
        if not GuiAllowed then
            Message(Text030, PostingUnit, SIENo, JnlLine."Line No.");
        Codeunit.Run(PostingUnit, JnlLine);
    end;


    procedure AutoAsign(AutoAsignUnit: Integer)
    var
        JnlLine: Record "SIE Journal Line";
        SAMOAJnlPost: Codeunit "SAMOA SIE Jnl.-Post";
    begin
        Codeunit.Run(AutoAsignUnit);
    end;


    procedure JobNoIsValid(JobNo: Code[20]): Boolean
    var
        ServHeader: Record "Service Header EDMS";
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
    begin
        ServHeader.Reset;
        if not ServHeader.Get(ServHeader."document type"::Order, JobNo) then
            exit(false);

        exit(true);
    end;
}
*/
