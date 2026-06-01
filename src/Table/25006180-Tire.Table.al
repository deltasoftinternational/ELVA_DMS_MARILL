Table 25006180 "Tire"
{
    Caption = 'Tire';
    DrillDownPageID = Tires;
    LookupPageID = Tires;

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';

            trigger OnValidate()
            begin
                if Code <> xRec.Code then begin
                    GetTireSetup;
                    NoSeriesMgt.TestManual(TireMgtSetup."Tire Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; "Variable Field Tire Run"; Decimal)
        {
            CalcFormula = sum("Tire Entry"."Variable Field Tire Run" where("Tire Code" = field(Code)));
            CaptionClass = '7,25006180,30';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; Available; Boolean)
        {
            CalcFormula = - exist("Tire Entry" where("Tire Code" = field(Code),
                                                     Open = const(true)));
            Caption = 'Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Current Vehicle Serial No."; Code[20])
        {
            CalcFormula = lookup("Tire Entry"."Vehicle Serial No." where("Tire Code" = field(Code),
                                                                          Open = const(true)));
            Caption = 'Current Vehicle Serial No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "No. Series"; Code[20])
        {
        }
        field(80; "Current Vehicle Axle Code"; Code[10])
        {
            CalcFormula = lookup("Tire Entry"."Vehicle Axle Code" where("Tire Code" = field(Code),
                                                                         Open = const(true)));
            Caption = 'Current Vehicle Axle Code';
            FieldClass = FlowField;
        }
        field(90; "Current Vehicle Tire Position"; Code[10])
        {
            CalcFormula = lookup("Tire Entry"."Tire Position Code" where("Tire Code" = field(Code),
                                                                          Open = const(true)));
            Caption = 'Current Vehicle Tire Position';
            FieldClass = FlowField;
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
    begin
        TireEntry.Reset;
        TireEntry.SetRange("Tire Code", Code);
        if TireEntry.FindFirst then
            Error(Text001, Rec.TableCaption, Code, TireEntry.TableCaption);
    end;

    trigger OnInsert()
    begin
        if Code = '' then begin
            GetTireSetup;
            TireMgtSetup.TestField("Tire Nos.");
            "No. Series" := TireMgtSetup."Tire Nos.";
            Code := NoSeriesMgt.GetNextNo("No. Series", 0D, true);
        end;
    end;

    var
        TireEntry: Record "Tire Entry";
        Text001: label 'You cannot delete %1 %2 because there are one or records in %3.';
        TireMgtSetup: Record "Tire Management Setup";
        HasTireSetup: Boolean;
        NoSeriesMgt: Codeunit "No. Series";

    local procedure GetTireSetup()
    begin
        if not HasTireSetup then begin
            TireMgtSetup.Get;
            HasTireSetup := true;
        end;
    end;

    procedure AssistEdit(): Boolean
    begin
        GetTireSetup;
        TireMgtSetup.TestField("Tire Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(TireMgtSetup."Tire Nos.", xRec."No. Series", "No. Series") then begin
            Code := NoSeriesMgt.GetNextNo("No. Series", WorkDate(), true);
            exit(true);
        end;
    end;
}

