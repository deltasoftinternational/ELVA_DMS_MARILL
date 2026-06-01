Page 25006253 "Service Document FactBox EDMS"
{
    // 17.12.2014 EDMS P12
    //   * Code from all triggers OnLookup moved to triggers OnDrillDown
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added fields:
    //     ServiceQuotes
    //     ServiceOrders

    Caption = 'Vehicle Service Info.';
    PageType = CardPart;
    SourceTable = "Service Header EDMS";

    layout
    {
        area(content)
        {
            field(LastVisitDate; Format(ServInfoPaneMgt.CalcLastVisitDate(Rec."Vehicle Serial No.")))
            {
                ApplicationArea = Basic;
                Caption = 'Last Visit Date';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder(Rec."Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgtCalcLastVisitVFRun1VehicleSerialNo; ServInfoPaneMgt.CalcLastVisitVFRun1(Rec."Vehicle Serial No."))
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006180';
                DrillDown = true;
                Visible = IsVFRun1Visible_fBox;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder(Rec."Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgtCalcLastVisitVFRun2VehicleSerialNo; ServInfoPaneMgt.CalcLastVisitVFRun2(Rec."Vehicle Serial No."))
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006255';
                Visible = IsVFRun2Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder(Rec."Vehicle Serial No.");
                end;
            }
            field(ServInfoPaneMgtCalcLastVisitVFRun3VehicleSerialNo; ServInfoPaneMgt.CalcLastVisitVFRun3(Rec."Vehicle Serial No."))
            {
                ApplicationArea = Basic;
                CaptionClass = '7,25006145,25006260';
                Visible = IsVFRun3Visible;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupLastServiceOrder(Rec."Vehicle Serial No.");
                end;
            }
            field(SalesDate; Format(ServInfoPaneMgt.CalcVehSalesDate(Rec."Vehicle Serial No.")))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Date';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicle(Rec."Vehicle Serial No.");
                end;
            }
            field(ServicePlans; ServInfoPaneMgt.GetServicePlanCount(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Service Plans';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupServicePlans(Rec)
                end;
            }
            field(Warranties; ServInfoPaneMgt.GetVehWarrantyCount(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Warranties';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehWarranties(Rec)
                end;
            }
            field(RecallCampaigns; ServInfoPaneMgt.GetActiveRecallCount(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Recall Campaigns';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupActiveRecalls(Rec)
                end;
            }
            field(ComponentsServicePlans; ServInfoPaneMgt.GetComponentServicePlansCount(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Component''s Service Plans';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleComponentsPlans(Rec);
                end;
            }
            field(Insurance; ServInfoPaneMgt.GetInsuranceCount(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Insurance';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleInsurancesPlans(Rec);
                end;
            }
            field(ServiceQuotes; ServInfoPaneMgt.GetVehicleDocCount(Rec, Doctype::Quote))
            {
                ApplicationArea = Basic;
                Caption = 'Service Quotes';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleDoc(Rec, Doctype::Quote);
                end;
            }
            field(ServiceOrders; ServInfoPaneMgt.GetVehicleDocCount(Rec, Doctype::Order))
            {
                ApplicationArea = Basic;
                Caption = 'Service Orders';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleDoc(Rec, Doctype::Order);
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
                    ServInfoPaneMgt.LookupMapViewVehicleTelematics(Rec."Vehicle Serial No.");
                end;
            }
            field(ExpectedSockReceiptDate; Format(ServInfoPaneMgt.CalcExpectedSockReceiptDate(Rec."Vehicle Serial No.")))
            {
                ApplicationArea = Basic;
                Caption = 'Expected Stock Receipt Date';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleExpectedReceipt(Rec."Vehicle Serial No.");
                end;
            }
            field(LinkedVehicles; ServInfoPaneMgt.GetVehicleLinkedVehiclesCount(Rec."Vehicle Serial No."))
            {
                ApplicationArea = Basic;
                Caption = 'Linked Vehicles';
                DrillDown = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.LookupVehicleLinkedVehicles(Rec."Vehicle Serial No.");
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //MESSAGE('IsVFRun1Visible_fBox='+FORMAT(IsVFRun1Visible_fBox)+', No='+"No.");
        LastMVRun1 := CalcMVRun1(Rec."Vehicle Serial No.");
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
        ServInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        [InDataSet]
        IsVFRun1Visible_fBox: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;
        DocType: Option Quote,"Order","Return Order";
        LastMVRun1: Decimal;


    procedure ShowDetails()
    begin
        Page.Run(Page::"Vehicle Card", Rec);
    end;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
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

