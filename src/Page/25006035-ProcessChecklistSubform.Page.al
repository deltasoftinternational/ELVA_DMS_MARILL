Page 25006035 "Process Checklist Subform"
{
    // 11/09/2017 GP1 P1
    //   *Changed default column visibility

    AutoSplitKey = true;
    Caption = 'Process Checklist Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Process Checklist Line";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                IndentationColumn = NameIndent;
                IndentationControls = QuestionText;
                field(QuestionNo; Rec."Question No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(QuestionText; Rec."Question Text")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field(AnswerText; Rec."Answer Text")
                {
                    ApplicationArea = Basic;
                    Editable = AnswerEditable;
                }
                field(QuestionarySubjectGroupCode; Rec."Questionary Subject Group Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
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

    trigger OnAfterGetRecord()
    begin
        case Rec."Line Type" of
            Rec."line type"::Group:
                begin
                    NameIndent := 0;
                    NameEmphasize := true;
                    AnswerEditable := false;
                end;
            Rec."line type"::Line:
                begin
                    NameIndent := 1;
                    NameEmphasize := false;
                    AnswerEditable := true;
                end;
            else
                NameIndent := 0;
                NameEmphasize := false;
                AnswerEditable := false;
        end;
    end;

    var
        [InDataSet]
        AnswerEditable: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
}

