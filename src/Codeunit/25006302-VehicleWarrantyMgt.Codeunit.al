Codeunit 25006302 "Vehicle Warranty Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure CreateWarrantyLines(var SalesLine: Record "Sales Line")
    var
        WarrantyUsage: Record "Vehicle Warranty Usage";
        VehicleWarranty: Record "Vehicle Warranty";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
    begin
        SalesSetup.Reset;

        WarrantyUsage.Reset;

        SalesSetup.Get;
        if not SalesSetup."Vehicle Warranty on Sales" then
            exit;

        VehicleWarranty.Reset;
        VehicleWarranty.SetRange("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
        if VehicleWarranty.FindFirst then
            exit;

        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");

        WarrantyUsage.Reset;
        WarrantyUsage.SetFilter("Make Code", '%1|%2', '', SalesLine."Make Code");
        WarrantyUsage.SetFilter("Model Code", '%1|%2', '', SalesLine."Model Code");
        WarrantyUsage.SetFilter("Model Version No.", '%1|%2', '', SalesLine."Model Version No.");
        WarrantyUsage.SetFilter("Vehicle Status Code", '%1|%2', '', SalesLine."Vehicle Status Code");

        OnSelectWarrantyUsage(WarrantyUsage, SalesLine);
        if WarrantyUsage.FindSet then
            repeat
                VehicleWarranty.Init;
                VehicleWarranty."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
                VehicleWarranty."No." := '';
                VehicleWarranty.Insert(true);
                VehicleWarranty."Warranty Type Code" := WarrantyUsage."Warranty Type Code";
                if SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Invoice then
                    VehicleWarranty."Starting Date" := SalesHeader."Document Date";
                if SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Shipment then
                    VehicleWarranty."Starting Date" := SalesHeader."Shipment Date";
                VehicleWarranty.Validate("Term Date Formula", WarrantyUsage."Term Date Formula");
                VehicleWarranty."Variable Field Run 1" := WarrantyUsage."Variable Field Run 1";
                VehicleWarranty.Modify;
            until WarrantyUsage.Next = 0;
    end;


    [IntegrationEvent(false, false)]
    procedure OnSelectWarrantyUsage(var WarrantyUsage: Record "Vehicle Warranty Usage"; SalesLine: Record "Sales Line")
    begin
    end;
}

