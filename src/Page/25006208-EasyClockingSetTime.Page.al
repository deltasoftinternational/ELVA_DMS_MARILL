Page 25006208 "Easy Clocking Set Time"
{
    Caption = 'Set Time';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            field(CustomDate; CustomDate)
            {
                ApplicationArea = Basic;
                Caption = 'Custom Date';
            }
            field(CustomTime; CustomTime)
            {
                ApplicationArea = Basic;
                Caption = 'Custom Time';
            }
        }
    }

    actions
    {
    }

    var
        CustomDate: Date;
        CustomTime: Time;


    procedure GetCustomDateTime(var CustomDateToGet: Date; var CustomTimeToGet: Time)
    begin
        CustomDateToGet := CustomDate;
        CustomTimeToGet := CustomTime;
    end;


    procedure SetCustomDateTime(CustomDateToSet: Date; CustomTimeToSet: Time)
    begin
        CustomDate := CustomDateToSet;
        CustomTime := CustomTimeToSet;
    end;
}

