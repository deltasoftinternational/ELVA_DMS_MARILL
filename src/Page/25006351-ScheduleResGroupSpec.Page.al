Page 25006351 "Schedule Res. Group Spec."
{
    Caption = 'Schedule Res. Group Specification';
    DataCaptionFields = "Group Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Schedule Resource Group Spec.";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(GroupCode; Rec."Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the resource group to which this specification is defined.';
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resource to include in the schedule resource group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a name of the resource.';
                }
                //field(Current;Current)
                //{
                //    ApplicationArea = Basic;
                //}
            }
        }
    }

    actions
    {
    }
}

