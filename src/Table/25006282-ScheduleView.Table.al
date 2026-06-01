Table 25006282 "Schedule View"
{
    // 16.05.2013 EDMS P8
    //   * Added field "Time Grid Item Code"

    Caption = 'Schedule View';
    LookupPageID = "Schedule Views";

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Show as Lines"; Text[30])
        {
            Caption = 'Show as Lines';
            Description = 'Classic Client';

            trigger OnLookup()
            var
                NewCode: Text[30];
            begin
                NewCode := GetDimSelection("Show as Lines");
                if NewCode <> "Show as Lines" then
                    "Show as Lines" := NewCode;
            end;
        }
        field(40; "Lines Parameter"; Code[10])
        {
            Caption = 'Lines Parameter';
            Description = 'Classic Client';

            trigger OnLookup()
            begin
                case "Show as Lines" of
                    Text010:
                        Validate("Lines Parameter", GetResGrpSelection("Lines Parameter"));
                    Text011:
                        Validate("Lines Parameter", GetTimeGridSelection("Lines Parameter"));
                end;
            end;
        }
        field(50; "Show as Columns"; Text[30])
        {
            Caption = 'Show as Columns';
            Description = 'Classic Client';
            TableRelation = "Dimension Selection Buffer";

            trigger OnLookup()
            var
                NewCode: Text[30];
            begin
                NewCode := GetDimSelection("Show as Columns");
                if NewCode <> "Show as Columns" then
                    "Show as Columns" := NewCode;
            end;
        }
        field(60; "Columns Parameter"; Code[10])
        {
            Caption = 'Columns Parameter';
            Description = 'Classic Client';

            trigger OnLookup()
            begin
                case "Show as Columns" of
                    Text010:
                        Validate("Columns Parameter", GetResGrpSelection("Columns Parameter"));
                    Text011:
                        Validate("Columns Parameter", GetTimeGridSelection("Columns Parameter"));
                end;
            end;
        }
        field(80; "Group by"; Option)
        {
            Caption = 'Group by';
            OptionCaption = ' ,Workplace,Skill,Shift';
            OptionMembers = " ",Workplace,Skill,Shift;
        }
        field(200; "Resource Group"; Code[10])
        {
            Caption = 'Resource Group';
            TableRelation = "Schedule Resource Group";
        }
        field(210; "Period Type"; Option)
        {
            Caption = 'Period Type';
            OptionCaption = 'Custom,Day,Week,Month';
            OptionMembers = Custom,Day,Week,Month;
        }
        field(300; "Start Date Formula"; DateFormula)
        {
            Caption = 'Start Date Formula';
        }
        field(400; "Start Time"; Time)
        {
            Caption = 'Start Time';
            Description = 'RTC only';
        }
        field(410; "End Time"; Time)
        {
            Caption = 'End Time';
            Description = 'RTC only';
        }
        field(420; "Time Grid Code"; Code[20])
        {
            Caption = 'Time Grid Code';
            Description = 'RTC only';
            TableRelation = "Time Grid";
        }
        field(430; "Hide Time Reg Entries"; Boolean)
        {
            Caption = 'Hide Time Reg Entries';
            Description = 'Hide Time Reg Entries';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: label 'Day Period';
        Text010: label 'Resource';
        Text011: label 'Time Period';

    local procedure GetDimSelection(OldDimGrpCode: Text[30]): Text[30]
    var
        DimSelection: Page "Dimension Selection";
    begin

        DimSelection.InsertDimSelBuf(false, Text010, Text010);
        DimSelection.InsertDimSelBuf(false, Text000, Text000);
        DimSelection.InsertDimSelBuf(false, Text011, Text011);

        DimSelection.LookupMode := true;
        if DimSelection.RunModal = Action::LookupOK then
            exit(DimSelection.GetDimSelCode)
        else
            exit(OldDimGrpCode);
    end;

    local procedure GetResGrpSelection(OldDimSelCode: Text[30]): Text[30]
    var
        ResourceGroup: Record "Schedule Resource Group";
        ResourceGroups: Page "Resource Groups";
    begin
        ResourceGroups.LookupMode := true;
        if ResourceGroups.RunModal = Action::LookupOK then begin
            ResourceGroups.GetRecord(ResourceGroup);
            exit(ResourceGroup.Code)
        end
        else
            exit(OldDimSelCode);
    end;

    local procedure GetTimeGridSelection(OldDimSelCode: Text[30]): Text[30]
    var
        TimeViews: Page "Time Grids";
        TimeView: Record "Time Grid";
    begin
        TimeViews.LookupMode := true;
        if TimeViews.RunModal = Action::LookupOK then begin
            TimeViews.GetRecord(TimeView);
            exit(TimeView.Code)
        end
        else
            exit(OldDimSelCode);
    end;
}

