Page 25006092 "Service Doc Info FactBox"
{
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Remove field:
    //     "Contract No."
    //   Modified function:
    //     GetActiveContractQty
    //   Modified triggers:
    //     ActiveContractQty - OnDrillDown()
    //     SuspendedContractQty - OnDrillDown()

    Caption = 'Service Doc Info';
    PageType = CardPart;
    SourceTable = "Service Header EDMS";

    layout
    {
        area(content)
        {
            group(Contracts)
            {
                Caption = 'Contracts';
                field(ActiveContractQty; GetActiveContractQty(Contractstatuspar::Active, false, Documentprofile::Service))
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Contracts';

                    trigger OnDrillDown()
                    begin
                        if Rec."Bill-to Customer No." <> '' then
                            Customer.Get(Rec."Bill-to Customer No.");

                        Customer.ShowActiveContracts(Contractstatuspar::Active, false, Documentprofile::Service, Rec."Order Date", Rec."Vehicle Serial No.");         //Suspend = FALSE
                    end;
                }
                field(SuspendedContractQty; GetActiveContractQty(Contractstatuspar::Active, true, Documentprofile::Service))
                {
                    ApplicationArea = Basic;
                    Caption = 'Suspended Contracts';

                    trigger OnDrillDown()
                    begin
                        if Rec."Bill-to Customer No." <> '' then
                            Customer.Get(Rec."Bill-to Customer No.");

                        Customer.ShowActiveContracts(Contractstatuspar::Active, true, Documentprofile::Service, Rec."Order Date", Rec."Vehicle Serial No.");          //Suspend = TRUE
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        Text000: label 'Overdue Amounts (LCY) as of %1';
        Customer: Record Customer;
        Contract: Record Contract;
        ContractList: Page "Contract List EDMS";
        ContractStatusPar: Option Inactive,Active;
        DocumentProfile: Option " ","Spare Parts Trade",,Service;
        ContractVehicle: Record "Contract Vehicle";


    procedure ShowDetails()
    begin
        Page.Run(Page::"Customer Card", Rec);
    end;


    procedure GetActiveContractQty(StatusPar: Option Inactive,Active; SuspendedPar: Boolean; DocProfile: Option " ","Spare Parts Trade",,Service) RetVal: Integer
    begin
        if Rec."Bill-to Customer No." <> '' then
            Customer.Get(Rec."Bill-to Customer No.");
        exit(Customer.GetActiveContractQty(StatusPar, SuspendedPar, DocProfile, Rec."Order Date", Rec."Vehicle Serial No."));
    end;
}

