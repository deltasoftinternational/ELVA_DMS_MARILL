Page 25006266 "PDI create from Assem. Confirm"
{
    Caption = 'PDI create from Assem. Confirm';
    PageType = Card;
    SourceTable = "Service Header EDMS";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field(ServiceHeaderTmpDocumentType; ServiceHeaderTmp."Document Type")
            {
                ApplicationArea = Basic;
            }
            field(ServiceHeaderTmpNo; ServiceHeaderTmp."No.")
            {
                ApplicationArea = Basic;
            }
            field(BilllToCustomer; BilllToCustomer)
            {
                ApplicationArea = Basic;
                Caption = 'Billl-to Customer No.';
                TableRelation = Customer where(Internal = const(true));
            }
            field(OrderDate; OrderDate)
            {
                ApplicationArea = Basic;
                Caption = 'Order Date';
            }
            field(PlannedDate; PlannedDate)
            {
                ApplicationArea = Basic;
                Caption = 'Planned Service Date';
            }
            field(AssemblyTotalAmount; AssemblyTotalAmount)
            {
                ApplicationArea = Basic;
                Caption = 'Assembly total amount';
                Enabled = false;
            }
            field(Assemblylinescount; VehicleAssembly.Count)
            {
                ApplicationArea = Basic;
                Caption = 'Assembly lines count';
                Enabled = false;
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        ServiceHeaderTmp."Bill-to Customer No." := BilllToCustomer;
        ServiceHeaderTmp."Planned Service Date" := PlannedDate;
        ServiceHeaderTmp."Order Date" := OrderDate;
    end;

    trigger OnOpenPage()
    begin
        AssemblyTotalAmount := 0;
        VehicleAssembly.FindFirst;
        repeat
            AssemblyTotalAmount += VehicleAssembly.Amount;
        until VehicleAssembly.Next = 0;
        BilllToCustomer := ServiceHeaderTmp."Bill-to Customer No.";
        PlannedDate := ServiceHeaderTmp."Planned Service Date";
        OrderDate := ServiceHeaderTmp."Order Date";
    end;

    var
        AssemblyTotalAmount: Decimal;
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        VehicleAssembly: Record "Vehicle Assembly Line";
        BilllToCustomer: Code[20];
        OrderDate: Date;
        PlannedDate: Date;


    procedure SetVehicleAssembly(var VehicleAssemblyPar: Record "Vehicle Assembly Line")
    begin
        VehicleAssembly := VehicleAssemblyPar;
        VehicleAssembly.CopyFilters(VehicleAssemblyPar);
    end;


    procedure SetServiceHeaderTmp(var ServiceHeaderPar: Record "Service Header EDMS" temporary)
    begin
        ServiceHeaderTmp := ServiceHeaderPar;
    end;


    procedure GetServiceHeaderTmp(var ServiceHeaderPar: Record "Service Header EDMS" temporary)
    begin
        ServiceHeaderPar := ServiceHeaderTmp;
    end;
}

