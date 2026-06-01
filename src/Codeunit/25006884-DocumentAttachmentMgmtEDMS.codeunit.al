codeunit 25006884 "Document Attachment Mgmt EDMS"
{
    // // Code unit to manage document attachment to records.


    trigger OnRun()
    begin
    end;

    var
        PrintedToAttachmentTxt: Label 'The document has been printed to attachments.';
        NoSaveToPDFReportTxt: Label 'There are no reports which could be saved to PDF for this document.';
        ShowAttachmentsTxt: Label 'Show Attachments';

    local procedure DeleteAttachedDocuments(RecRef: RecordRef; DocType: Option Quote,"Order","Return Order")
    var
        DocumentAttachment: Record "Document Attachment";
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
    begin
        if RecRef.IsTemporary then
            exit;
        if DocumentAttachment.IsEmpty then
            exit;
        DocumentAttachment.SetRange("Table ID", RecRef.Number);

        case RecRef.Number of
            DATABASE::"Rent Header":
                begin
                    FieldRef := RecRef.Field(10);
                    DocType := FieldRef.Value;
                    DocumentAttachment.SetRange("Document Type", DocType);

                    FieldRef := RecRef.Field(20);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Service Header EDMS":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    DocumentAttachment.SetRange("Document Type", DocType);

                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;

        DocumentAttachment.DeleteAll();
    end;

    [EventSubscriber(ObjectType::Table, 25006145, 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteServiceHeaderEDMS(var Rec: Record "Service Header EDMS"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        DocType: Integer;
    begin
        RecRef.GetTable(Rec);
        FieldRef := RecRef.Field(1);
        DocType := FieldRef.Value;
        DeleteAttachedDocuments(RecRef, DocType);
    end;

    [EventSubscriber(ObjectType::Table, 25006618, 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteSalesHeader(var Rec: Record "Rent Header"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        DocType: Integer;
    begin
        RecRef.GetTable(Rec);
        FieldRef := RecRef.Field(10);
        DocType := FieldRef.Value;
        DeleteAttachedDocuments(RecRef, DocType);
    end;


    [EventSubscriber(ObjectType::Codeunit, 25006124, 'OnBeforeDeleteServiceQuote', '', false, false)]
    local procedure DocAttachFlowFormSalesQuoteToSalesOrder(var QuoteServiceHeader: Record "Service Header EDMS"; var OrderServiceHeader: Record "Service Header EDMS")
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin

        if QuoteServiceHeader."No." = '' then
            exit;

        if QuoteServiceHeader.IsTemporary then
            exit;

        if OrderServiceHeader."No." = '' then
            exit;

        if OrderServiceHeader.IsTemporary then
            exit;

        FromRecRef.Open(DATABASE::"Service Header EDMS");
        FromRecRef.GetTable(QuoteServiceHeader);

        ToRecRef.Open(DATABASE::"Service Header EDMS");
        ToRecRef.GetTable(OrderServiceHeader);

        CopyAttachments(FromRecRef, ToRecRef);
    end;


    procedure DocAttachForPostedServiceDocs(var ServiceHeader: Record "Service Header EDMS"; var PostedServiceHeader: Record "Posted Serv. Order Header"; var PostedRetServiceHeader: Record "Posted Serv. Ret. Order Header")
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        // Triggered when a posted sales cr. memo / posted sales invoice is created
        if ServiceHeader.IsTemporary then
            exit;

        if PostedServiceHeader.IsTemporary then
            exit;

        if PostedRetServiceHeader.IsTemporary then
            exit;

        FromRecRef.GetTable(ServiceHeader);

        if PostedServiceHeader."No." <> '' then
            ToRecRef.GetTable(PostedServiceHeader);

        if PostedRetServiceHeader."No." <> '' then
            ToRecRef.GetTable(PostedRetServiceHeader);

        CopyAttachmentsForPostedDocs(FromRecRef, ToRecRef);
    end;

    procedure DocCopyServiceToSales(var ServiceHeader: Record "Service Header EDMS"; var SalesHeader: Record "Sales Header")
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        // Triggered when a posted sales cr. memo / posted sales invoice is created
        if ServiceHeader.IsTemporary then
            exit;

        if SalesHeader.IsTemporary then
            exit;

        FromRecRef.GetTable(ServiceHeader);
        ToRecRef.GetTable(SalesHeader);

        CopyAttachments(FromRecRef, ToRecRef);
    end;

    local procedure CopyAttachments(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        FromDocumentAttachment: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
        FromFieldRef: FieldRef;
        ToFieldRef: FieldRef;
        FromDocumentType: Option Quote,"Order","Return Order";
        FromLineNo: Integer;
        FromNo: Code[20];
        ToNo: Code[20];
        ToDocumentType: Option Quote,"Order","Return Order";
        ToLineNo: Integer;
    begin
        FromDocumentAttachment.SetRange("Table ID", FromRecRef.Number);
        if FromDocumentAttachment.IsEmpty then
            exit;
        case FromRecRef.Number of
            DATABASE::"Service Header EDMS":
                begin
                    FromFieldRef := FromRecRef.Field(1);
                    FromDocumentType := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("Document Type", FromDocumentType);
                    FromFieldRef := FromRecRef.Field(3);
                    FromNo := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("No.", FromNo);
                end;
            DATABASE::"Rent Header":
                begin
                    FromFieldRef := FromRecRef.Field(10);
                    FromDocumentType := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("Document Type", FromDocumentType);
                    FromFieldRef := FromRecRef.Field(20);
                    FromNo := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("No.", FromNo);
                end;
        end;

        if FromDocumentAttachment.FindSet then begin
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init();
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", ToRecRef.Number);

                case ToRecRef.Number of
                    DATABASE::"Service Header EDMS":
                        begin
                            ToFieldRef := ToRecRef.Field(3);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("No.", ToNo);
                            ToFieldRef := ToRecRef.Field(1);
                            ToDocumentType := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("Document Type", ToDocumentType);
                        end;
                    DATABASE::"Rent Header":
                        begin
                            ToFieldRef := ToRecRef.Field(10);
                            ToDocumentType := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("Document Type", ToDocumentType);
                            ToFieldRef := ToRecRef.Field(20);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("No.", ToNo);
                        end;
                    DATABASE::"Sales Header":
                        begin
                            ToFieldRef := ToRecRef.Field(3);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("No.", ToNo);
                            ToFieldRef := ToRecRef.Field(1);
                            ToDocumentType := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("Document Type", ToDocumentType);
                        end;
                end;

                if not ToDocumentAttachment.Insert(true) then;

            until FromDocumentAttachment.Next = 0;
        end;

        // Copies attachments for header and then calls CopyAttachmentsForPostedDocsLines to copy attachments for lines.
    end;

    local procedure CopyAttachmentsForPostedDocs(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        FromDocumentAttachment: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
        FromFieldRef: FieldRef;
        ToFieldRef: FieldRef;
        FromDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        FromNo: Code[20];
        ToNo: Code[20];
    begin
        FromDocumentAttachment.SetRange("Table ID", FromRecRef.Number);

        FromFieldRef := FromRecRef.Field(1);
        FromDocumentType := FromFieldRef.Value;
        FromDocumentAttachment.SetRange("Document Type", FromDocumentType);

        FromFieldRef := FromRecRef.Field(3);
        FromNo := FromFieldRef.Value;
        FromDocumentAttachment.SetRange("No.", FromNo);

        // Find any attached docs for headers (sales / purch)
        if FromDocumentAttachment.FindSet then begin
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init();
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", ToRecRef.Number);

                ToFieldRef := ToRecRef.Field(3);
                ToNo := ToFieldRef.Value;
                ToDocumentAttachment.Validate("No.", ToNo);
                Clear(ToDocumentAttachment."Document Type");
                ToDocumentAttachment.Insert(true);

            until FromDocumentAttachment.Next = 0;
        end;

    end;

    procedure DocAttachFlowFormRentQuoteToRentOrder(var QuoteRentHeader: Record "Rent Header"; var OrderRentHeader: Record "Rent Header")
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin

        if QuoteRentHeader."No." = '' then
            exit;

        if QuoteRentHeader.IsTemporary then
            exit;

        if QuoteRentHeader."No." = '' then
            exit;

        if QuoteRentHeader.IsTemporary then
            exit;

        FromRecRef.Open(DATABASE::"Rent Header");
        FromRecRef.GetTable(QuoteRentHeader);

        ToRecRef.Open(DATABASE::"Rent Header");
        ToRecRef.GetTable(OrderRentHeader);

        CopyAttachments(FromRecRef, ToRecRef);
    end;

    // [EventSubscriber(ObjectType::Page, 1174, 'OnBeforeDrillDown', '', false, false)]
    // local procedure SetRecRefOnBeforeDrillDownDocAttachFactBox(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    // var
    //     ServHeaderEDMS: Record "Service Header EDMS";
    //     RentHeader: Record "Rent Header";
    //     PostedServiceHeader: Record "Posted Serv. Order Header";
    // begin
    //     case DocumentAttachment."Table ID" of
    //         DATABASE::"Service Header EDMS":
    //             begin
    //                 RecRef.Open(DATABASE::"Service Header EDMS");
    //                 if ServHeaderEDMS.Get(DocumentAttachment."Document Type", DocumentAttachment."No.") then
    //                     RecRef.GetTable(ServHeaderEDMS);
    //             end;
    //         DATABASE::"Rent Header":
    //             begin
    //                 RecRef.Open(DATABASE::"Rent Header");
    //                 if RentHeader.Get(DocumentAttachment."Document Type", DocumentAttachment."No.") then
    //                     RecRef.GetTable(RentHeader);
    //             end;
    //         DATABASE::"Posted Serv. Order Header":
    //             begin
    //                 RecRef.Open(DATABASE::"Posted Serv. Order Header");
    //                 if PostedServiceHeader.Get(DocumentAttachment."No.") then
    //                     RecRef.GetTable(PostedServiceHeader);
    //             end;
    //     end;
    // end;

    [EventSubscriber(ObjectType::Page, 1173, 'OnAfterOpenForRecRef', '', false, false)]
    local procedure SetRecRefOnAfterOpenDocAttachDetPage(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
    begin
        case RecRef.Number of
            DATABASE::"Service Header EDMS":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    DocumentAttachment.SetRange("Document Type", DocType);
                    //FlowFieldsEditable := false;
                end;
            DATABASE::"Rent Header":
                begin
                    FieldRef := RecRef.Field(20);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    FieldRef := RecRef.Field(10);
                    DocType := FieldRef.Value;
                    DocumentAttachment.SetRange("Document Type", DocType);
                    //FlowFieldsEditable := false;
                end;
            DATABASE::"Posted Serv. Order Header":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;
    //>>DELTA MGR
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterTableHasDocTypePrimaryKey, '', false, false)]
    local procedure "Document Attachment Mgmt_OnAfterTableHasDocTypePrimaryKey"(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    begin
        case TableNo of
            Database::"Service Header EDMS":
                begin
                    FieldNo := 1;
                    result := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document Attachment Mgmt", OnAfterTableHasNumberFieldPrimaryKey, '', false, false)]
    local procedure "Document Attachment Mgmt_OnAfterTableHasNumberFieldPrimaryKey"(TableNo: Integer; var Result: Boolean; var FieldNo: Integer)
    begin
        case TableNo of
            Database::"Service Header EDMS",
            Database::"Posted Serv. Order Header":
                begin
                    FieldNo := 3;
                    result := true;
                end;

        end;
    end;
    //<<DELTA MGR
}

