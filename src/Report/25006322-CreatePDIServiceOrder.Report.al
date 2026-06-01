Report 25006322 "Create PDI Service Order"
{
    Caption = 'Create PDI Service Order';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            column(ReportForNavId_25006000; 25006000)
            {
            }
            dataitem("Vehicle Assembly Line"; "Vehicle Assembly Line")
            {
                DataItemLink = "Assembly ID" = field("Vehicle Assembly ID");
                DataItemTableView = where("Option Type" = const("Own Option"));
                column(ReportForNavId_25006001; 25006001)
                {
                }
                dataitem("Own Option"; "Own Option")
                {
                    DataItemLink = "Option Code" = field("Option Code");
                    DataItemTableView = where("Package No." = filter(<> ''));
                    column(ReportForNavId_25006002; 25006002)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ServicePackageVersion.Reset;
                        ServicePackageVersion.SetRange("Package No.", "Package No.");
                        ServicePackageVersion.SetRange("Model Code", "Sales Line"."Model Code");
                        if ServicePackageVersion.FindFirst then
                            InsertPDIPackege(ServicePackageVersion)
                        else begin
                            ServicePackageVersion.Reset;
                            ServicePackageVersion.SetRange("Package No.", "Package No.");
                            ServicePackageVersion.SetRange("Model Code", '');
                            if ServicePackageVersion.FindFirst then
                                InsertPDIPackege(ServicePackageVersion);
                        end;
                    end;
                }
            }
            Dataitem(VehicleAssemblyLine2; "Vehicle Assembly Line")
            {
                DataItemLink = "Assembly ID" = field("Vehicle Assembly ID");
                DataItemTableView = where("Option Type" = const(Item));
                column(ReportForNavId_25006003; 25006003)
                {
                }


                dataitem(Item; Item)
                {
                    DataItemLink = "No." = field("Option Code");
                    //DataItemTableView = where("Item Type" = const(Item));
                    column(ReportForNavId_25006004; 25006004)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        ServiceLine: Record "Service Line EDMS";
                        NewLineNo: Integer;
                    begin
                        if ServiceOrderNo = '' then
                            CreateServHeader;
                        ServiceLine.Reset;
                        ServiceLine.SetRange("Document Type", ServiceLine."Document Type"::Order);
                        ServiceLine.SetRange("Document No.", ServiceOrderNo);
                        If ServiceLine.FindLast then
                            NewLineNo := ServiceLine."Line No." + 10000
                        else
                            NewLineNo := 10000;
                        ServiceLine.Reset;
                        ServiceLine.Init();
                        ServiceLine.Validate("Document Type", ServiceLine."Document Type"::Order);
                        ServiceLine.Validate("Document No.", ServiceOrderNo);
                        ServiceLine."Line No." := NewLineNo;
                        ServiceLine.Insert(true);
                        ServiceLine.Type := ServiceLine.Type::Item;
                        ServiceLine.Validate("No.", VehicleAssemblyLine2."Option Code");
                        ServiceLine.Validate(Quantity, 1);
                        ServiceLine.Modify;

                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                ServiceOrderNo := '';
                if MakeSetup.Get("Make Code") then;
                if MakeSetup."PDI Service Package No." <> '' then begin
                    ServicePackageVersion.Reset;
                    ServicePackageVersion.SetRange("Package No.", MakeSetup."PDI Service Package No.");
                    ServicePackageVersion.SetRange("Model Code", "Model Code");
                    if ServicePackageVersion.FindFirst then
                        InsertPDIPackege(ServicePackageVersion)
                    else begin
                        ServicePackageVersion.Reset;
                        ServicePackageVersion.SetRange("Package No.", MakeSetup."PDI Service Package No.");
                        ServicePackageVersion.SetRange("Model Code", '');
                        if ServicePackageVersion.FindFirst then
                            InsertPDIPackege(ServicePackageVersion);
                    end;
                end;
                if ServiceOrderNo = '' then
                    CreateServHeader;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CustomerNoBillTo; CustomerNoBillTo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bill-to Customer No.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Customer.Reset;
                        Customer.SetRange(Internal, true);
                        if not Customer.FindFirst then begin
                            Error(Text004, Customer.TableCaption, Customer.FieldCaption(Internal));
                        end else begin
                            if (Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK) then
                                CustomerNoBillTo := Customer."No.";
                        end;
                    end;
                }
                field(OrderDate; StartingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requested Starting Date';
                }
                field(PlanedDate; FinishingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requested Finishing Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        OfficeMgt: Codeunit "Office Management";
        ServiceOrder: Page "Service Order EDMS";
        OpenPage: Boolean;
    begin
        if OrderCount > 0 then begin
            //Message(Text003, Text002 + ' ' + Format(ServiceHeader."Document Type"), ServiceOrderNo)
            if GuiAllowed then
                if OfficeMgt.AttachAvailable then
                    OpenPage := true
                else
                    OpenPage := Confirm(StrSubstNo(OpenNewOrderQst, ServiceHeader."No."), true);
            if OpenPage then begin
                Clear(ServiceOrder);
                ServiceOrder.CheckNotificationsOnce;
                ServiceHeader.SetRecfilter;
                ServiceOrder.SetTableview(ServiceHeader);
                ServiceOrder.Run;
            end;
        end else
            Message(Text005);
    end;

    var
        CustomerNoBillTo: Code[20];
        StartingDate: Date;
        FinishingDate: Date;
        Customer: Record Customer;
        Text001: label 'Please, choose internal customer to bill';
        Text002: label 'Service';
        Text003: label '%1 %2 is created.';
        Text004: label 'Is not able to find %1 with %2.';
        Text005: label 'Nothing is created, check parameters';
        OpenNewOrderQst: Label 'Service order %1 has been created. Do you want to open the service order?';

        ServiceHeader: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        MakeSetup: Record "Make Setup";
        ServiceOrderNo: Code[20];
        ServicePackageVersion: Record "Service Package Version";
        OrderCount: Integer;

    local procedure InsertPDIPackege(AServicePackageVersion: Record "Service Package Version")
    begin
        if ServiceOrderNo = '' then
            CreateServHeader;
        ServiceHeader.InsertSPVersion(AServicePackageVersion);
    end;

    local procedure CreateServHeader()
    var
        VehicleOptionManagement: Codeunit VehicleOptionManagement;
    begin
        ServiceHeader.Init;
        VehicleOptionManagement.CreateServDocFromVehTrade(ServiceHeader, "Sales Line",
            StartingDate, FinishingDate,
            CustomerNoBillTo, CustomerNoBillTo);
        ServiceHeader.Validate("Vehicle Serial No.", "Sales Line"."Vehicle Serial No.");
        ServiceHeader.Modify;
        ServiceOrderNo := ServiceHeader."No.";
        OrderCount += 1;
    end;
}

