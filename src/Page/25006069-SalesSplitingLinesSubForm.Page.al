Page 25006069 "Sales Spliting Lines SubForm"
{
    Caption = 'Sales Spliting Lines SubForm';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Splitting Line";
    SourceTableView = sorting("Document Type", "Document No.", "Temp. Document No.", Line, "Temp. Line No.")
                      order(ascending)
                      where(Line = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TempLineNo; Rec."Temp. Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
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
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(QuantityShare; Rec."Quantity Share %")
                {
                    ApplicationArea = Basic;
                }
                field(NewQuantity; Rec."New Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(AmountShare; Rec."Amount Share %")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(NewAmount; Rec."New Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Include; Rec.Include)
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

