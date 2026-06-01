Page 25006443 "Rent Billing Special Charge"
{
    ApplicationArea = Basic;
    Caption = 'Create Special Charge Line';
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Rent Billing Worksheet Line";
    SourceTableTemporary = true;
    UsageCategory = Tasks;
    Editable = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            field(RentOrderNo; Rec."Document No.")
            {
                ApplicationArea = Basic;
                Caption = 'Rent Order No.';

            }
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
            }
            field(No; Rec."No.")
            {
                ApplicationArea = Basic;

                trigger OnValidate()
                begin
                    //ShowShortcutDimCode(ShortcutDimCode);
                end;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = Basic;

            }
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = Basic;

            }
            field(UnitPrice; Rec."Unit Price")
            {
                ApplicationArea = Basic;

            }

            field("Unit of Measure Code"; Rec."Unit of Measure Code")
            {
                ApplicationArea = Basic;

            }
        }
    }
    actions
    {
    }
    var
        BLSCreateInv: Report "BLS Create Invoices";
        InvCnt: Integer;
        SalesHeader: Record "Sales Header";
        NewInvoiceMsg: label 'Created %1 invoice(-s). Do You want open invoice list?';
        BLSCreateInvLease: Report "BLS Create Invoices Lease";
        StatusStyleExpression: Text[30];
        ShortcutDimCode: array[8] of Code[20];
        IsVFRun1Visible: Boolean;
        IsVFRun2Visible: Boolean;
        IsVFRun3Visible: Boolean;
        IsVFRun4Visible: Boolean;
        IsVFRun5Visible: Boolean;
        IsVFRun6Visible: Boolean;
        RowEditable: Boolean;

        DefaultDocumentType: Integer;
        DefaultDocumentNo: Code[20];





    procedure SetDefaults(var WkshLineToSet: Record "Rent Billing Worksheet Line")
    begin
        Rec.init();
        Rec := WkshLineToSet;
        Rec.Insert();
    end;

}

