Page 25006262 "Vehicle Info FactBox"
{
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve
    // 
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added Contracts and Warranties controls

    Caption = 'Vehicle Information';
    PageType = CardPart;
    SourceTable = Vehicle;

    layout
    {
        area(content)
        {
            field(LastVFRun1; LastVFRun1)
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006180';
                Visible = IsVFRun1Visible_fBox;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastSLEntry(Rec."Serial No.");
                end;
            }
            field(LastVFRun2; LastVFRun2)
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006255';
                Visible = IsVFRun2Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastSLEntry(Rec."Serial No.");
                end;
            }
            field(LastVFRun3; LastVFRun3)
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006260';
                Visible = IsVFRun3Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastSLEntry(Rec."Serial No.");
                end;
            }
            field(SalesDate; Rec."Sales Date")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Date';

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicle(Rec."Serial No.");
                end;
            }
            field(Contracts; Format(ServInfoPaneMgt.GetVehicleContractsCount(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Contracts';

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleContracts(Rec);
                end;
            }
            field(Warranties; Format(ServInfoPaneMgt.GetVehicleWarrantyCount(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Warranties';

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleWarranties(Rec);
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


    procedure CalcVF(VehSerialNo: Code[20])
    begin
        //the code is copied from codeunit "Service Info-Pane Mgt. EDMS" function CalcLastVFRun1
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetFilter("Entry Type", '%1|%2', ServiceLedgerEntry."entry type"::Usage, ServiceLedgerEntry."entry type"::Info);
        if ServiceLedgerEntry.FindLast then begin
            LastVFRun1 := ServiceLedgerEntry."Variable Field Run 1";
            LastVFRun2 := ServiceLedgerEntry."Variable Field Run 2";
            LastVFRun3 := ServiceLedgerEntry."Variable Field Run 3";
        end else begin
            LastVFRun1 := 0;
            LastVFRun2 := 0;
            LastVFRun3 := 0;
        end;

        exit;
    end;
}

