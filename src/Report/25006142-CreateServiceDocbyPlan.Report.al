Report 25006142 "Create Service Doc. by Plan"
{
    // 13.06.2013 EDMS P8
    //   * Merged code with NAV2009
    // 
    // //HeaderFiltered, VehicleFiltered, VehicleContactFrom, ContactBusinessRelationFrom etc - are used only to get filters for processing
    // //ServiceHeaderTmp - used to make sure that process generate one document per one vehicle, that are situations when several plans
    // // for one car.
    // //For automatique/simple run it is need to set parameters: VehicleServicePlanStage."Expected Service Date" and
    // // ContactBusinessRelationTo."Business Relation Code"

    Caption = 'Create Service Doc. by Plan';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(VehicleFiltered; Vehicle)
        {
            RequestFilterFields = "Serial No.";
            column(ReportForNavId_4770; 4770)
            {
            }
            dataitem(VehicleContactToFiltered; "Vehicle Contact")
            {
                DataItemLink = "Vehicle Serial No." = field("Serial No.");
                DataItemTableView = sorting("Vehicle Serial No.", "Relationship Code", "Contact No.") order(ascending);
                column(ReportForNavId_8819; 8819)
                {
                }
                dataitem(ContactBusinessRelationTo; "Contact Business Relation")
                {
                    DataItemLink = "Contact No." = field("Contact No.");
                    DataItemTableView = sorting("Contact No.", "Business Relation Code") order(ascending);
                    column(ReportForNavId_7463; 7463)
                    {
                    }
                    dataitem(CustomerToFiltered; Customer)
                    {
                        DataItemLink = "No." = field("No.");
                        DataItemTableView = sorting("No.") order(ascending);
                        column(ReportForNavId_6609; 6609)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CustomerToCurrent.Get(CustomerToFiltered."No.");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ContactBusinessRelationTo."Business Relation Code" <> MarketingSetup."Bus. Rel. Code for Customers" then
                            CurrReport.Skip;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    VehicleContactToFiltered.SetRange("Relationship Code", DefContRelationshipCode);
                end;
            }
            dataitem(PlanFiltered; "Vehicle Service Plan")
            {
                DataItemLink = "Vehicle Serial No." = field("Serial No.");
                column(ReportForNavId_6241; 6241)
                {
                }
                dataitem(PlanStageFiltered; "Vehicle Service Plan Stage")
                {
                    DataItemLink = "Vehicle Serial No." = field("Vehicle Serial No."), "Plan No." = field("No.");
                    RequestFilterFields = "Expected Service Date";
                    column(ReportForNavId_3951; 3951)
                    {
                    }
                    dataitem(PackageFiltered; "Service Package")
                    {
                        DataItemLink = "No." = field("Package No.");
                        DataItemTableView = sorting("No.") order(ascending);
                        column(ReportForNavId_3191; 3191)
                        {
                        }
                        dataitem(PackageVersionFiltered; "Service Package Version")
                        {
                            DataItemLink = "Package No." = field("No.");
                            DataItemTableView = sorting("Package No.", "Version No.") order(ascending);
                            column(ReportForNavId_2440; 2440)
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                ServicePackageVersion.Reset;
                                ServicePackageVersion.CopyFilters(PackageVersionFiltered);
                                if not ServicePackageVersion.FindFirst then
                                    CurrReport.Skip;

                                VehicleServicePlanStageProc.Get(PlanStageFiltered."Vehicle Serial No.", PlanStageFiltered."Plan No.",
                                  PlanStageFiltered.Recurrence, PlanStageFiltered.Code);
                                VehicleServicePlanStageProc.Mark(true);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if VehicleFiltered."Model Version No." <> '' then
                                exit;
                            VehicleServicePlanStageProc.Get(PlanStageFiltered."Vehicle Serial No.", PlanStageFiltered."Plan No.",
                              PlanStageFiltered.Recurrence, PlanStageFiltered.Code);
                            VehicleServicePlanStageProc.Mark(true);
                        end;
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                ServiceHeader.Reset;
                ServiceHeader.Init;
                ServiceHeader."Vehicle Serial No." := VehicleFiltered."Serial No.";
                ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
                ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehicleFiltered."Serial No.");
                if not ServiceLedgerEntry.FindLast then
                    CurrReport.Skip;

                VehicleTelematics.Reset;
                VehicleTelematics.SetCurrentKey("Date Stamp", "Entry No.");
                VehicleTelematics.SetRange("Vehicle Serial No.", VehicleFiltered."Serial No.");
                If VehicleTelematics.FindFirst then;

                TmpDate := Today;
                if OrderDate > 0D then
                    TmpDate := OrderDate;
                ServiceHeader."Order Date" := TmpDate;
                if VehicleTelematics."Variable Field Run 1" > ServiceLedgerEntry."Variable Field Run 1" then
                    ServiceHeader."Variable Field Run 1" := VehicleTelematics."Variable Field Run 1"
                else
                    ServiceHeader."Variable Field Run 1" := ServiceLedgerEntry."Variable Field Run 1";
                if VehicleTelematics."Variable Field Run 2" > ServiceLedgerEntry."Variable Field Run 2" then
                    ServiceHeader."Variable Field Run 2" := VehicleTelematics."Variable Field Run 2"
                else
                    ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                if VehicleTelematics."Variable Field Run 3" > ServiceLedgerEntry."Variable Field Run 3" then
                    ServiceHeader."Variable Field Run 3" := VehicleTelematics."Variable Field Run 3"
                else
                    ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 1"), VehicleServicePlanStage);
                if not IsFound then
                    IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 2"), VehicleServicePlanStage);
                if not IsFound then
                    IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 3"), VehicleServicePlanStage);
                if not IsFound then
                    IsFound := ServiceHeader.IsAchievedServStageByInterval(VehicleServicePlanStage);
                if not IsFound then
                    CurrReport.Skip;

                if VehicleServicePlanStage.FindFirst then
                    repeat
                        VehicleServicePlanStageProc.Get(VehicleServicePlanStage."Vehicle Serial No.", VehicleServicePlanStage."Plan No.",
                          VehicleServicePlanStage.Recurrence, VehicleServicePlanStage.Code);
                        VehicleServicePlanStageProc.Mark(true);
                    until VehicleServicePlanStage.Next = 0;
            end;
        }
        dataitem(ProcLoop; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_5815; 5815)
            {
            }

            trigger OnAfterGetRecord()
            var
                VehicleContact: Record "Vehicle Contact";
            begin
            end;

            trigger OnPreDataItem()
            begin
                VehicleServicePlanStageProc.MarkedOnly(true);
                // FOR TESTING
                //MESSAGE(Text002, VehicleServicePlanStageProc.COUNT, VehicleServicePlanStageProc.TABLECAPTION);
                SetRange(Number, 1, 1);
                ServicePlanMgt.SetVehicleG(VehicleFiltered);
                ServicePlanMgt.SetVehicleContactG(VehicleContactToFiltered);
                ServicePlanMgt.SetContactBusinessRelationG(ContactBusinessRelationTo);
                ServicePlanMgt.SetCustomerG(CustomerToFiltered);
                ServicePlanMgt.SetVehicleServicePlanG(PlanFiltered);
                ServicePlanMgt.SetVehicleServicePlanStageG(PlanStageFiltered);
                ServicePlanMgt.SetServicePackageG(PackageFiltered);
                ServicePlanMgt.SetServicePackageVersionG(PackageVersionFiltered);
                RecCount := ServicePlanMgt.CreateOrdersByFiltered(OrderDate, 0);
                ServiceHeader."Document Type" := ServiceHeader."document type"::Order;
                if RecCount > 0 then
                    Message(TEXT001, Format(RecCount), ServiceHeader.TableCaption, Format(ServiceHeader."Document Type"))
                else
                    Message(Text003);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(OrderDate; OrderDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order Date';
                }
                field(DefContRelationshipCode; DefContRelationshipCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Default Contact Relationship Code';
                    TableRelation = "Vehicle-Contact Relationship";
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ServiceMgtSetup.Get;
            DefContRelationshipCode := ServiceMgtSetup."Serv. Plan Cont. Relationship";
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if ServiceHeaderTmp.Count > 0 then
            Message(TEXT001, ServiceHeaderTmp.Count, ServiceHeaderTmp.TableCaption, Format(ServiceHeader."Document Type"))
    end;

    trigger OnPreReport()
    begin
        ServiceHeaderTmp.DeleteAll;
        ServiceHeaderTmp.Reset;
        VehicleContactToFiltered.SetRange("Relationship Code", DefContRelationshipCode);
        MarketingSetup.Get;
    end;

    var
        MarketingSetup: Record "Marketing Setup";
        ServiceHeader: Record "Service Header EDMS";
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        VehicleServicePlanStageProc: Record "Vehicle Service Plan Stage";
        ServicePackageVersion: Record "Service Package Version";
        CustomerToCurrent: Record Customer;
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
        ContactBusinessRelation: Record "Contact Business Relation";
        VehicleTelematics: Record "Vehicle Telematics";
        ServicePlanMgt: Codeunit "Service Plan Management";
        OrderDate: Date;
        DefContRelationshipCode: Code[10];
        TmpDate: Date;
        IsFound: Boolean;
        RecCount: Integer;
        CurrRecNo: Integer;
        TEXT001: label 'There is (are) generated %1 %2 as %3(s).';
        Text002: label 'Is found %1 %2.';
        RecExists: Boolean;
        Text003: label 'There is nothing to create.';
}

