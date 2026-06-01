Page 25006076 "Service Line EDMS List"
{
    Caption = 'Service Line List';
    Editable = false;
    PageType = List;
    SourceTable = "Service Line EDMS";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
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
                    Visible = false;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(QuantityBase; Rec."Quantity (Base)")
                {
                    ApplicationArea = Basic;
                }
                field(OutstandingQtyBase; Rec."Outstanding Qty. (Base)")
                {
                    ApplicationArea = Basic;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(ShowDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        if ServHeader.Get(Rec."Document Type", Rec."Document No.") then
                            case Rec."Document Type" of
                                Rec."document type"::Quote:
                                    Page.Run(Page::"Service Quote EDMS", ServHeader);
                                Rec."document type"::Order:
                                    Page.Run(Page::"Service Order EDMS", ServHeader);
                            end;
                    end;
                }
            }
        }
    }

    var
        ServHeader: Record "Service Header EDMS";
}

