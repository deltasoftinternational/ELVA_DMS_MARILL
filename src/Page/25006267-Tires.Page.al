Page 25006267 "Tires"
{
    ApplicationArea = Basic;
    Caption = 'Tires';
    CardPageID = "Tire Card";
    PageType = List;
    SourceTable = Tire;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldTireRun; Rec."Variable Field Tire Run")
                {
                    ApplicationArea = Basic;
                }
                field(Available; Rec.Available)
                {
                    ApplicationArea = Basic;
                }
                field(CurrentVehicleSerialNo; Rec."Current Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentVehicleAxleCode; Rec."Current Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CurrentVehicleTirePosition; Rec."Current Vehicle Tire Position")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1101904010>")
            {
                ApplicationArea = Basic;
                Caption = '&Entries';
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Tire Entries";
                RunPageLink = "Tire Code" = field(Code);
                ShortCutKey = 'Ctrl+F7';
            }
        }
    }
}

