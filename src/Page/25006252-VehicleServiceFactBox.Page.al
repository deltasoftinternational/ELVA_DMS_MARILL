Page 25006252 "Vehicle Service FactBox"
{
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve

    Caption = 'Last Service Data';
    PageType = CardPart;
    SourceTable = Vehicle;

    layout
    {
        area(content)
        {
            field(LastVisitDate; Format(LastVisitDate))
            {
                ApplicationArea = Basic;
                Caption = 'Last Visit Date';

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder(Rec."Serial No.");
                end;
            }
            field(LastVFRun1; LastVFRun1)
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006180';
                Visible = IsVFRun1Visible_fBox;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder(Rec."Serial No.");
                end;
            }
            field(LastVFRun2; LastVFRun2)
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006255';
                Visible = IsVFRun2Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder(Rec."Serial No.");
                end;
            }
            field(LastVFRun3; LastVFRun3)
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006260';
                Visible = IsVFRun3Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder(Rec."Serial No.");
                end;
            }
            field(Insurance; ServInfoPaneMgt.VehicleGetInsuranceCount(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Insurance';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.VehicleLookupVehicleInsurancesPlans(Rec);
                end;
            }
            field(Contracts; ServInfoPaneMgt.GetVehicleInfoContractsCount(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Contracts';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleInfoContracts(Rec);
                end;
            }
            field(Recallcampaigns; ServInfoPaneMgt.VehicleGetActiveRecallCount(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Recall campaigns';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.VehicleLookupActiveRecalls(Rec);
                end;
            }
            field(LastMVRun1; LastMVRun1)
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006293,110';
                Caption = 'Telematic Hours';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupMapViewVehicleTelematics(Rec."Serial No.");
                end;
            }
            field(LinkedVehicles; ServInfoPaneMgt.GetVehicleLinkedVehiclesCount(Rec."Serial No."))
            {
                ApplicationArea = Basic;
                Caption = 'Linked Vehicles';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleLinkedVehicles(Rec."Serial No.");
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcVF(Rec."Serial No.");
        LastMVRun1 := CalcMVRun1(Rec."Serial No.");
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(Rec.Find(Which));
    end;

    trigger OnInit()
    begin
        IsVFRun1Visible_fBox := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
    end;

    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
        ServInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        [InDataSet]
        IsVFRun1Visible_fBox: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        LastVFRun1: Decimal;
        LastVFRun2: Decimal;
        LastVFRun3: Decimal;
        LastVisitDate: Date;
        LastMVRun1: Decimal;


    procedure ShowDetails()
    begin
        Page.Run(Page::"Vehicle Card", Rec);
    end;


    procedure CalcVF(VehSerialNo: Code[20])
    begin
        //the code is copied from codeunit "Service Info-Pane Mgt. EDMS" function CalcLastVFRun1
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Usage);
        if ServiceLedgerEntry.FindLast then begin
            LastVFRun1 := ServiceLedgerEntry."Variable Field Run 1";
            LastVFRun2 := ServiceLedgerEntry."Variable Field Run 2";
            LastVFRun3 := ServiceLedgerEntry."Variable Field Run 3";
            LastVisitDate := ServiceLedgerEntry."Posting Date";
        end else begin
            LastVFRun1 := 0;
            LastVFRun2 := 0;
            LastVFRun3 := 0;
            LastVisitDate := 0D;
        end;

        exit;
    end;

    local procedure CalcMVRun1(VehSerialNo: Code[20]): Decimal
    var
        MapViewVehicleTelematics: Record "Vehicle Telematics";
    begin
        MapViewVehicleTelematics.Reset;
        MapViewVehicleTelematics.SetRange("Vehicle Serial No.", VehSerialNo);
        if MapViewVehicleTelematics.FindLast then
            exit(MapViewVehicleTelematics."Variable Field Run 1");
    end;
}

