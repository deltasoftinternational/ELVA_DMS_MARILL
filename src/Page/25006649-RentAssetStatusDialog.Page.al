Page 25006649 "Rent Asset Status Dialog"
{
    Caption = 'Rent Asset Status Dialog';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(Status; Status)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Asset Status';
                OptionCaption = ' ,Available,Reserved,Rented,Received,Service Planned,Service,Other,Disposed';
            }
        }
    }

    actions
    {
    }

    var
        Status: Option " ",Available,Reserved,Rented,Received,"Service Planned",Service,Other,Disposed;


    procedure SetParam(StatusParam: Option)
    begin
        Status := StatusParam;
    end;


    procedure GetParam(var StatusParam: Option)
    begin
        StatusParam := Status;
    end;
}

