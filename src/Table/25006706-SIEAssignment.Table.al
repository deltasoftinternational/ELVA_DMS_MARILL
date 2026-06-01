/*
Table 25006706 "SIE Assignment"
{
    Caption = 'SIE Assignment';
    DrillDownPageID = "SIE Assignment List";
    LookupPageID = "SIE Assignment List";

    fields
    {
        field(10;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(20;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(25;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Main,Detail';
            OptionMembers = Main,Detail;
        }
        field(30;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                //SIEItem.SETCURRENTKEY("Item No.");
                //SIEItem.SETRANGE("Item No.",Rec."Item No.");
                //SIEItem.FINDFIRST
            end;
        }
        field(40;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(50;"Qty. to Assign";Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Assign';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate()
            var
                SIELedgEntry: Record "SIE Ledger Entry";
                PossToAss: Decimal;
            begin
                if "Qty. to Assign" <> xRec."Qty. to Assign" then begin
                  SIELedgEntry.Get("Entry No.");
                  SIELedgEntry.CalcFields("Qty. to Assign","Qty. Assigned");
                  PossToAss := SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned";

                  if "Qty. to Assign" <= PossToAss then begin
                    if "Qty. to Assign" > PossToAss - (SIELedgEntry."Qty. to Assign" - xRec."Qty. to Assign") then
                      if not Confirm(Text001,false,FieldCaption("Qty. to Assign"),FieldCaption("Qty. Assigned")) then
                        Error(Text002)
                  end else Error(Text003,FieldCaption("Qty. to Assign"))
                end
            end;
        }
        field(60;"Qty. Assigned Det.";Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. Assigned Det.';
            DecimalPlaces = 0:5;
            Editable = true;
        }
        field(65;"Qty. Assigned";Decimal)
        {
            CalcFormula = sum("SIE Assignment"."Qty. Assigned Det." where (Type=const(Detail),
                                                                           "Appl. To Entry"=field("Entry No.")));
            Caption = 'Qty. Assigned';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';

            trigger OnValidate()
            begin
                //VALIDATE("Amount to Assign");
            end;
        }
        field(80;"Amount to Assign";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount to Assign';
        }
        field(85;"Applies-to Type";Integer)
        {
            Caption = 'Applies-to Type';
        }
        field(90;"Applies-to Doc. Type";Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = 'Quote,Order,Invoice';
            OptionMembers = Quote,"Order",Invoice;
        }
        field(100;"Applies-to Doc. No.";Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            TableRelation = "Service Header EDMS"."No." where ("Document Type"=field("Applies-to Doc. Type"));
        }
        field(110;"Applies-to Doc. Line No.";Integer)
        {
            Caption = 'Applies-to Doc. Line No.';
            TableRelation = "Service Line EDMS"."Line No." where ("Document No."=field("Applies-to Doc. No."),
                                                                  "Document Type"=field("Applies-to Doc. Type"));
        }
        field(120;"Applies-to Doc. Line Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Applies-to Doc. Line Amount';
        }
        field(130;Corrected;Boolean)
        {
            Caption = 'Corrected';
        }
        field(140;"Qty. to Transfer";Decimal)
        {
            Caption = 'Qty. to Transfer';
            Editable = false;
        }
        field(150;"Appl. To Entry";Integer)
        {
            Caption = 'Appl. To Entry';
        }
        field(160;"Appl. To Line No.";Integer)
        {
            Caption = 'Appl. To Line No.';
        }
        field(170;"Doc. Qty. Assigned";Decimal)
        {
            CalcFormula = sum("SIE Assignment"."Qty. Assigned Det." where (Type=const(Detail),
                                                                           "Appl. To Entry"=field("Entry No."),
                                                                           "Applies-to Doc. No."=field("Applies-to Doc. No."),
                                                                           "Applies-to Type"=field("Applies-to Type"),
                                                                           "Applies-to Doc. Type"=field("Applies-to Doc. Type")));
            Caption = 'Doc. Qty. Assigned';
            Editable = false;
            FieldClass = FlowField;
        }
        field(180;"Assignment Date";Date)
        {
            Caption = 'Assignment Date';
        }
        field(190;"Transaction Date";Date)
        {
            CalcFormula = max("SIE Ledger Entry"."Date 1" where ("Entry No."=field("Entry No.")));
            Caption = 'Transaction Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(200;"Transaction Time";Time)
        {
            CalcFormula = max("SIE Ledger Entry"."Time 1" where ("Entry No."=field("Entry No.")));
            Caption = 'Transaction Time';
            Editable = false;
            FieldClass = FlowField;
        }
        field(210;Resource;Text[50])
        {
            CalcFormula = max("SIE Ledger Entry"."Text50 1" where ("Entry No."=field("Entry No.")));
            Caption = 'Resource';
            Editable = false;
            FieldClass = FlowField;
        }
        field(220;Company;Integer)
        {
            CalcFormula = max("SIE Ledger Entry"."Int 6" where ("Entry No."=field("Entry No.")));
            Caption = 'Company';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Applies-to Type","Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.","Line No.",Type)
        {
            SumIndexFields = "Qty. to Assign","Qty. Assigned Det.","Amount to Assign";
        }
        key(Key3;"Applies-to Type","Applies-to Doc. Type","Applies-to Doc. No.","Line No.")
        {
        }
        key(Key4;"Appl. To Entry",Type)
        {
            SumIndexFields = "Qty. Assigned Det.";
        }
        key(Key5;"Applies-to Type","Applies-to Doc. Type","Applies-to Doc. No.","Appl. To Entry",Type)
        {
            SumIndexFields = "Qty. Assigned Det.";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CalcFields("Qty. Assigned");
        TestField("Qty. Assigned",0);
    end;

    var
        Text002: label 'Cancelled by user after warning';
        Text001: label '%1 is larger than %2. It is possible another user wants to assign this transaction. Anyway to assign?';
        Text003: label '%1 is bigger than assignable qty.';
}
*/