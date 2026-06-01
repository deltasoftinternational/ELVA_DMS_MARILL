Page 25006566 "Allocation Prompt"
{
    // 
    // 04.06.2018 EB.RC POD P349 POD1.39
    //   ?
    // 
    // 13.04.2018 EB.RC POD P439 POD1.34
    //   Created

    Caption = 'New Allocation';

    layout
    {
        area(content)
        {
            group(Control50001)
            {
                field(OrderNo; OrderNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order No.';
                    Editable = false;
                }
                field(AllocationDate; AllocationDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Allocation Date';
                }
                field(AllocationTime; AllocationTime)
                {
                    ApplicationArea = Basic;
                    Caption = 'Allocation Time';
                }
                field(Duration; Duration)
                {
                    ApplicationArea = Basic;
                    Caption = 'Duration';
                }
            }
        }
    }

    actions
    {
    }

    var
        AllocationDate: Date;
        AllocationTime: Time;
        Duration: Decimal;
        OrderNo: Code[20];


    procedure SetAllocationDate(AllocationDateToSet: Date)
    begin
        AllocationDate := AllocationDateToSet;
    end;


    procedure SetAllocationTime(AllocationTimeToSet: Time)
    begin
        AllocationTime := AllocationTimeToSet;
    end;


    procedure SetAllocationDuration(AllocationDurationToSet: Decimal)
    begin
        Duration := AllocationDurationToSet;
    end;


    procedure SetOrderNo(OrderNoToSet: Code[20])
    begin
        OrderNo := OrderNoToSet;
    end;


    procedure GetAllocationDate(): Date
    begin
        exit(AllocationDate);
    end;


    procedure GetAllocationTime(): Time
    begin
        exit(AllocationTime);
    end;


    procedure GetAllocationDuration(): Decimal
    begin
        exit(Duration);
    end;
}

