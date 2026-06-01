Page 25006243 "Sales Offer Analysis Archive"
{
    Editable = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Sales Analysis Header Archive";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Editable = false;
                    Lookup = false;
                }
                field(MarginRetail; Rec."Margin Retail %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(TotalRetailPrice; Rec."Total Retail Price")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Editable = false;
                    Lookup = false;
                }
                field(TotalOfferPrice; Rec."Total Offer Price")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Editable = false;
                    Lookup = false;
                }
                field(Margin; Rec."Margin %")
                {
                    ApplicationArea = Basic;
                    MaxValue = 99.99;
                    MinValue = 0;
                }
                field(GetTotalRevenue; Rec.GetTotalRevenue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Revenue';
                    Editable = false;
                }
                field(GetTotalPriceDiff; Rec.GetTotalPriceDiff)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Price Difference';
                    Editable = false;
                }
            }
            part(Control25006012; "Sales Off. An. Subf. Archive")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type"),
                              "Version No." = field("Version No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("No.", DocumentNo);
        Rec.SetRange("Document Type", DocumentType);
        Rec.SetRange("Version No.", VersionNo);
    end;

    var
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Service Quote","Service Order";
        VersionNo: Integer;


    procedure SetParams(DocumentNoPar: Code[20]; DocumentTypePar: Option Quote,"Order","Service Quote","Service Order"; VersionNoPar: Integer)
    begin
        DocumentNo := DocumentNoPar;
        DocumentType := DocumentTypePar;
        VersionNo := VersionNoPar
    end;
}

