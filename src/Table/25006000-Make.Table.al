Table 25006000 "Make"
{
    // 25.02.2015 EDMS P21
    //   Added field:
    //     30 Picture
    // 
    // 10.05.2008. EDMS P2
    //   * Added code OnDelete
    // 
    // 13.08.2007. EDMS P2
    //   * Added field "Veh. Evaluation View Code"
    // 
    // 08.11.2004 EDMS P1
    //   *Changed property DrillDownForm

    Caption = 'Make';
    DrillDownPageID = "Make List";
    LookupPageID = "Make List";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(30; Picture; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(40; Icon; Blob)
        {
            SubType = Bitmap;
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

    trigger OnDelete()
    var
        ServiceLedger: Record "Service Ledger Entry EDMS";
        Model: Record Model;
        MakeSetup: Record "Make Setup";
    begin
        Model.Reset;
        Model.SetRange("Make Code", Code);
        if Model.FindFirst then
            Error(Text001, TableCaption, Code, Model.TableCaption);

        ServiceLedger.Reset;
        ServiceLedger.SetCurrentkey("Make Code", "Model Code", "Model Version No.", "Posting Date");
        ServiceLedger.SetRange("Make Code", Code);
        if ServiceLedger.FindFirst then
            Error(Text001, TableCaption, Code, ServiceLedger.TableCaption);

        if MakeSetup.Get(Code) then
            MakeSetup.Delete;
    end;

    trigger OnInsert()
    var
        MakeSetup: Record "Make Setup";
    begin
        MakeSetup.Init;
        MakeSetup."Make Code" := Code;
        MakeSetup.Insert;
        TestField(Code);
    end;

    var
        Text001: label 'You cannot delete %1 %2 because there is at least one %3 that includes this make.';
}

