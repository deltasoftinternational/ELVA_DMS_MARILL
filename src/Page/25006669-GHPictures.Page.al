Page 25006669 "GH Pictures"
{
    Caption = 'Pictures';
    CardPageID = "Picture Card";
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = Picture;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Type';
                    Visible = false;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Subtype';
                    Visible = false;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source ID';
                    Visible = false;
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Ref. No.';
                    Visible = false;
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
                    Visible = false;
                }
                field(Default; Rec.Default)
                {
                    ApplicationArea = Basic;
                    Caption = 'Default';
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(Image; Rec.Blob)
                {
                    ApplicationArea = Basic;
                }
                field(Thumbnail; Rec.Thumbnail)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }


    var
        PictureMgt: Codeunit "Picture Management";


}

