Page 25006037 "Sales Offer Analysis"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Sales Analysis Header";

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

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
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
            part(Page25006038; "Sales Offer Analysis Subform")
            {
                SubPageLink = "Document No." = field("No."),
                              "Document Type" = field("Document Type");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Recalculate)
            {
                ApplicationArea = Basic;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FillAnalysis;
                end;
            }
            action(UpdateDocument)
            {
                ApplicationArea = Basic;
                Caption = 'Update Document';
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.UpdateSourceDocument;
                    CurrPage.Close;
                end;
            }
            action(UpdateAnalysis)
            {
                ApplicationArea = Basic;
                Caption = 'Update Analysis';
                Image = AnalysisView;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.UpdateAnalysis;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("No.", DocumentNo);
        Rec.SetRange("Document Type", DocumentType);
        if Rec.Count = 0 then begin
            FillAnalysis;
        end;
    end;

    var
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Service Quote","Service Order";
        SalesHeader: Record "Sales Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        ServiceHeaderEDMS: Record "Service Header EDMS";
        SalesAnalysisHeader: Record "Sales Analysis Header";


    procedure SetParams(DocumentNoPar: Code[20]; DocumentTypePar: Option Quote,"Order","Service Quote","Service Order")
    begin
        DocumentNo := DocumentNoPar;
        DocumentType := DocumentTypePar;
    end;

    local procedure FillAnalysis()
    begin
        Rec."Margin %" := 0;
        case DocumentType of
            Documenttype::Quote:
                begin
                    if SalesHeader.Get(SalesHeader."document type"::Quote, DocumentNo) then
                        Rec.FillFromSalesDocument(SalesHeader);
                end;
            Documenttype::"Service Quote":
                begin
                    if ServiceHeaderEDMS.Get(ServiceHeaderEDMS."document type"::Quote, DocumentNo) then
                        Rec.FillFromServiceDocument(ServiceHeaderEDMS);
                end;
        end;
    end;
}

