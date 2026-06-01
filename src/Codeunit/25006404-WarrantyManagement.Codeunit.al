Codeunit 25006404 "Warranty Management"
{
    // 06.10.2017 EB.AKR Warranty
    //   Modified Function:
    //     CreateWarrantyDocumentService
    //     CreateWarrantyDocument


    trigger OnRun()
    begin
    end;

    var
        Text001: label 'Warranty Document Nr. %1 created.';


    procedure CreateWarrantyDocument(var PstdServiceOrderHeader: Record "Posted Serv. Order Header")
    var
        PstdServiceOrderLine: Record "Posted Serv. Order Line";
        SelectedRecord: Record "Posted Serv. Order Line";
        WarrantyPstdServiceLine: Page "Warranty Pstd. Service Line";
        Selected: Text[250];
        NewWarrantyHeader: Record "Warranty Document Header";
        NewWarrantyLine: Record "Warranty Document Line";
        PstdServLineNoFilter: Text[250];
        ExistingWarrantyDocumentLine: Record "Warranty Document Line";
    begin
        PstdServiceOrderLine.Reset;
        PstdServiceOrderLine.SetRange("Document No.", PstdServiceOrderHeader."No.");
        // IF PstdServiceOrderLine.FINDFIRST THEN
        //  REPEAT
        //    ExistingWarrantyDocumentLine.RESET;
        //    ExistingWarrantyDocumentLine.SETRANGE("Service Order No.",PstdServiceOrderLine."Document No.");
        //    ExistingWarrantyDocumentLine.SETRANGE("Service Order Line No.",PstdServiceOrderLine."Line No.");
        //    IF NOT ExistingWarrantyDocumentLine.FINDFIRST THEN
        //      PstdServiceOrderLine.MARK(TRUE);
        //  UNTIL PstdServiceOrderLine.NEXT = 0;
        // PstdServiceOrderLine.MARKEDONLY(TRUE);

        WarrantyPstdServiceLine.SetTableview(PstdServiceOrderLine);
        WarrantyPstdServiceLine.LookupMode(true);
        WarrantyPstdServiceLine.Editable(false);
        if WarrantyPstdServiceLine.RunModal = Action::LookupOK then begin
            SelectedRecord := PstdServiceOrderLine;
            WarrantyPstdServiceLine.SetSelected(SelectedRecord);
            SelectedRecord.MarkedOnly(true);
            if SelectedRecord.FindFirst then begin
                CreateWarrantyHeader(NewWarrantyHeader);
                NewWarrantyHeader."Service Order No." := PstdServiceOrderHeader."No.";
                NewWarrantyHeader."Initial Service Order No." := PstdServiceOrderHeader."Initial Service Order No.";  //06.10.2017 EB.AKR Warranty
                NewWarrantyHeader."Service Order Sequence No." := GetServWarrantyDocSequence(PstdServiceOrderHeader."Initial Service Order No.");
                NewWarrantyHeader."Deal Type" := PstdServiceOrderHeader."Deal Type Code";
                NewWarrantyHeader."Vehicle Serial No." := PstdServiceOrderHeader."Vehicle Serial No.";
                NewWarrantyHeader."Vehicle Registration No." := PstdServiceOrderHeader."Vehicle Registration No.";
                NewWarrantyHeader."Vehicle Status Code" := PstdServiceOrderHeader."Vehicle Status Code";
                NewWarrantyHeader."Vehicle Accounting Cycle No." := PstdServiceOrderHeader."Vehicle Accounting Cycle No.";
                NewWarrantyHeader.VIN := PstdServiceOrderHeader.VIN;
                NewWarrantyHeader."Make Code" := PstdServiceOrderHeader."Make Code";
                NewWarrantyHeader."Model Code" := PstdServiceOrderHeader."Model Code";
                NewWarrantyHeader."Model Commercial Name" := PstdServiceOrderHeader."Model Commercial Name";
                NewWarrantyHeader."Model Version No." := PstdServiceOrderHeader."Model Version No.";
                NewWarrantyHeader."Repair Date" := GetLatestLaborDate(PstdServiceOrderHeader);
                NewWarrantyHeader."Variable Field Run 1" := PstdServiceOrderHeader."Variable Field Run 1";
                NewWarrantyHeader."Variable Field Run 2" := PstdServiceOrderHeader."Variable Field Run 2";
                NewWarrantyHeader.Modify;
                repeat
                    CreateWarrantyLine(NewWarrantyHeader, NewWarrantyLine);
                    NewWarrantyLine."Initial Service Order No." := PstdServiceOrderHeader."Initial Service Order No.";
                    NewWarrantyLine."Service Order No." := SelectedRecord."Document No.";
                    NewWarrantyLine."Service Order Line No." := SelectedRecord."Line No.";
                    NewWarrantyLine.Validate(Type, SelectedRecord.Type);
                    NewWarrantyLine.Validate("No.", SelectedRecord."No.");
                    NewWarrantyLine.Validate(Description, SelectedRecord.Description);
                    NewWarrantyLine.Validate("Unit Price", SelectedRecord."Unit Price");
                    NewWarrantyLine.Validate(Quantity, SelectedRecord.Quantity);
                    NewWarrantyLine.Validate("Standard Time", SelectedRecord."Standard Time");
                    NewWarrantyLine.Validate("Make Code", SelectedRecord."Make Code");
                    NewWarrantyLine.Validate("Labor Type", PstdServiceOrderLine."Labor Type"); //06.10.2017 EB.AKR Warranty
                    NewWarrantyLine.Modify;
                until SelectedRecord.Next = 0;

                //Copy Comments from Service Order to Warranty Document
                CopyWarrantyComments(PstdServiceOrderHeader, NewWarrantyHeader);

                if NewWarrantyHeader."No." <> '' then
                    Message(Text001, NewWarrantyHeader."No.");
            end;
        end;
    end;


    procedure CreateWarrantyHeader(var WarrantyDocumentHeader: Record "Warranty Document Header")
    begin
        Clear(WarrantyDocumentHeader);
        WarrantyDocumentHeader.Reset;
        WarrantyDocumentHeader.Init;
        WarrantyDocumentHeader.Insert(true);
    end;


    procedure CreateWarrantyLine(WarrantyDocumentHeader: Record "Warranty Document Header"; var WarrantyDocumentLine: Record "Warranty Document Line")
    var
        LineNo: Integer;
    begin
        WarrantyDocumentLine.Reset;
        WarrantyDocumentLine.SetRange("Document No.", WarrantyDocumentHeader."No.");
        if WarrantyDocumentLine.FindLast then
            LineNo := WarrantyDocumentLine."Line No.";

        WarrantyDocumentLine.Reset;
        WarrantyDocumentLine.Init;
        WarrantyDocumentLine."Document No." := WarrantyDocumentHeader."No.";
        WarrantyDocumentLine."Line No." := LineNo + 10000;
        WarrantyDocumentLine.Insert(true);
    end;

    local procedure GetServWarrantyDocSequence(ServiceDocumentNo: Code[20]) SequenceNo: Integer
    var
        WarrantyDocumentHeader: Record "Warranty Document Header";
    begin
        WarrantyDocumentHeader.Reset;
        WarrantyDocumentHeader.SetRange("Initial Service Order No.", ServiceDocumentNo);
        if WarrantyDocumentHeader.FindLast then
            SequenceNo := WarrantyDocumentHeader."Service Order Sequence No." + 1
        else
            SequenceNo := 1;
    end;

    local procedure GetPstdServLineNoFilter(ServiceDocumentNo: Code[20]) LineNoFilter: Text[250]
    var
        WarrantyDocumentLine: Record "Warranty Document Line";
    begin
        WarrantyDocumentLine.Reset;
        WarrantyDocumentLine.SetRange("Service Order No.", ServiceDocumentNo);
        if WarrantyDocumentLine.FindFirst then
            repeat
                LineNoFilter += '<>' + Format(WarrantyDocumentLine."Line No.") + '&';
            until WarrantyDocumentLine.Next = 0;

        if LineNoFilter <> '' then
            LineNoFilter := DelChr(LineNoFilter, '>', '&');
    end;

    local procedure GetLatestLaborDate(var PostedServOrderHeader: Record "Posted Serv. Order Header"): Date
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
    begin
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetCurrentkey(Date);
        ResourceTimeRegEntry.SetRange("Source Type", ResourceTimeRegEntry."source type"::"Service Document");
        ResourceTimeRegEntry.SetRange("Source Subtype", ResourceTimeRegEntry."source subtype"::Order);
        ResourceTimeRegEntry.SetRange("Source ID", PostedServOrderHeader."Order No.");
        ResourceTimeRegEntry.SetRange(Travel, false);
        ResourceTimeRegEntry.SetRange(Canceled, false);
        if ResourceTimeRegEntry.FindLast then
            exit(ResourceTimeRegEntry.Date);
    end;

    local procedure CopyWarrantyComments(var PstdServiceOrderHeader: Record "Posted Serv. Order Header"; var WarrantyDocumentHeader: Record "Warranty Document Header")
    var
        ServiceCommentLine: Record "Service Comment Line EDMS";
        NewServiceCommentLine: Record "Service Comment Line EDMS";
        LineNo: Integer;
    begin
        ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Posted Service Order");
        ServiceCommentLine.SetRange("No.", PstdServiceOrderHeader."No.");
        if ServiceCommentLine.FindFirst then begin
            NewServiceCommentLine.Reset;
            NewServiceCommentLine.SetRange("No.", WarrantyDocumentHeader."No.");
            NewServiceCommentLine.SetRange(Type, NewServiceCommentLine.Type::"Warranty Doc");
            if NewServiceCommentLine.FindLast then
                LineNo := NewServiceCommentLine."Line No.";
            repeat
                LineNo += 10000;
                NewServiceCommentLine.Init;
                NewServiceCommentLine."Line No." := LineNo;
                NewServiceCommentLine."No." := WarrantyDocumentHeader."No.";
                NewServiceCommentLine.Type := NewServiceCommentLine.Type::"Warranty Doc";
                NewServiceCommentLine.Comment := ServiceCommentLine.Comment;
                NewServiceCommentLine.Date := ServiceCommentLine.Date;
                NewServiceCommentLine."Comment Type Code" := ServiceCommentLine."Comment Type Code";
                NewServiceCommentLine."User ID" := ServiceCommentLine."User ID";
                NewServiceCommentLine.Insert;
            until ServiceCommentLine.Next = 0;
        end;
    end;

    local procedure CopyWarrantyCommentsService(var ServiceHeader: Record "Service Header EDMS"; var WarrantyDocumentHeader: Record "Warranty Document Header")
    var
        ServiceCommentLine: Record "Service Comment Line EDMS";
        NewServiceCommentLine: Record "Service Comment Line EDMS";
        LineNo: Integer;
    begin
        ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Service Order");
        ServiceCommentLine.SetRange("No.", ServiceHeader."No.");
        if ServiceCommentLine.FindFirst then begin
            NewServiceCommentLine.Reset;
            NewServiceCommentLine.SetRange("No.", WarrantyDocumentHeader."No.");
            NewServiceCommentLine.SetRange(Type, NewServiceCommentLine.Type::"Warranty Doc");
            if NewServiceCommentLine.FindLast then
                LineNo := NewServiceCommentLine."Line No.";
            repeat
                LineNo += 10000;
                NewServiceCommentLine.Init;
                NewServiceCommentLine."Line No." := LineNo;
                NewServiceCommentLine."No." := WarrantyDocumentHeader."No.";
                NewServiceCommentLine.Type := NewServiceCommentLine.Type::"Warranty Doc";
                NewServiceCommentLine.Comment := ServiceCommentLine.Comment;
                NewServiceCommentLine.Date := ServiceCommentLine.Date;
                NewServiceCommentLine."Comment Type Code" := ServiceCommentLine."Comment Type Code";
                NewServiceCommentLine."User ID" := ServiceCommentLine."User ID";
                NewServiceCommentLine.Insert;
            until ServiceCommentLine.Next = 0;
        end;
    end;

    local procedure GetLatestLaborDateService(var ServiceHeader: Record "Service Header EDMS"): Date
    var
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";
    begin
        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetCurrentkey(Date);
        ResourceTimeRegEntry.SetRange("Source Type", ResourceTimeRegEntry."source type"::"Service Document");
        ResourceTimeRegEntry.SetRange("Source Subtype", ResourceTimeRegEntry."source subtype"::Order);
        ResourceTimeRegEntry.SetRange("Source ID", ServiceHeader."No.");
        ResourceTimeRegEntry.SetRange(Travel, false);
        ResourceTimeRegEntry.SetRange(Canceled, false);
        if ResourceTimeRegEntry.FindLast then
            exit(ResourceTimeRegEntry.Date);
    end;


    procedure CreateWarrantyDocumentService(var ServiceHeader: Record "Service Header EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
        SelectedRecord: Record "Service Line EDMS";
        WarrantyPstdServiceLine: Page "Warranty Service Line";
        Selected: Text[250];
        NewWarrantyHeader: Record "Warranty Document Header";
        NewWarrantyLine: Record "Warranty Document Line";
        PstdServLineNoFilter: Text[250];
        ExistingWarrantyDocumentLine: Record "Warranty Document Line";
    begin
        ServiceLine.Reset;
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        //IF ServiceHeader.FINDFIRST THEN
        //  REPEAT
        //    ExistingWarrantyDocumentLine.RESET;
        //    ExistingWarrantyDocumentLine.SETRANGE("Service Order No.",ServiceLine."Document No.");
        //    ExistingWarrantyDocumentLine.SETRANGE("Service Order Line No.",ServiceLine."Line No.");
        //    IF NOT ExistingWarrantyDocumentLine.FINDFIRST THEN
        //      ServiceLine.MARK(TRUE);
        //  UNTIL ServiceLine.NEXT = 0;
        //ServiceLine.MARKEDONLY(TRUE);

        WarrantyPstdServiceLine.SetTableview(ServiceLine);
        WarrantyPstdServiceLine.LookupMode(true);
        WarrantyPstdServiceLine.Editable(false);
        if WarrantyPstdServiceLine.RunModal = Action::LookupOK then begin
            SelectedRecord := ServiceLine;
            WarrantyPstdServiceLine.SetSelected(SelectedRecord);
            SelectedRecord.MarkedOnly(true);
            if SelectedRecord.FindFirst then begin
                CreateWarrantyHeader(NewWarrantyHeader);
                NewWarrantyHeader."Service Order No." := ServiceHeader."No.";
                NewWarrantyHeader."Initial Service Order No." := ServiceHeader."Initial Service Order No.";
                NewWarrantyHeader."Service Order Sequence No." := GetServWarrantyDocSequence(ServiceHeader."Initial Service Order No.");  //06.10.2017 EB.AKR Warranty
                NewWarrantyHeader."Deal Type" := ServiceHeader."Deal Type";
                NewWarrantyHeader."Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
                NewWarrantyHeader."Vehicle Registration No." := ServiceHeader."Vehicle Registration No.";
                NewWarrantyHeader."Vehicle Status Code" := ServiceHeader."Vehicle Status Code";
                NewWarrantyHeader."Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";
                NewWarrantyHeader.VIN := ServiceHeader.VIN;
                NewWarrantyHeader."Make Code" := ServiceHeader."Make Code";
                NewWarrantyHeader."Model Code" := ServiceHeader."Model Code";
                NewWarrantyHeader."Model Commercial Name" := ServiceHeader."Model Commercial Name";
                NewWarrantyHeader."Model Version No." := ServiceHeader."Model Version No.";
                NewWarrantyHeader."Repair Date" := GetLatestLaborDateService(ServiceHeader);
                NewWarrantyHeader."Variable Field Run 1" := ServiceHeader."Variable Field Run 1";
                NewWarrantyHeader."Variable Field Run 2" := ServiceHeader."Variable Field Run 2";
                NewWarrantyHeader."Initial Service Order No." := ServiceHeader."Initial Service Order No.";
                NewWarrantyHeader.Modify;
                repeat
                    CreateWarrantyLine(NewWarrantyHeader, NewWarrantyLine);
                    NewWarrantyLine."Service Order No." := SelectedRecord."Document No.";
                    NewWarrantyLine."Initial Service Order No." := NewWarrantyHeader."Initial Service Order No."; //06.10.2017 EB.AKR Warranty
                    NewWarrantyLine."Service Order Line No." := SelectedRecord."Line No.";
                    NewWarrantyLine.Validate(Type, SelectedRecord.Type);
                    NewWarrantyLine.Validate("No.", SelectedRecord."No.");
                    NewWarrantyLine.Validate(Description, SelectedRecord.Description);
                    NewWarrantyLine.Validate("Unit Price", SelectedRecord."Unit Price");
                    NewWarrantyLine.Validate(Quantity, SelectedRecord.Quantity);
                    NewWarrantyLine.Validate("Standard Time", SelectedRecord."Standard Time");
                    NewWarrantyLine.Validate("Make Code", SelectedRecord."Make Code");
                    NewWarrantyLine.Validate("Labor Type", ServiceLine."Labor Type");
                    NewWarrantyLine.Modify;
                until SelectedRecord.Next = 0;

                //Copy Comments from Service Order to Warranty Document
                CopyWarrantyCommentsService(ServiceHeader, NewWarrantyHeader);

                if NewWarrantyHeader."No." <> '' then
                    Message(Text001, NewWarrantyHeader."No.");
            end;
        end;
    end;
}

