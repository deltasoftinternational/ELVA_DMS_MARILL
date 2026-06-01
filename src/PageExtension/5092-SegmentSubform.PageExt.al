pageextension 25006082 "Segment Subform" extends "Segment Subform"//5092
{
    layout
    {
        addafter("Contact E-Mail")
        {
            field(VehiclesCount; Rec."Vehicles Count")
            {
                ApplicationArea = Basic;
                Visible = true;
            }
        }
    }
    actions
    {
        addafter(Attachment)
        {
            action(SublinesVehicles)
            {
                ApplicationArea = Basic;
                Caption = 'Sublines (Vehicles)';

                trigger OnAction()
                begin
                    rec.ShowContactVehicles;
                end;
            }
        }
    }
}