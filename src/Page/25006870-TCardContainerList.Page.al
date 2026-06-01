Page 25006870 "TCard Container List"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "TCard Container";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if ((Rec.Subtype = Rec.Subtype::"In Progress") or (Rec.Subtype = Rec.Subtype::Finished)) and (Rec.Type <> Rec.Type::Order) then
                            Error(TypeAndSubtypeErr);
                    end;
                }
                field(Subtype; Rec.Subtype)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if (Rec.Subtype <> Rec.Subtype::"In Progress") and ((Rec."Resource No." <> '') or (Rec."Service Advisor" <> '')) then
                            Error(SubtypeServResErr);

                        if ((Rec.Subtype = Rec.Subtype::"In Progress") or (Rec.Subtype = Rec.Subtype::Finished)) and (Rec.Type <> Rec.Type::Order) then
                            Error(TypeAndSubtypeErr);
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = Basic;
                }
                field(ContainerSize; Rec."Container Size")
                {
                    ApplicationArea = Basic;
                }
                field(ConfiguredSize; Rec."Configured Size")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ContainerColor; Rec."Container Color")
                {
                    ApplicationArea = Basic;
                }
                field(PositionX; Rec.PositionX)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PositionY; Rec.PositionY)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if (Rec."Resource No." <> '') and (Rec.Subtype <> Rec.Subtype::"In Progress") then
                            Error(SubtypeResourceErr);
                    end;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if (Rec."Service Advisor" <> '') and (Rec.Subtype <> Rec.Subtype::"In Progress") then
                            Error(SubtypeServicePersErr);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        SubtypeResourceErr: label 'Only Entries with Subtype "In Progress", can have Resource No.';
        SubtypeServicePersErr: label 'Only Entries with Subtype "In Progress", can have Service Person';
        SubtypeServResErr: label 'Only Entries with Subtype "In Progress", can have Service Person or Resource No.';
        TypeAndSubtypeErr: label 'Subtypes "In Progress" and "Finished" can only be set together with Type "Order"';
}

