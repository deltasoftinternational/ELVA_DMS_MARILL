Page 25006287 "Quest. Subj. Group Questions"
{
    // 06/03/2018 GH P1
    //   *Added ENG captions
    //   *Major UI modifications

    AutoSplitKey = true;
    Caption = 'Questionary Subject Group Questions';
    PageType = List;
    SourceTable = "Quest. Subj. Group Question";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = Rec.Indentation;
                IndentationControls = QuestionText;
                field(QuestionarySubjectGroupCode; Rec."Questionary Subject Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(QuestionText; Rec."Question Text")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(SubType; Rec.SubType)
                {
                    ApplicationArea = Basic;
                }
                field(IsBold; Rec.IsBold)
                {
                    ApplicationArea = Basic;
                }
                field(IsMandatory; Rec.IsMandatory)
                {
                    ApplicationArea = Basic;
                }
                field(ControlColor; Rec."Control Color")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ControlAssistEdit; Rec."Control AssistEdit")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AnswerType; Rec."Answer Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DefaultValue; Rec."Default Value")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MINConstrain; Rec."MIN Constrain")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MAXConstrain; Rec."MAX Constrain")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            part(Control25006000; "Quest. Group Suj. Q. Answers S")
            {
                ApplicationArea = All;
                Caption = 'Answers';
                Editable = AllowModifyValues;
                SubPageLink = "Questionary Subject Group Code" = field("Questionary Subject Group Code"),
                              "Question No." = field("No.");
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("New Line from Template")
            {
                ApplicationArea = Basic;
                Image = Template;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GHFeatureMgt: Codeunit "Checklist Features Mgt.";
                begin
                    GHFeatureMgt.InsertQuestionGroupQuestionFromTemplate(Rec);
                    CurrPage.Update;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        AllowModifyValues := Rec."Answer Type" in [Rec."answer type"::Dictionary, Rec."answer type"::Option];
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //06/03/2018 GH P1 >>
        Rec."Answer Type" := Rec."answer type"::Integer;
    end;

    var
        [InDataSet]
        AllowModifyValues: Boolean;
}

