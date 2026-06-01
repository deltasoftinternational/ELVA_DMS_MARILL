Page 25006042 "Picture Card"
{
    InsertAllowed = false;
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = Picture;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Type';
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Subtype';
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source ID';
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Ref. No.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                }
                field(Imported; Rec.Imported)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imported';
                }
                field(Default; Rec.Default)
                {
                    ApplicationArea = Basic;
                    Caption = 'Default';
                }
                field(Blob; Rec.Blob)
                {
                    ApplicationArea = Basic;
                    Caption = 'Picture';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    Caption = 'No. Series';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //VALIDATE("Source Type", SourceType);
        //VALIDATE("Source Subtype", "Source Subtype");
        //VALIDATE("Source ID", SourceID);
        //VALIDATE("Source Ref. No.", SourceRefNo);
    end;

    trigger OnOpenPage()
    begin
        //MESSAGE(GETFILTERS);
    end;

    var
        SourceType: Integer;
        SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10";
        SourceID: Code[20];
        SourceRefNo: Integer;


    procedure SetParameters(ParSourceType: Integer; ParSourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10"; ParSourceID: Code[20]; ParSourceRefNo: Integer)
    begin
        SourceType := ParSourceType;
        SourceSubtype := ParSourceSubtype;
        SourceID := ParSourceID;
        SourceRefNo := ParSourceRefNo;
    end;
}

