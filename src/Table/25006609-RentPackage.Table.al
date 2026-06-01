Table 25006609 "Rent Package"
{
    Caption = 'Rent Package';
    DrillDownPageID = "Rent Package List";
    LookupPageID = "Rent Package List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(60; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            RentSetup.Get;
            RentSetup.TestField("Rent Package Nos.");
            "No. Series" := RentSetup."Rent Package Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series", 0D, true);
        end;
    end;

    var
        RentSetup: Record "Rent Mgt. Setup";
        RentPackage: Record "Rent Package";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;


    procedure AssistEdit(OldRentPackage: Record "Rent Package"): Boolean
    begin
        RentPackage := Rec;
        RentSetup.Get;
        RentSetup.TestField("Rent Package Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(RentSetup."Rent Package Nos.", OldRentPackage."No. Series", RentPackage."No. Series") then begin
            RentSetup.Get();
            RentSetup.TestField("Rent Package Nos.");
            RentPackage."No." := NoSeriesMgt.GetNextNo(RentPackage."No. Series", WorkDate(), true);
            Rec := RentPackage;
            exit(true);
        end;
    end;
}

