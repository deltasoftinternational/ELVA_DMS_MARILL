Table 25006204 "Warranty Journal Template"
{
    // * Check Recurring - On Validate
    // Functionality is commented cause isn't needed

    Caption = 'Warranty Journal Template';
    DrillDownPageID = "Warranty Journal Template List";
    LookupPageID = "Warranty Journal Template List";

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
            // TableRelation = Object.ID where(Type = const(Report));
            TableRelation = AllObjWithCaption."Object ID" where("object Type" = const(Report));
        }
        field(6; "Form ID"; Integer)
        {
            Caption = 'Form ID';
            //TableRelation = Object.ID; // where (Type=const(2));   //FIXME change functionality to page, fields in page commented
            TableRelation = AllObjWithCaption."Object ID";
            trigger OnValidate()
            begin
                if "Form ID" = 0 then
                    Validate(Recurring);
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
        field(10; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";

            trigger OnValidate()
            begin
                WarrantyJnlLine.SetRange("Journal Template Name", Name);
                WarrantyJnlLine.ModifyAll("Source Code", "Source Code");
                Modify;
            end;
        }
        field(11; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(12; Recurring; Boolean)
        {
            Caption = 'Recurring';

            trigger OnValidate()
            begin
                if Recurring then
                    //"Form ID" := PAGE::"Recurring Resource Jnl."
                    "Form ID" := Page::"Warranty Journal"
                else
                    "Form ID" := Page::"Warranty Journal";
                SourceCodeSetup.Get;
                "Source Code" := SourceCodeSetup."Service Management EDMS";
                if Recurring then
                    TestField("No. Series", '');
            end;
        }
        field(13; "Test Report Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Test Report ID")));
            Caption = 'Test Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Form Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object ID" = field("Form ID"))); //"Object Type"=const(2),                                                                           
            Caption = 'Form Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Posting Report Name"; Text[249])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Report),
                                                                           "Object ID" = field("Posting Report ID")));
            Caption = 'Posting Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                    if Recurring then
                        Error(
                          Text000,
                          FieldCaption("Posting No. Series"));
                    if "No. Series" = "Posting No. Series" then
                        "Posting No. Series" := '';
                end;
            end;
        }
        field(17; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                    FieldError("Posting No. Series", StrSubstNo(Text001, "Posting No. Series"));
            end;
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
        WarrantyJnlLine.SetRange("Journal Template Name", Name);
        WarrantyJnlLine.DeleteAll(true);
        WarrantyJnlBatch.SetRange("Journal Template Name", Name);
        WarrantyJnlBatch.DeleteAll;
    end;

    trigger OnInsert()
    begin
        Validate("Form ID");
    end;

    var
        Text000: label 'Only the %1 field can be filled in on recurring journals.';
        Text001: label 'must not be %1';
        WarrantyJnlBatch: Record "Warranty Journal Batch";
        WarrantyJnlLine: Record "Warranty Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
}

