Page 25006030 "Vehicle Components"
{
    Caption = 'Vehicle Components';
    PageType = List;
    SourceTable = "Vehicle Component";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ParentVehicleSerialNo; Rec."Parent Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = Basic;
                }
                field(DateInstalled; Rec."Date Installed")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

