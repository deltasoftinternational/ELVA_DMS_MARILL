Page 25006167 "Service No. Series Setup EDMS"
{
    // 04.02.2015 EB.P7 #T018 EDMS
    //   Page Created.

    Caption = 'Service No. Series Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPlus;
    SourceTable = "Service Mgt. Setup EDMS";

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                InstructionalText = 'To fill the Document No. field automatically, you must set up a number series.';
                field(QuoteNos; Rec."Quote Nos.")
                {
                    ApplicationArea = Basic;
                    Visible = QuoteNosVisible;
                }
                field(OrderNos; Rec."Order Nos.")
                {
                    ApplicationArea = Basic;
                    Visible = OrderNosVisible;
                }
                field(ReturnOrderNos; Rec."Return Order Nos.")
                {
                    ApplicationArea = Basic;
                    Visible = ReturnOrderNosVisible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Setup)
            {
                ApplicationArea = Basic;
                Caption = 'Sales & Receivables Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Sales & Receivables Setup";
            }
        }
    }

    var
        QuoteNosVisible: Boolean;
        OrderNosVisible: Boolean;
        ReturnOrderNosVisible: Boolean;


    procedure SetFieldsVisibility(DocType: Option Quote,"Order","Return Order")
    begin
        QuoteNosVisible := (DocType = Doctype::Quote);
        OrderNosVisible := (DocType = Doctype::Order);
        ReturnOrderNosVisible := (DocType = Doctype::"Return Order");
    end;
}

