Page 25006410 "Warranty Pstd. Service Line"
{
    PageType = List;
    SourceTable = "Posted Serv. Order Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(AmountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }


    procedure SetSelected(var PstdServiceOrderLine: Record "Posted Serv. Order Line")
    begin
        CurrPage.SetSelectionFilter(PstdServiceOrderLine);
    end;


    procedure SetSelectedService(var ServiceLine: Record "Service Line EDMS")
    begin
        CurrPage.SetSelectionFilter(ServiceLine);
    end;
}

