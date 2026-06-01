Report 25006135 "Copy Service Document EDMS"
{
    // 25.03.2014 Elva Baltic P18 #RX021 MMG7.00
    //   Added Missing LVI translations
    //   Added new DocType "Archived Quote"
    //   Added Code to
    //     LookupDocNo()
    //     ValidateDocNo()
    // 
    // 10.04.2013 EDMS P8
    //   * Added service quote to copy

    Caption = 'Copy Service Document EDMS';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DocType; DocType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document Type';
                        OptionCaption = 'Quote,Order,Return Order,Posted Order,Posted Return Order,,,,Archived Quote,Archived Order';

                        trigger OnValidate()
                        begin
                            DocNo := '';
                            ValidateDocNo;
                        end;
                    }
                    field(DocNo; DocNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            LookupDocNo;
                        end;

                        trigger OnValidate()
                        begin
                            ValidateDocNo;
                        end;
                    }
                    field(SelltoCustomerNo; FromServOrdHeader."Sell-to Customer No.")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sell-to Customer No.';
                        Editable = false;
                    }
                    field(SelltoCustomerName; FromServOrdHeader."Sell-to Customer Name")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sell-to Customer Name';
                        Editable = false;
                    }
                    field(IncludeHeader; IncludeHeader)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Header';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DocNo <> '' then begin
                case DocType of
                    Doctype::Order:
                        if FromServOrdHeader.Get(FromServOrdHeader."document type"::Order, DocNo) then;
                    Doctype::"Return Order":
                        if FromServOrdHeader.Get(FromServOrdHeader."document type"::"Return Order", DocNo) then;
                end;
                if FromServOrdHeader."No." = '' then
                    DocNo := ''
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if DocNo = '' then
            Error(Text004);

        ValidateDocNo;
        if (DocType <> Doctype::"Archived Quote") and (DocType <> Doctype::"Archived Order") then
            AllLinesCopied := CopyDocMgt.CopyServOrd(ServOrdHeader, DocType, DocNo, OutServOrdLine, IncludeHeader);
        if CreateQuote then
            CreateQuoteFromArchivedQuotes;

        if CreateArchOrder then
            CreateOrderFromArchivedOrders;
    end;

    var
        Text004: label 'You must fill in the Document No. field.';
        ServOrdHeader: Record "Service Header EDMS";
        FromServOrdHeader: Record "Service Header EDMS";
        DocType: Option Quote,"Order","Return Order","Posted Order","Posted Return Order",,,,"Archived Quote","Archived Order";
        DocNo: Code[20];
        CopyDocMgt: Codeunit DocumentManagementDMS;
        OutServOrdLine: Record "Service Line EDMS";
        AllLinesCopied: Boolean;
        IncludeHeader: Boolean;
        FromPstServOrdHeader: Record "Posted Serv. Order Header";
        FromPstServRetOrdHeader: Record "Posted Serv. Ret. Order Header";
        FromArchivedQuote: Record "Service Header Archive";
        ArchiveQuoteLine: Record "Service Line Archive";
        FromArchivedOrder: Record "Service Header Archive";
        ArchiveOrderLine: Record "Service Line Archive";
        TempDocNo: Code[20];
        TempDocType: Option;
        ServOrdLine: Record "Service Line EDMS";
        TempSellToNo: Code[20];
        TempSellToName: Text[50];
        CreateQuote: Boolean;
        CreateArchOrder: Boolean;
        LastLineNo: Integer;


    procedure SetServOrdHeader(var NewServOrdHeader: Record "Service Header EDMS")
    begin
        NewServOrdHeader.TestField("No.");
        ServOrdHeader := NewServOrdHeader;
    end;

    local procedure ValidateDocNo()
    begin
        if DocNo = '' then
            FromServOrdHeader.Init
        else
            if FromServOrdHeader."No." = '' then begin
                FromServOrdHeader.Init;
                case DocType of
                    Doctype::Quote,
                    Doctype::Order,
                    Doctype::"Return Order":
                        begin
                            FromServOrdHeader.Get(CopyDocMgt.ServOrdHeaderDocType(DocType), DocNo);
                        end;
                    Doctype::"Posted Order":
                        begin
                            FromPstServOrdHeader.Get(DocNo);
                            FromServOrdHeader.TransferFields(FromPstServOrdHeader);
                        end;
                    Doctype::"Posted Return Order":
                        begin
                            FromPstServRetOrdHeader.Get(DocNo);
                            FromServOrdHeader.TransferFields(FromPstServRetOrdHeader);
                        end;
                    Doctype::"Archived Quote":
                        begin
                            FromServOrdHeader.TransferFields(FromArchivedQuote);
                            CreateQuote := true;
                        end;
                    Doctype::"Archived Order":
                        begin
                            FromServOrdHeader.TransferFields(FromArchivedOrder);
                            CreateArchOrder := true;
                        end;
                end
            end;
        FromServOrdHeader."No." := '';
    end;

    local procedure LookupDocNo()
    var
        ServiceQuotes: Page "Service Quotes EDMS";
    begin
        case DocType of
            Doctype::Quote:
                begin
                    FromServOrdHeader.FilterGroup := 0;
                    FromServOrdHeader.SetRange("Document Type", CopyDocMgt.ServOrdHeaderDocType(DocType));
                    if ServOrdHeader."Document Type" = CopyDocMgt.ServOrdHeaderDocType(DocType) then
                        FromServOrdHeader.SetFilter("No.", '<>%1', ServOrdHeader."No.");
                    FromServOrdHeader.FilterGroup := 2;
                    FromServOrdHeader."Document Type" := CopyDocMgt.ServOrdHeaderDocType(DocType);
                    FromServOrdHeader."No." := DocNo;
                    ServiceQuotes.SetTableview(FromServOrdHeader);
                    ServiceQuotes.LookupMode(true);
                    if ServiceQuotes.RunModal = Action::LookupOK then begin
                        ServiceQuotes.GetRecord(FromServOrdHeader);
                        DocNo := FromServOrdHeader."No.";
                    end;
                end;
            Doctype::Order,
            Doctype::"Return Order":
                begin
                    FromServOrdHeader.FilterGroup := 0;
                    FromServOrdHeader.SetRange("Document Type", CopyDocMgt.ServOrdHeaderDocType(DocType));
                    if ServOrdHeader."Document Type" = CopyDocMgt.ServOrdHeaderDocType(DocType) then
                        FromServOrdHeader.SetFilter("No.", '<>%1', ServOrdHeader."No.");
                    FromServOrdHeader.FilterGroup := 2;
                    FromServOrdHeader."Document Type" := CopyDocMgt.ServOrdHeaderDocType(DocType);
                    FromServOrdHeader."No." := DocNo;
                    if Page.RunModal(0, FromServOrdHeader) = Action::LookupOK then
                        DocNo := FromServOrdHeader."No.";
                end;
            Doctype::"Posted Order":
                begin
                    FromPstServOrdHeader."No." := DocNo;
                    if Page.RunModal(0, FromPstServOrdHeader) = Action::LookupOK then
                        DocNo := FromPstServOrdHeader."No.";
                end;
            Doctype::"Posted Return Order":
                begin
                    FromPstServRetOrdHeader."No." := DocNo;
                    if Page.RunModal(0, FromPstServRetOrdHeader) = Action::LookupOK then
                        DocNo := FromPstServRetOrdHeader."No.";
                end;
            Doctype::"Archived Quote":
                begin
                    FromArchivedQuote.SetRange("Document Type", FromArchivedQuote."document type"::Quote);
                    FromArchivedQuote."No." := DocNo;
                    if Page.RunModal(0, FromArchivedQuote) = Action::LookupOK then
                        DocNo := FromArchivedQuote."No.";
                end;
            Doctype::"Archived Order":
                begin
                    FromArchivedOrder.SetRange("Document Type", FromArchivedOrder."document type"::Order);
                    FromArchivedOrder."No." := DocNo;
                    if Page.RunModal(0, FromArchivedOrder) = Action::LookupOK then
                        DocNo := FromArchivedOrder."No.";
                end;

        end;

        ValidateDocNo;
    end;


    procedure CreateQuoteFromArchivedQuotes()
    begin
        // Key Document Type,No.,Doc. No. Occurrence,Version No.
        if not FromArchivedQuote.IsEmpty then begin
            TempDocNo := ServOrdHeader."No.";
            TempDocType := ServOrdHeader."Document Type";
            if IncludeHeader then begin
                ServOrdHeader.TransferFields(FromArchivedQuote);
                ServOrdHeader."No." := TempDocNo;
                ServOrdHeader."Document Type" := TempDocType;
            end;
            ArchiveQuoteLine.Reset;
            ArchiveQuoteLine.SetRange("Document Type", FromArchivedQuote."Document Type");
            ArchiveQuoteLine.SetRange("Document No.", FromArchivedQuote."No.");
            ArchiveQuoteLine.SetRange("Doc. No. Occurrence", FromArchivedQuote."Doc. No. Occurrence");
            ArchiveQuoteLine.SetRange("Version No.", FromArchivedQuote."Version No.");
            ServOrdLine.Reset;
            ServOrdLine.SetRange("Document Type", ServOrdHeader."Document Type");
            ServOrdLine.SetRange("Document No.", ServOrdHeader."No.");

            if ServOrdLine.FindLast then
                LastLineNo := ServOrdLine."Line No." + 1000
            else
                LastLineNo := 1000;

            if ArchiveQuoteLine.Find('-') then
                repeat
                    ServOrdLine.Reset;
                    ServOrdLine.TransferFields(ArchiveQuoteLine);
                    ServOrdLine."Document No." := TempDocNo;
                    ServOrdLine."Document Type" := TempDocType;
                    ServOrdLine."Line No." := LastLineNo;
                    LastLineNo += 1000;
                    ServOrdLine.Insert;
                until ArchiveQuoteLine.Next = 0;
            if IncludeHeader then
                ServOrdHeader.Modify;
        end;
    end;


    procedure CreateOrderFromArchivedOrders()
    begin
        // Key Document Type,No.,Doc. No. Occurrence,Version No.
        if not FromArchivedOrder.IsEmpty then begin
            TempDocNo := ServOrdHeader."No.";
            TempDocType := ServOrdHeader."Document Type";
            if IncludeHeader then begin
                ServOrdHeader.TransferFields(FromArchivedOrder);
                ServOrdHeader."No." := TempDocNo;
                ServOrdHeader."Document Type" := TempDocType;
            end;
            ArchiveOrderLine.Reset;
            ArchiveOrderLine.SetRange("Document Type", FromArchivedOrder."Document Type");
            ArchiveOrderLine.SetRange("Document No.", FromArchivedOrder."No.");
            ArchiveOrderLine.SetRange("Doc. No. Occurrence", FromArchivedOrder."Doc. No. Occurrence");
            ArchiveOrderLine.SetRange("Version No.", FromArchivedOrder."Version No.");
            ServOrdLine.Reset;
            ServOrdLine.SetRange("Document Type", ServOrdHeader."Document Type");
            ServOrdLine.SetRange("Document No.", ServOrdHeader."No.");

            if ServOrdLine.FindLast then
                LastLineNo := ServOrdLine."Line No." + 1000
            else
                LastLineNo := 1000;

            if ArchiveOrderLine.FindFirst then
                repeat
                    ServOrdLine.Reset;
                    ServOrdLine.TransferFields(ArchiveOrderLine);
                    ServOrdLine."Document No." := TempDocNo;
                    ServOrdLine."Document Type" := TempDocType;
                    ServOrdLine."Line No." := LastLineNo;
                    LastLineNo += 1000;
                    ServOrdLine.Insert;
                until ArchiveOrderLine.Next = 0;
            if IncludeHeader then
                ServOrdHeader.Modify;
        end;
    end;
}

