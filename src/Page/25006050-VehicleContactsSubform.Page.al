Page 25006050 "Vehicle Contacts Subform"
{
    Caption = 'Vehicle Contacts Subform';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SaveValues = true;
    SourceTable = "Vehicle Contact";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RelationshipCode; Rec."Relationship Code")
                {
                    ApplicationArea = Basic;
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(ContactName; Rec."Contact Name")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(DoNotUseInService; Rec."Do Not Use In Service")
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

