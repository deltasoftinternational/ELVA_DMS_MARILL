Page 25006009 "Vehicle Accounting Cycles"
{
    Caption = 'Vehicle Accounting Cycles';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Vehicle Accounting Cycle";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                Editable = false;
                field(VehicleSerialNo; rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; rec.VIN)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Default; rec.Default)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(AccountingCycle)
            {
                Caption = 'Accounting Cycle';
                action(SetAsDefault)
                {
                    ApplicationArea = Basic;
                    Caption = 'Set As Default';
                    Image = Default;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        VehAccCycleMgt: Codeunit VehicleAccountingCycleMgt;
                    begin
                        rec.TestField(Default, false);
                        VehAccCycleMgt.SetAsDefault(Rec);
                    end;
                }
                action(CreateNew)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create New';
                    Image = New;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        VehAccCycleMgt: Codeunit VehicleAccountingCycleMgt;
                        VehAccCycleTemp: Record "Vehicle Accounting Cycle" temporary;
                    begin
                        if rec."No." = '' then begin
                            VehAccCycleTemp.Init;
                            VehAccCycleTemp."Vehicle Serial No." := rec.GetRangeMin("Vehicle Serial No.");
                            VehAccCycleMgt.CreateNewCycle_User(VehAccCycleTemp)
                        end
                        else
                            VehAccCycleMgt.CreateNewCycle_User(Rec);
                    end;
                }
            }
        }
    }
}

