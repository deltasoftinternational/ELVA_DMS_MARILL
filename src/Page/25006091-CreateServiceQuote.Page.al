Page 25006091 "Create Service Quote"
{
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Created

    Caption = 'Create Service Quote';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Service Splitting Line";
    SourceTableView = where(Line = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CreateQuote; Rec."Create Quote")
                {
                    ApplicationArea = Basic;
                }
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
                    Editable = false;
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
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Create)
            {
                ApplicationArea = Basic;
                Caption = 'Create';
                Image = Apply;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.CreateQuote;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        Rec.DeleteDocQuote(Rec."Document Type", Rec."Document No.");
    end;
}

