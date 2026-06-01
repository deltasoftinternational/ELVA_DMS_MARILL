XmlPort 25006872 "Export Checklist Data"
{
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            textelement(CheckList)
            {
                tableelement(itemghchecklistbuffer; "Checklist Buffer")
                {
                    MinOccurs = Zero;
                    XmlName = 'Item';
                    SourceTableView = sorting("Line No.") order(ascending) where(Type = filter(Group | Item));
                    UseTemporary = true;
                    fieldelement(LineNo; ItemGHCheckListBuffer."Line No.")
                    {
                    }
                    fieldelement(Type; ItemGHCheckListBuffer.Type)
                    {
                    }
                    fieldelement(Caption; ItemGHCheckListBuffer.Caption)
                    {
                    }
                    fieldelement(IsBold; ItemGHCheckListBuffer.IsBold)
                    {
                    }
                    fieldelement(IsMandatory; ItemGHCheckListBuffer.IsMandatory)
                    {
                    }
                    textelement(Controls)
                    {
                        tableelement(controlghchecklistbuffer; "Checklist Buffer")
                        {
                            LinkFields = "Parent Line No." = field("Line No.");
                            LinkTable = ItemGHCheckListBuffer;
                            MinOccurs = Zero;
                            XmlName = 'Control';
                            SourceTableView = sorting("Line No.") order(ascending) where(Type = filter(<> Group), Type = filter(<> Item));
                            UseTemporary = true;
                            fieldelement(ParentLineNo; ControlGHCheckListBuffer."Parent Line No.")
                            {
                            }
                            fieldelement(LineNo; ControlGHCheckListBuffer."Line No.")
                            {
                            }
                            fieldelement(Value; ControlGHCheckListBuffer.Value)
                            {
                            }
                            fieldelement(Color; ControlGHCheckListBuffer.Color)
                            {
                            }
                            fieldelement(Caption; ControlGHCheckListBuffer.Caption)
                            {
                            }
                            fieldelement(SubType; ControlGHCheckListBuffer."Sub Type")
                            {
                            }
                            fieldelement(Selected; ControlGHCheckListBuffer.Selected)
                            {
                            }
                            fieldelement(AssistEdit; ControlGHCheckListBuffer."Assist Edit")
                            {
                            }
                            fieldelement(TextLength; ControlGHCheckListBuffer.TextLength)
                            {
                            }
                            textelement(Extended)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    Extended := 'False';
                                end;
                            }
                            fieldelement(IsDisabled; ControlGHCheckListBuffer.IsDisabled)
                            {
                            }
                        }
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }


    procedure FillItemCheckList(var GHCheckList: Record "Checklist Buffer")
    begin
        GHCheckList.Reset;
        GHCheckList.SetFilter(Type, '%1|%2', GHCheckList.Type::Group, GHCheckList.Type::Item);
        if GHCheckList.FindFirst then
            repeat
                ItemGHCheckListBuffer.Init;
                ItemGHCheckListBuffer := GHCheckList;
                ItemGHCheckListBuffer.Insert;
            until GHCheckList.Next = 0;

        GHCheckList.Reset;
        GHCheckList.SetFilter(Type, '<>%1', GHCheckList.Type::Group);
        GHCheckList.SetFilter(Type, '<>%1', GHCheckList.Type::Item);
        if GHCheckList.FindFirst then
            repeat
                ControlGHCheckListBuffer.Init;
                ControlGHCheckListBuffer := GHCheckList;
                ControlGHCheckListBuffer.Insert;
            until GHCheckList.Next = 0;
    end;
}

