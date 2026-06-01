Table 25006001 "Model"
{
    // 14.05.2014 Elva Baltic P21 #S0106 MMG7.00
    //   Added key:
    //     Commercial Name
    // 
    // 03.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Added FieldGroup DropDown
    // 
    // 10.05.2008. EDMS P2
    //   * Added code OnDelete

    Caption = 'Model';
    LookupPageID = "Model List";

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(20; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(30; "Commercial Name"; Text[50])
        {
            Caption = 'Commercial Name';
        }
        field(100; "View Sequence"; Integer)
        {
            Caption = 'View Sequence';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Code")
        {
            Clustered = true;
        }
        key(Key2; "View Sequence")
        {
        }
        key(Key3; "Commercial Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Make Code", "Code", "Commercial Name")
        {
        }
    }

    trigger OnInsert()
    begin
        TestField("Make Code");
        TestField(Code);
    end;

    trigger OnDelete()
    var
        Item: Record Item;
        ServiceLedger: Record "Service Ledger Entry EDMS";
    begin
        Item.Reset;
        Item.SetCurrentkey("Item Type", "Make Code", "Model Code");
        Item.SetRange("Item Type", Item."item type"::"Model Version");
        Item.SetRange("Make Code", "Make Code");
        Item.SetRange("Model Code", Code);
        if Item.FindFirst then
            Error(Text001, TableCaption, Code, Item.TableCaption);

        ServiceLedger.Reset;
        ServiceLedger.SetCurrentkey("Make Code", "Model Code", "Model Version No.", "Posting Date");
        ServiceLedger.SetRange("Make Code", "Make Code");
        ServiceLedger.SetRange("Model Code", Code);
        if ServiceLedger.FindFirst then
            Error(Text001, TableCaption, Code, ServiceLedger.TableCaption);
    end;

    var
        Text001: label 'You cannot delete %1 %2 because there is at least one %3 that includes this model.';
}

