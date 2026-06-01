Page 25006047 "Object Picture FactBox"
{
    Caption = 'Object Picture FactBox';
    CardPageID = Pictures;
    PageType = CardPart;
    SourceTable = Picture;
    SourceTableView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");

    layout
    {
        area(content)
        {
            field(Blob; Rec.Blob)
            {
                ApplicationArea = Basic;
                ShowCaption = false;
            }
            field("<Description>"; Rec.Description)
            {
                ApplicationArea = Basic;
            }

        }
    }

    actions
    {
        area(processing)
        {
            action(Previous)
            {
                ApplicationArea = Basic;
                Caption = 'Previous';
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    Rec.Ascending(false); //analog of NEXT(-1)
                    Step := Rec.Next(1);
                    Rec.Ascending(true);
                end;
            }
            action(Next)
            {
                ApplicationArea = Basic;
                Caption = 'Next';
                Image = NextRecord;

                trigger OnAction()
                begin
                    Step := Rec.Next(1);
                end;
            }
            action(Pictures)
            {
                ApplicationArea = Basic;
                Caption = 'Pictures';
                RunObject = Page Pictures;
                RunPageLink = "Source Type" = field("Source Type"),
                              "Source Subtype" = field("Source Subtype"),
                              "Source ID" = field("Source ID"),
                              "Source Ref. No." = field("Source Ref. No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Picture2: Record Picture;
    begin
        if (xRec."Source ID" <> Rec."Source ID") and (Rec."Source ID" <> '') then begin
            Picture2.Reset;
            Picture2.CopyFilters(Rec);
            Picture2.SetRange(Default, true);
            if Picture2.FindFirst then begin
                Rec.Get(Picture2."No.");
                Rec.CalcFields(Blob);
            end;
        end;
    end;

    var
        PictureMgt: Codeunit "Picture Management";
        NextAvlbl: Boolean;
        PrevAvlbl: Boolean;
        Step: Integer;
        NotFirstRun: Boolean;
        ">---": Integer;
        ServInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        [InDataSet]
        IsVFRun1Visible_fBox: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
}

