page 25006657 "Rent Lines"
{
    ApplicationArea = All;
    Caption = 'Rent Lines';
    PageType = List;
    SourceTable = "Rent Line";
    UsageCategory = None;
    Editable = false;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field("Rent Item No."; Rec."Rent Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Rent Asset No."; Rec."Rent Asset No.")
                {
                    ApplicationArea = All;
                }
                field("Rent Asset Quantity"; Rec."Rent Asset Quantity")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Rent Period Type"; Rec."Rent Period Type")
                {
                    ApplicationArea = All;
                }
                field("Rent Start Date"; Rec."Rent Start Date")
                {
                    ApplicationArea = All;
                }
                field("Rent End Date"; Rec."Rent End Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Shipment Date"; Rec."Actual Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Return Date"; Rec."Actual Return Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Document")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Document';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Open the document that the selected line exists on.';

                    trigger OnAction()
                    var
                        RentQuote: Page "Rent Quote";
                        RentOrder: Page "Rent Order";
                        ClosedRentOrder: Page "Closed Rent Order";
                    begin
                        RentHeader.Get(Rec."Document Type", Rec."Document No.");
                        RentHeader.SetRecFilter();
                        If Rec.Closed then
                            if Page.RunModal(PAGE::"Closed Rent Order", RentHeader) = Action::None then;
                        If (not Rec.Closed) and (Rec."Document Type" = Rec."Document Type"::Order) then
                            if Page.RunModal(PAGE::"Rent Order", RentHeader) = Action::None then;
                        If (not Rec.Closed) and (Rec."Document Type" = Rec."Document Type"::Quote) then
                            if Page.RunModal(PAGE::"Rent Quote", RentHeader) = Action::None then;
                    end;
                }
            }
        }
    }
    var
        RentHeader: Record "Rent Header";
}
