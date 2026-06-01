Page 25006603 "Rent Package Card"
{
    Caption = 'Rent Package Card';
    PageType = Card;
    SourceTable = "Rent Package";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control25006005; "Rent Package Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Package No." = field("No.");
            }
        }
    }

    actions
    {
    }
}

