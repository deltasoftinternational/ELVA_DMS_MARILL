Page 25006164 "Service Package Version-Select"
{
    Caption = 'Service Package Versions-Select';
    Editable = false;
    PageType = List;
    SourceTable = "Service Package Version";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(PackageNo; Rec."Package No.")
                {
                    ApplicationArea = Basic;
                }
                field(PackageDescription; Rec."Package Description")
                {
                    ApplicationArea = Basic;
                }
                field(VersionNo; Rec."Version No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ProdYearFrom; Rec."Prod. Year From")
                {
                    ApplicationArea = Basic;
                }
                field(ProdYearTo; Rec."Prod. Year To")
                {
                    ApplicationArea = Basic;
                }
                field(VINFrom; Rec."VIN From")
                {
                    ApplicationArea = Basic;
                }
                field(VINTo; Rec."VIN To")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Card)
            {
                ApplicationArea = Basic;
                Caption = 'Card';
                Image = Card;
                Promoted = true;
                RunObject = Page "Service Package Card";
                RunPageLink = "No." = field("Package No.");
                ShortCutKey = 'Shift+F5';
            }
            action("<Action1101907018>")
            {
                ApplicationArea = Basic;
                Caption = 'Version Lines';
                Image = Version;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Service Package Version Lines";
                RunPageLink = "Package No." = field("Package No."),
                              "Version No." = field("Version No.");
            }
        }
    }

    var
        SelectionRecordSet: Record "Service Package Version";


    procedure GetSelectedRecordSet(var RecordSet: Record "Service Package Version"): Boolean
    begin
        RecordSet := SelectionRecordSet;
        exit(SelectionRecordSet.MarkedOnly);
    end;
}

