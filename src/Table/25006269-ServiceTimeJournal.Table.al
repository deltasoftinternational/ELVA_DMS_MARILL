Table 25006269 "Service Time Journal"
{
    Caption = 'Service Time Journal';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(15; "User ID"; Code[50])
        {
            Caption = 'User ID';
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit UserProfileManagement;
            begin
                UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit UserProfileManagement;
            begin
                UserMgt.ValidateUserID("User ID");
            end;
        }
        field(20; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Service Document,Standard Event';
            OptionMembers = ,"Service Document","Standard Event";
        }
        field(30; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(40; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
            TableRelation = if ("Source Type" = const("Service Document")) "Service Header EDMS"."No." where("Document Type" = field("Source Subtype"))
            else
            if ("Source Type" = const("Standard Event")) "Serv. Standard Event".Code;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(50; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
            TableRelation = "Service Line EDMS"."Line No." where("Document Type" = field("Source Subtype"),
                                                                  "Document No." = field("Source ID"),
                                                                  "Type" = filter(Labor));
        }
        field(60; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(70; "Start Time"; Time)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'Start Time';

            trigger OnValidate()
            begin
                if ("End Time" <> 0T) and ("Start Time" <> 0T) then
                    "Quantity (Hours)" := ("End Time" - "Start Time") / (1000 * 60 * 60);
            end;
        }
        field(80; "End Time"; Time)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'End Time';

            trigger OnValidate()
            begin
                if ("End Time" <> 0T) and ("Start Time" <> 0T) then
                    "Quantity (Hours)" := ("End Time" - "Start Time") / (1000 * 60 * 60);
            end;
        }
        field(90; "Quantity (Hours)"; Decimal)
        {
            Caption = 'Quantity (Hours)';
            DecimalPlaces = 0 : 5;
        }
        field(100; Travel; Boolean)
        {
            Caption = 'Travel';
        }
        field(110; Date; Date)
        {
            Caption = 'Date';
        }
    }

    keys
    {
        key(Key1; "User ID", "Source Type", "Source Subtype", "Source ID", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

