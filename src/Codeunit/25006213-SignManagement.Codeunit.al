Codeunit 25006213 "Sign Management"
{
    // 03.11.2023 EB.RC
    //  Refactored.


    trigger OnRun()
    begin
    end;

    var
        SaveFileDialogTitleMsg: label 'Save PDF file';
        SaveFileDialogFilterMsg: label 'PDF Files (*.pdf)|*.pdf';
        NoPrintoutErr: Label 'There is no printout.';

    procedure S___()
    begin

    end;

    procedure CallSignPageService(var Rec: Record "Service Header EDMS"; var TempBlob: Codeunit "Temp Blob"; var AttachmentFileName: Text)
    var
        DocMgt: Codeunit DocumentManagementDMS;
        DocReport: Record "Document Report";
        PreviewAndSign: Page "Preview And Sign";
        ServiceHeader: Record "Service Header EDMS";
        RepSelect: Record "Document Report";
        RepCount: Integer;
    begin
        Rec.SetRange("Document Type", Rec."Document Type");
        Rec.SetRange("No.", Rec."No.");
        RepSelect.Reset;
        DocMgt.PrintCurrentDoc(3, 3, 1, RepSelect);
        RepSelect.SetRange("Customer Signature", true);
        RepCount := RepSelect.Count;
        if RepCount = 0 then
            exit;

        if RepCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", RepSelect) <> Action::LookupOK then
                exit;
        end else
            RepSelect.FindFirst;


        AttachmentFileName := DocMgt.SaveServiceHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");
        Commit;

        PreviewAndSign.SetValues('Service Order', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'CUSTOMER');
        if PreviewAndSign.RunModal = Action::OK then begin
            if ServiceHeader.Get(Rec."Document Type", Rec."No.") then begin
                ServiceHeader."Customer Signature Text" := PreviewAndSign.GetName();
                ServiceHeader.Modify;
                Commit;
            end;
        end;
        if RepSelect."Employee Signature" then begin
            Clear(PreviewAndSign);
            PreviewAndSign.SetValues('Service Order', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'EMPLOYEE');
            if PreviewAndSign.RunModal = Action::OK then begin
                if ServiceHeader.Get(Rec."Document Type", Rec."No.") then begin
                    ServiceHeader."Employee Signature Text" := PreviewAndSign.GetName();
                    ServiceHeader.Modify;
                    Commit;
                end;
            end;
        end;

        AttachmentFileName := DocMgt.SaveServiceHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");

        if ServiceHeader.Get(Rec."Document Type", Rec."No.") then begin
            Clear(ServiceHeader."Customer Signature Image");
            Clear(ServiceHeader."Customer Signature Text");
            Clear(ServiceHeader."Employee Signature Image");
            Clear(ServiceHeader."Employee Signature Text");
            ServiceHeader.Modify;
        end;
    end;

    procedure CallSignAndPrintPageService(var Rec: Record "Service Header EDMS")
    var
        AttachmentFileName: Text[150];
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPageService(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            Commit;
            DownloadFromStream(AttachementStream, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure CallSignAndEmailPageService(Var Rec: Record "Service Header EDMS");
    var
        AttachmentFileName: Text[150];
        DocumentMailing: Codeunit 260;
        SellToCustomer: Record Customer;
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPageService(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            COMMIT;
            SellToCustomer.GET(Rec."Sell-to Customer No.");
            SellToCustomer.TestField("E-Mail");
            DocumentMailing.EmailFile(AttachementStream, AttachmentFileName, '', AttachmentFileName, SellToCustomer."E-Mail", False, enum::"Email Scenario"::Default);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure SL___()
    begin

    end;

    procedure CallSignPageSales(var Rec: Record "Sales Header"; var TempBlob: Codeunit "Temp Blob"; var AttachmentFileName: Text)
    var
        DocMgt: Codeunit DocumentManagementDMS;
        DocReport: Record "Document Report";
        PreviewAndSign: Page "Preview And Sign";
        SalesHeader: Record "Sales Header";
        RepSelect: Record "Document Report";
        RepCount: Integer;
    begin
        Rec.SetRange("Document Type", Rec."Document Type");
        Rec.SetRange("No.", Rec."No.");
        RepSelect.Reset;
        DocMgt.PrintCurrentDoc(3, 3, 1, RepSelect);
        RepSelect.SetRange("Customer Signature", true);
        RepCount := RepSelect.Count;
        if RepCount = 0 then
            exit;

        if RepCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", RepSelect) <> Action::LookupOK then
                exit;
        end else
            RepSelect.FindFirst;


        AttachmentFileName := DocMgt.SaveSalesHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");
        Commit;

        PreviewAndSign.SetValues('Sales Document', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'CUSTOMER');
        if PreviewAndSign.RunModal = Action::OK then begin
            if SalesHeader.Get(Rec."Document Type", Rec."No.") then begin
                SalesHeader."Customer Signature Text" := PreviewAndSign.GetName();
                SalesHeader.Modify;
                Commit;
            end;
        end;
        if RepSelect."Employee Signature" then begin
            Clear(PreviewAndSign);
            PreviewAndSign.SetValues('Sales Document', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'EMPLOYEE');
            if PreviewAndSign.RunModal = Action::OK then begin
                if SalesHeader.Get(Rec."Document Type", Rec."No.") then begin
                    SalesHeader."Employee Signature Text" := PreviewAndSign.GetName();
                    SalesHeader.Modify;
                    Commit;
                end;
            end;
        end;

        AttachmentFileName := DocMgt.SaveSalesHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");

        if SalesHeader.Get(Rec."Document Type", Rec."No.") then begin
            Clear(SalesHeader."Customer Signature Image");
            Clear(SalesHeader."Customer Signature Text");
            Clear(SalesHeader."Employee Signature Image");
            Clear(SalesHeader."Employee Signature Text");
            SalesHeader.Modify;
        end;
    end;

    procedure CallSignAndPrintPageSales(var Rec: Record "Sales Header")
    var
        AttachmentFileName: Text[150];
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPageSales(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            Commit;
            DownloadFromStream(AttachementStream, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure CallSignAndEmailPageSales(Var Rec: Record "Sales Header");
    var
        AttachmentFileName: Text[150];
        DocumentMailing: Codeunit 260;
        SellToCustomer: Record Customer;
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPageSales(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            COMMIT;
            SellToCustomer.GET(Rec."Sell-to Customer No.");
            SellToCustomer.TestField("E-Mail");
            DocumentMailing.EmailFile(AttachementStream, AttachmentFileName, '', AttachmentFileName, SellToCustomer."E-Mail", False, enum::"Email Scenario"::Default);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure CH___()
    begin

    end;

    procedure CallSignPageChecklist(var Rec: Record "Process Checklist Header"; var TempBlob: Codeunit "Temp Blob"; var AttachmentFileName: Text)
    var
        DocMgt: Codeunit DocumentManagementDMS;
        DocReport: Record "Document Report";
        PreviewAndSign: Page "Preview And Sign";
        ChecklistHeader: Record "Process Checklist Header";
        RepSelect: Record "Document Report";
        RepCount: Integer;
    begin
        Rec.SetRange("No.", Rec."No.");
        RepSelect.Reset;
        DocMgt.PrintCurrentDoc(3, 3, 14, RepSelect);
        RepSelect.SetRange("Customer Signature", true);
        RepCount := RepSelect.Count;
        if RepCount = 0 then
            exit;

        if RepCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", RepSelect) <> Action::LookupOK then
                exit;
        end else
            RepSelect.FindFirst;


        AttachmentFileName := DocMgt.SaveChecklistHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");
        Commit;

        PreviewAndSign.SetValues('Checklist Document', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'CUSTOMER');
        if PreviewAndSign.RunModal = Action::OK then begin
            if ChecklistHeader.Get(Rec."No.") then begin
                ChecklistHeader."Customer Signature Text" := PreviewAndSign.GetName();
                ChecklistHeader.Modify;
                Commit;
            end;
        end;
        if RepSelect."Employee Signature" then begin
            Clear(PreviewAndSign);
            PreviewAndSign.SetValues('Checklist Document', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'EMPLOYEE');
            if PreviewAndSign.RunModal = Action::OK then begin
                if ChecklistHeader.Get(Rec."No.") then begin
                    ChecklistHeader."Employee Signature Text" := PreviewAndSign.GetName();
                    ChecklistHeader.Modify;
                    Commit;
                end;
            end;
        end;

        AttachmentFileName := DocMgt.SaveChecklistHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");

        if ChecklistHeader.Get(Rec."No.") then begin
            Clear(ChecklistHeader."Customer Signature Image");
            Clear(ChecklistHeader."Customer Signature Text");
            Clear(ChecklistHeader."Employee Signature Image");
            Clear(ChecklistHeader."Employee Signature Text");
            ChecklistHeader.Modify;
        end;
    end;

    procedure CallSignAndPrintPageChecklist(var Rec: Record "Process Checklist Header")
    var
        AttachmentFileName: Text[150];
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPageChecklist(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            Commit;
            DownloadFromStream(AttachementStream, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure CallSignAndEmailPageChecklist(Var Rec: Record "Process Checklist Header");
    var
        AttachmentFileName: Text[150];
        DocumentMailing: Codeunit 260;
        SellToCustomer: Record Customer;
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPageChecklist(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            COMMIT;
            SellToCustomer.GET(Rec."Sell-to Customer No.");
            SellToCustomer.TestField("E-Mail");
            DocumentMailing.EmailFile(AttachementStream, AttachmentFileName, '', AttachmentFileName, SellToCustomer."E-Mail", False, enum::"Email Scenario"::Default);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure R___()
    begin

    end;

    procedure CallSignPageRentTransfer(var Rec: Record "Rent Transfer Header"; var TempBlob: Codeunit "Temp Blob"; var AttachmentFileName: Text)
    var
        DocMgt: Codeunit DocumentManagementDMS;
        DocReport: Record "Document Report";
        PreviewAndSign: Page "Preview And Sign";
        Header: Record "Rent Transfer Header";
        RepSelect: Record "Document Report";
        RepCount: Integer;
    begin
        Rec.SetRange("No.", Rec."No.");
        RepSelect.Reset;
        DocMgt.PrintCurrentDoc(4, 4, 7, RepSelect);
        RepSelect.SetRange("Customer Signature", true);
        RepCount := RepSelect.Count;
        if RepCount = 0 then
            exit;

        if RepCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", RepSelect) <> Action::LookupOK then
                exit;
        end else
            RepSelect.FindFirst;


        AttachmentFileName := DocMgt.SaveRentTransferHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");
        Commit;

        PreviewAndSign.SetValues('Rent Transfer Order', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'CUSTOMER');
        if PreviewAndSign.RunModal = Action::OK then begin
            if Header.Get(Rec."No.") then begin
                Header."Customer Signature Text" := PreviewAndSign.GetName();
                Header.Modify;
                Commit;
            end;
        end;
        if RepSelect."Employee Signature" then begin
            Clear(PreviewAndSign);
            PreviewAndSign.SetValues('Rent Transfer Order', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'EMPLOYEE');
            if PreviewAndSign.RunModal = Action::OK then begin
                if Header.Get(Rec."No.") then begin
                    Header."Employee Signature Text" := PreviewAndSign.GetName();
                    Header.Modify;
                    Commit;
                end;
            end;
        end;

        AttachmentFileName := DocMgt.SaveRentTransferHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");

        if Header.Get(Rec."No.") then begin
            Clear(Header."Customer Signature Image");
            Clear(Header."Customer Signature Text");
            Clear(Header."Employee Signature Image");
            Clear(Header."Employee Signature Text");
            Header.Modify;
        end;
    end;

    procedure CallSignAndPrintPageRentTransfer(var Rec: Record "Rent Transfer Header")
    var
        AttachmentFileName: Text[150];
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPageRentTransfer(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            Commit;
            DownloadFromStream(AttachementStream, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure CallSignAndEmailPageRentTransfer(Var Rec: Record "Rent Transfer Header");
    var
        AttachmentFileName: Text[150];
        DocumentMailing: Codeunit 260;
        SellToCustomer: Record Customer;
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPageRentTransfer(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            COMMIT;
            SellToCustomer.GET(Rec."Sell-to Customer No.");
            SellToCustomer.TestField("E-Mail");
            DocumentMailing.EmailFile(AttachementStream, AttachmentFileName, '', AttachmentFileName, SellToCustomer."E-Mail", False, enum::"Email Scenario"::Default);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure RP___()
    begin

    end;

    procedure CallSignPagePostedRentTransfer(var Rec: Record "Posted Rent Transfer Header"; var TempBlob: Codeunit "Temp Blob"; var AttachmentFileName: Text)
    var
        DocMgt: Codeunit DocumentManagementDMS;
        DocReport: Record "Document Report";
        PreviewAndSign: Page "Preview And Sign";
        Header: Record "Posted Rent Transfer Header";
        RepSelect: Record "Document Report";
        RepCount: Integer;
    begin
        Rec.SetRange("No.", Rec."No.");
        RepSelect.Reset;
        DocMgt.PrintCurrentDoc(4, 4, 7, RepSelect);
        RepSelect.SetRange("Customer Signature", true);
        RepCount := RepSelect.Count;
        if RepCount = 0 then
            exit;

        if RepCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", RepSelect) <> Action::LookupOK then
                exit;
        end else
            RepSelect.FindFirst;


        AttachmentFileName := DocMgt.SavePostedRentTransferHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");
        Commit;

        PreviewAndSign.SetValues('Posted Rent Transfer Order', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'CUSTOMER');
        if PreviewAndSign.RunModal = Action::OK then begin
            if Header.Get(Rec."No.") then begin
                Header."Customer Signature Text" := PreviewAndSign.GetName();
                Header.Modify;
                Commit;
            end;
        end;
        if RepSelect."Employee Signature" then begin
            Clear(PreviewAndSign);
            PreviewAndSign.SetValues('Posted Rent Transfer Order', Rec."No.", TempBlob, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'EMPLOYEE');
            if PreviewAndSign.RunModal = Action::OK then begin
                if Header.Get(Rec."No.") then begin
                    Header."Employee Signature Text" := PreviewAndSign.GetName();
                    Header.Modify;
                    Commit;
                end;
            end;
        end;

        AttachmentFileName := DocMgt.SavePostedRentTransferHeaderReportAsPdf(TempBlob, Rec, RepSelect."Report ID");

        if Header.Get(Rec."No.") then begin
            Clear(Header."Customer Signature Image");
            Clear(Header."Customer Signature Text");
            Clear(Header."Employee Signature Image");
            Clear(Header."Employee Signature Text");
            Header.Modify;
        end;
    end;

    procedure CallSignAndPrintPagePostedRentTransfer(var Rec: Record "Posted Rent Transfer Header")
    var
        AttachmentFileName: Text[150];
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPagePostedRentTransfer(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            Commit;
            DownloadFromStream(AttachementStream, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;


    procedure CallSignAndEmailPagePostedRentTransfer(Var Rec: Record "Posted Rent Transfer Header");
    var
        AttachmentFileName: Text[150];
        DocumentMailing: Codeunit 260;
        SellToCustomer: Record Customer;
        AttachementStream: InStream;
        TempBlob: Codeunit "Temp Blob";
    begin
        CallSignPagePostedRentTransfer(Rec, TempBlob, AttachmentFileName);
        if AttachmentFileName <> '' then begin
            TempBlob.CreateInStream(AttachementStream);
            COMMIT;
            SellToCustomer.GET(Rec."Sell-to Customer No.");
            SellToCustomer.TestField("E-Mail");
            DocumentMailing.EmailFile(AttachementStream, AttachmentFileName, '', AttachmentFileName, SellToCustomer."E-Mail", False, enum::"Email Scenario"::Default);
        end else begin
            Error(NoPrintoutErr);
        end;
    end;

    procedure ETC___()
    begin

    end;


    procedure SetDocumentSignature(DocumentType: Code[20]; DocumentNo: Code[20]; Signature: Text; SignatureType: Code[20])
    var
        ServiceHeader: Record "Service Header EDMS";
        OStream: OutStream;
        Img: Text;
        SalesHeader: Record "Sales Header";
        ChecklistHeader: Record "Process Checklist Header";
        Base64Convert: Codeunit "Base64 Convert";
    begin
        case DocumentType of
            'SERVICE ORDER':
                begin
                    if ServiceHeader.Get(ServiceHeader."document type"::Order, DocumentNo) then begin
                        if SignatureType = 'EMPLOYEE' then
                            ServiceHeader."Employee Signature Image".CreateOutstream(OStream)
                        else
                            ServiceHeader."Customer Signature Image".CreateOutstream(OStream);
                        Base64Convert.FromBase64(Signature, OStream);
                        ServiceHeader.Modify;
                    end;
                end;
            'SALES ORDER':
                begin
                    if SalesHeader.Get(SalesHeader."document type"::Order, DocumentNo) then begin
                        if SignatureType = 'EMPLOYEE' then
                            SalesHeader."Employee Signature Image".CreateOutstream(OStream)
                        else
                            SalesHeader."Customer Signature Image".CreateOutstream(OStream);
                        Base64Convert.FromBase64(Signature, OStream);
                        SalesHeader.Modify;
                    end;
                end;
            'CHECKLIST':
                begin
                    if ChecklistHeader.Get(DocumentNo) then begin
                        if SignatureType = 'EMPLOYEE' then
                            ChecklistHeader."Employee Signature Image".CreateOutstream(OStream)
                        else
                            ChecklistHeader."Customer Signature Image".CreateOutstream(OStream);
                        Base64Convert.FromBase64(Signature, OStream);
                        ChecklistHeader.Modify;
                    end;
                end;
        end
    end;


    procedure ClearDocumentSignature(DocumentType: Code[20]; DocumentNo: Code[20]; Signature: Text; SignatureType: Code[20])
    var
        ServiceHeader: Record "Service Header EDMS";
        OStream: OutStream;
        Img: Text;
        SalesHeader: Record "Sales Header";
        ChecklistHeader: Record "Process Checklist Header";
    begin
        case DocumentType of
            'SERVICE ORDER':
                begin
                    if ServiceHeader.Get(ServiceHeader."document type"::Order, DocumentNo) then begin
                        ServiceHeader.CalcFields("Employee Signature Image", "Customer Signature Image");
                        if SignatureType = 'EMPLOYEE' then
                            Clear(ServiceHeader."Employee Signature Image")
                        else
                            Clear(ServiceHeader."Customer Signature Image");
                        ServiceHeader.Modify;
                    end;
                end;
            'SALES ORDER':
                begin
                    if SalesHeader.Get(SalesHeader."document type"::Order, DocumentNo) then begin
                        SalesHeader.CalcFields("Employee Signature Image", "Customer Signature Image");
                        if SignatureType = 'EMPLOYEE' then
                            Clear(SalesHeader."Employee Signature Image")
                        else
                            Clear(SalesHeader."Customer Signature Image");
                        SalesHeader.Modify;
                    end;
                end;
            'CHECKLIST':
                begin
                    if ChecklistHeader.Get(DocumentNo) then begin
                        ChecklistHeader.CalcFields("Employee Signature Image", "Customer Signature Image");
                        if SignatureType = 'EMPLOYEE' then
                            Clear(ChecklistHeader."Employee Signature Image")
                        else
                            Clear(ChecklistHeader."Customer Signature Image");
                        ChecklistHeader.Modify;
                    end;
                end;
        end
    end;

    local procedure GetTimeStampForFileName(): Text
    begin
        exit(Format(CurrentDatetime, 0, '<Year,2><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2><Thousands,3>'));
    end;


    procedure GetBlobSize(SignatureDataStream: InStream): Integer
    var
        Length: Integer;
        BytesRead: Integer;
        Variable: Char;
    begin
        repeat
            BytesRead := SignatureDataStream.Read(Variable);
            Length += BytesRead;
        until BytesRead = 0;
        exit(Length);
    end;



}

