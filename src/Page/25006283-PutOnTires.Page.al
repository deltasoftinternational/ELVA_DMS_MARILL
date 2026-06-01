Page 25006283 "Put On Tires"
{
    Caption = 'Put On Tires';
    Editable = false;
    PageType = List;
    SourceTable = "Tire Entry";
    SourceTableView = where(Open = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TireCode; Rec."Tire Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAxleCode; Rec."Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                }
                field(TirePositionCode; Rec."Tire Position Code")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(TireDescription; Rec."Tire Description")
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

