Page 25006067 "Picture FactBox"
{
    Caption = 'Picture FactBox';
    Editable = true;
    PageType = CardPart;
    SourceTable = Picture;
    SourceTableView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");

    layout
    {
        area(content)
        {
            field(Thumbnail; Rec.Thumbnail)
            {
                Caption = 'Description';
                ApplicationArea = Basic;
                ShowCaption = false;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = Basic;
                Caption = 'Description';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Select)
            {
                ApplicationArea = Basic;
                Caption = 'Select';
                Image = Import;

                trigger OnAction()
                begin
                    PictureMgt.BLOBImport(Rec, '');
                end;
            }
            action(Manage)
            {
                ApplicationArea = Basic;
                Caption = 'Manage';
                Image = ExtendedDataEntry;

                trigger OnAction()
                begin
                    Page.RunModal(Page::"Picture Card", Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Picture2: Record Picture;
    begin
    end;

    var
        PictureMgt: Codeunit "Picture Management";
        NextAvlbl: Boolean;
        PrevAvlbl: Boolean;
        Step: Integer;
        NotFirstRun: Boolean;
}

