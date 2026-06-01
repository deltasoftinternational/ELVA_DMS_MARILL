Page 25006861 "Purch. Invoice Import Buffer"
{
    Caption = 'Purch. Invoice Import Buffer';
    PageType = List;
    SourceTable = "Purch. Invoice Import Buffer";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                Editable = false;
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceNo; Rec."Invoice No.")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceLineNo; Rec."Invoice Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(CompanyCode; Rec."Company Code")
                {
                    ApplicationArea = Basic;
                }
                field(SupplierCode; Rec."Supplier Code")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(TypeofInvoice; Rec."Type of Invoice")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

