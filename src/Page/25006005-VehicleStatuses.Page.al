Page 25006005 "Vehicle Statuses"
{
    ApplicationArea = Basic;
    Caption = 'Vehicle Statuses';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Status";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleStatusGroupCode; rec."Vehicle Status Group Code")
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
            group(VehicleStatus)
            {
                Caption = 'Vehicle Status';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(25006021),
                                  "No." = field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }
}

