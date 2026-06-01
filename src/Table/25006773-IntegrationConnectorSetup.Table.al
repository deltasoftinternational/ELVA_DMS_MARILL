Table 25006773 "Integration Connector Setup"
{
    // #Owner EDMS.Integration

    Caption = 'Integration Connector Setup';
    LookupPageID = "Integration Connector Setup";

    fields
    {
        field(10; "Connector Code"; Code[20])
        {
            Caption = 'Connector Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Integration Connector EDMS";
        }
        field(20; "Method Code"; Code[20])
        {
            Caption = 'Method Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Integration Method EDMS";

            trigger OnValidate()
            begin
                if "Method Code" <> '' then begin
                    IntegrationMethod.Get("Method Code");
                    IntegrationMethod.TestField("Group Header", false);
                    "Method Description" := IntegrationMethod.Description;
                end;
            end;
        }
        field(100; "Method Description"; Text[100])
        {
            Caption = 'Method Description';
            DataClassification = ToBeClassified;
        }
        field(2000; "Dealer ID"; Code[20])
        {
            Caption = 'Dealer ID';
            DataClassification = ToBeClassified;
        }
        field(2010; "Vendor ID"; Code[20])
        {
            Caption = 'Vendor ID';
            DataClassification = ToBeClassified;
        }
        field(2020; "Make ID"; Code[20])
        {
            Caption = 'Make ID';
            DataClassification = ToBeClassified;
        }
        field(2030; "Customer ID"; Code[20])
        {
            Caption = 'Customer ID';
            DataClassification = ToBeClassified;
        }
        field(3000; "Request Handler Codeunit ID"; Integer)
        {
            Caption = 'Request Handler Codeunit ID';
            DataClassification = ToBeClassified;
            //TableRelation = Object.ID where (Type=const(Codeunit));
            TableRelation = AllObjWithCaption."Object ID" where("object Type" = const(Codeunit));
        }
        field(3010; "Request External Method Name"; Code[30])
        {
            Caption = 'Request External Method Name';
            DataClassification = ToBeClassified;
        }
        field(3100; "Response Handler Codeunit ID"; Integer)
        {
            Caption = 'Response Handler Codeunit ID';
            DataClassification = ToBeClassified;
            //TableRelation = Object.ID where(Type = const(Codeunit));
            TableRelation = AllObjWithCaption."Object ID" where("object Type" = const(Codeunit));
        }
        field(3110; "Response External Method Name"; Code[30])
        {
            Caption = 'Response External Method Name';
            DataClassification = ToBeClassified;
        }
        field(4000; "Single Instance"; Boolean)
        {
            Caption = 'Single Instance';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Connector Code", "Method Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        IntegrationMethod: Record "Integration Method EDMS";
}

