Page 25006260 "Service Spliting Lines SubForm"
{
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Set Editable property to FALSE for:
    //     "Location Code"
    //     "Unit of Measure"
    // 
    // 21.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Include
    //   Changed Visible and Editable properties of some fields

    Caption = 'Service Spliting Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Service Splitting Line";
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
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                    Editable = false;
                    Visible = false;
                }
                field(Include; Rec.Include)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(NewQuantity; Rec."New Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
            }
        }
    }

    actions
    {
    }
}

