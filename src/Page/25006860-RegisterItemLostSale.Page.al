Page 25006860 "Register Item Lost Sale"
{
    Caption = 'Register Item Lost Sale';
    PageType = Card;
    Permissions = TableData "Lost Sales Entry" = rimd;

    layout
    {
        area(content)
        {
            field(Date; Date)
            {
                ApplicationArea = Basic;
                Caption = 'Date';
            }
            field(CustomerNo; CustomerNo)
            {
                ApplicationArea = Basic;
                Caption = 'Customer No.';
                TableRelation = Customer;
            }
            field(ItemNo; ItemNo)
            {
                ApplicationArea = Basic;
                Caption = 'Item No.';
                TableRelation = Item;
            }
            field(Desc; Desc)
            {
                ApplicationArea = Basic;
                Caption = 'Description';
            }
            field(Desc2; Desc2)
            {
                ApplicationArea = Basic;
                Caption = 'Description 2';
            }
            field(ReasonCode; ReasonCode)
            {
                ApplicationArea = Basic;
                Caption = 'Reason Code';
                TableRelation = "Lost Sales Reason";
            }
            field(Importance; Importance)
            {
                ApplicationArea = Basic;
                Caption = 'Priority';
                OptionCaption = ' ,Highest,High,Mediun,Low,Lowest';
            }
            field(LocationCode; LocationCode)
            {
                ApplicationArea = Basic;
                Caption = 'Location Code';
                TableRelation = "Location";
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Date := WorkDate;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            YesOnPush;
    end;

    var
        CustomerNo: Code[20];
        Date: Date;
        ItemNo: Code[20];
        Desc: Text[30];
        Desc2: Text[30];
        ReasonCode: Code[20];
        ReasonDesc: Text[30];
        LostSalesMgt: Codeunit "Lost Sales Management";
        Importance: Option ,Highest,High,Mediun,Low,Lowest;

        LocationCode: Code[20];


    procedure SetItem(PItemNo: Code[20])
    begin
        ItemNo := PItemNo;
    end;


    procedure SetCustomer(CustomerNo1: Code[20])
    begin
        CustomerNo := CustomerNo1;
    end;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;

    local procedure YesOnPush()
    begin
        LostSalesMgt.CreateEntry_Item(Date, ItemNo, CustomerNo, Desc, Desc2, ReasonCode, Importance, false, LocationCode);
    end;
}

