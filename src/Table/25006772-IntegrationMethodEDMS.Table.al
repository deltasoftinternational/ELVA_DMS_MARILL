Table 25006772 "Integration Method EDMS"
{
    // #Owner EDMS.Integration

    Caption = 'Integration Connector Method';
    LookupPageID = "Integration Methods EDMS";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(100; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(110; "Is Active"; Boolean)
        {
            Caption = 'Is Active';
        }
        field(120; "Group Header"; Boolean)
        {
            Caption = 'Group Header';
            DataClassification = ToBeClassified;
        }
        field(200; Alias; Code[20])
        {
            Caption = 'Alias';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description, "Is Active", "Group Header")
        {
        }
    }


    procedure SuggestMethods(Subj: Option All,Item,Vehicle)
    begin
        if Subj in [Subj::All, Subj::Item] then begin
            AddMethod('I100', 'Item Information', true, '');
            AddMethod('I110', 'Get Item Price', false, 'ITEM_GET_PRICE');
            AddMethod('I120', 'Get Item Availability', false, 'ITEM_GET_AVAILABLE');

            AddMethod('I200', 'Inventory Information', true, '');

            AddMethod('I300', 'Item Purchase Docs', true, '');
            AddMethod('I310', 'Submit Item Purchase Order', false, 'PO_SUBMIT_ITEMS');

            AddMethod('I400', 'Item Sales Docs', true, '');
            AddMethod('I410', 'Submit Item Sales Order', false, 'SO_SUBMIT_ITEMS');
        end;

        if Subj in [Subj::All, Subj::Vehicle] then begin
            AddMethod('V100', 'Vehicle Information', true, '');

            AddMethod('V200', 'Vehicle Proposal', true, '');

            AddMethod('V300', 'Vehicle Purchase Docs', true, '');
            AddMethod('V310', 'Submit Vehicle Purchase Order', false, 'PO_SUBMIT_VEH');

            AddMethod('V400', 'Vehicle Sales Docs', true, '');
            AddMethod('V410', 'Submit Vehicle Sales Order', false, 'SO_SUBMIT_VEH');

            AddMethod('V500', 'Vehicle Maintenance', true, '');

            AddMethod('V600', 'Vehicle Warranty', true, '');

            AddMethod('V700', 'Vehicle Tracking', true, '');
        end;
    end;

    local procedure AddMethod(NewCode: Code[20]; NewDescription: Text[100]; NewIsGroup: Boolean; NewAlias: Code[20])
    var
        NewMethod: Record "Integration Method EDMS";
    begin
        if NewCode = '' then
            exit;

        if NewMethod.Get(NewCode) then
            exit;

        NewMethod.Init;
        NewMethod.Code := NewCode;
        NewMethod.Description := NewDescription;
        NewMethod."Group Header" := NewIsGroup;
        if not NewMethod."Group Header" then
            NewMethod.Alias := NewAlias;
        NewMethod.Insert;
    end;


    procedure ActivateMethods(var Method: Record "Integration Method EDMS")
    begin
        Method.SetRange("Group Header", false);
        Method.ModifyAll("Is Active", true);
    end;


    procedure DeactivateMethods(var Method: Record "Integration Method EDMS")
    begin
        Method.ModifyAll("Is Active", false);
    end;
}

