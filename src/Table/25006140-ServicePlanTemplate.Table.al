Table 25006140 "Service Plan Template"
{
    Caption = 'Service Plan Template';
    LookupPageID = "Service Plan Templates";

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
        field(50; "Service Plan Type"; Code[10])
        {
            Caption = 'Service Plan Type';
            TableRelation = "Service Plan Type";
        }
        field(190; Adjust; Boolean)
        {
            Caption = 'Replan At Service Post';
        }
        field(200; Recurring; Boolean)
        {
            Caption = 'Recurring';
            Description = 'Auto Assign Tewplate';
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
        ServPlanTemplateStage: Record "Service Plan Template Stage";
        ServPlanTemplateUsage: Record "Service Plan Template Usage";
        ServPlanComment: Record "Service Plan Comment Line";
    begin
        ServPlanTemplateStage.Reset;
        ServPlanTemplateStage.SetRange("Template Code", Code);
        ServPlanTemplateStage.DeleteAll(true);
        /*
        ServPlanTemplateUsage.RESET;
        ServPlanTemplateUsage.SETRANGE("Template Code", Code);
        ServPlanTemplateUsage.DELETEALL;
        
        ServPlanComment.RESET;
        ServPlanComment.SETRANGE(Type, ServPlanComment.Type::"Plan Template");
        ServPlanComment.SETRANGE("Plan No.", Code);
        ServPlanComment.DELETEALL;
        */

    end;
}

