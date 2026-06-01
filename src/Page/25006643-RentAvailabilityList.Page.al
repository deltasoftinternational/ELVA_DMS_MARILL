Page 25006643 "Rent Availability List"
{
    PageType = List;
    SourceTable = "Rent Availability Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentItemTotalQty; Rec."Rent Item Total Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentAssetTotalQty; Rec."Rent Asset Total Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //StartingDate := DMY2DATE(1,9,2018);
        RentAvailabilityMgt.GetRentAssetAvailabilityEntries(Rec, StartingDate, EndingDate, RentAsset);
    end;

    var
        RentAvailabilityMgt: Codeunit "Rent Availability Mgt.";
        RentAsset: Record "Rent Asset";
        StartingDate: Date;
        EndingDate: Date;

    procedure SetParams(StartingDatePar: Date; EndingDatePar: Date; RentAssetPar: Record "Rent Asset")
    begin
        StartingDate := StartingDatePar;
        EndingDate := EndingDatePar;
        RentAsset.CopyFilters(RentAssetPar);
    end;
}

