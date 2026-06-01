Page 25006031 "Fields EDMS"
{
    Caption = 'Fields';
    Editable = false;
    PageType = List;
    SourceTable = "Field";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(TableNo; rec.TableNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'TableNo';
                    Visible = false;
                }
                field(TableName; rec.TableName)
                {
                    ApplicationArea = Basic;
                    Caption = 'TableName';
                    Visible = false;
                }
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                }
                field(FieldName; rec.FieldName)
                {
                    ApplicationArea = Basic;
                    Caption = 'FieldName';
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type';
                    Visible = false;
                }
                field(Class; rec.Class)
                {
                    ApplicationArea = Basic;
                    Caption = 'Class';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

