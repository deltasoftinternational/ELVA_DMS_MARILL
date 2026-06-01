Table 25006214 "BLS Object"
{

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                if UpperCase(Code) = Text002 then
                    Error(Text003,
                      FieldCaption(Code));
            end;
        }
        field(100; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(110; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(120; "Object Category Code"; Code[20])
        {
            Caption = 'Object Category Code';
            NotBlank = true;
        }
        field(130; Location; Text[50])
        {
            Caption = 'Location';
        }
        field(200; "Object Type"; Option)
        {
            Caption = 'Object Type';
            OptionCaption = 'Standard,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Standard,Heading,Total,"Begin-Total","End-Total";

            trigger OnValidate()
            begin
                if xRec."Object Type" <> "Object Type" then
                    Totaling := '';
            end;
        }
        field(210; Totaling; Text[250])
        {
            Caption = 'Totaling';
            TableRelation = if ("Object Type" = const(Total)) "BLS Object".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if not ("Object Type" in ["object type"::Total, "object type"::"End-Total"]) and
                   (Totaling <> '')
                then
                    FieldError("Object Type");
            end;
        }
        field(220; Indentation; Integer)
        {
            Caption = 'Indentation';
        }
        field(300; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(310; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(320; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(330; City; Text[30])
        {
            Caption = 'City';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(340; County; Text[30])
        {
            Caption = 'County';
        }
        field(350; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(810; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                // ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(820; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                // ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
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
        if BLSMgt.ObjectIsInUse(Code) then
            Error(IsInUseErr, Code);

        DeleteDefaultValues;
    end;

    var
        PostCode: Record "Post Code";
        BLSMgt: Codeunit "BLS Management";
        Text000: label '%1\You cannot delete it.';
        Text002: label '(CONFLICT)';
        Text003: label '%1 can not be (CONFLICT). This name is used internally by the system.';
        Text004: label '%1\You cannot change the type.';
        Text005: label 'This dimension value has been used in posted or budget entries.';
        Text006: label 'You cannot change the value of %1.';
        IsInUseErr: label 'Object %1 is in use.';

    local procedure DeleteDefaultValues()
    begin
    end;
}

