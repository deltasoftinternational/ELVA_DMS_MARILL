Table 25006385 "Vehicle Opt. Jnl. Template"
{
    // 19.06.2004 EDMS P1
    //    *Created

    Caption = 'Vehicle Option Jnl. Template';
    LookupPageID = "Vehicle Opt. Jnl. Templ. List";

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; "Test Report ID"; Integer)
        {
            Caption = 'Test Report ID';
            //  TableRelation = Object.ID where(Type = const(Report));
            TableRelation = AllObjWithCaption."Object ID" where("object Type" = const(Report));
        }
        field(6; "Form ID"; Integer)
        {
            Caption = 'Form ID';
            //TableRelation = Object.ID; //where (Type=const(2));   //FIXME change functionality to page, fields in page commented
            TableRelation = AllObjWithCaption."Object ID";
            trigger OnValidate()
            begin
                "Form ID" := Page::"Vehicle Option Journal"
            end;
        }
        field(7; "Posting Report ID"; Integer)
        {
            Caption = 'Posting Report ID';
            //TableRelation = Object.ID where(Type = const(Report));
            TableRelation = AllObjWithCaption."Object ID" where("object Type" = const(Report));
        }
        field(8; "Force Posting Report"; Boolean)
        {
            Caption = 'Force Posting Report';
        }
        field(15; "Test Report Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Test Report ID")));
            Caption = 'Test Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Form Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object ID" = field("Form ID"))); //"Object Type"=const(2),
            Caption = 'Form Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Posting Report Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Posting Report ID")));
            Caption = 'Posting Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(20; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                    FieldError("Posting No. Series", StrSubstNo(Text001, "Posting No. Series"));
            end;
        }
        field(30; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        recVehOptJnlLine.SetRange("Journal Template Name", Name);
        recVehOptJnlLine.DeleteAll(true);
        recVehOptJnlBatch.SetRange("Journal Template Name", Name);
        recVehOptJnlBatch.DeleteAll;
    end;

    trigger OnInsert()
    begin
        Validate("Form ID");
    end;

    var
        Text001: label 'must not be %1';
        recVehOptJnlBatch: Record "Vehicle Opt. Jnl. Batch";
        recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
}

