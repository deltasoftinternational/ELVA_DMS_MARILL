Page 25006187 "Service Comment Sheet EDMS"
{
    // 13.05.2014 Elva Baltic P21 #S0100 MMG7.00
    //   Changed PageType property from List to Card (for editing on lookup)
    // 
    // 27.03.2014 Elva Baltic P18 #RX029 MMG7.00
    //   Added field "Satisfaction"

    AutoSplitKey = true;
    Caption = 'Service Comment Sheet EDMS';
    DataCaptionFields = Type, "No.";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Service Comment Line EDMS";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                        Rec.SetExtendedComment(Rec.Comment);
                        CurrPage.Update();
                    end;
                }
                field(ExtComment; ExtCommentText)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Comment (Extended)';

                    trigger OnDrillDown()
                    var
                        ExtDescrMgt: Codeunit "Extended Descr. Mgt";
                        NewText: Text;
                        OldText: Text;
                    //SelectCommentTypeMsg: Label 'Please select a comment type';
                    begin
                        //if "Line No." = 0 then begin
                        //    Message(SelectCommentTypeMsg);
                        //    exit;
                        //end;

                        OldText := Rec.GetExtendeComment();
                        if ExtDescrMgt.Input(OldText, 'Extended Comment', 0, true, NewText) then begin
                            if NewText <> OldText then begin
                                Rec.SetExtendedComment(NewText);
                                ExtCommentText := NewText;
                            end;
                        end;
                    end;
                }
                field(CommentTypeCode; Rec."Comment Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnAfterGetCurrRecord()
    begin
        ExtCommentText := Rec.GetExtendeComment();
    end;

    trigger OnAfterGetRecord()
    begin
        ExtCommentText := Rec.GetExtendeComment();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine;
    end;

    var
        ExtCommentText: Text;
}

