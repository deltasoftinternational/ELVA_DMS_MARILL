Page 25006871 "TCard Container Card"
{
    DataCaptionExpression = Rec.Name;
    PageType = Card;
    SourceTable = "TCard Container";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(Subtype; Rec.Subtype)
                {
                    ApplicationArea = Basic;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = Basic;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceAdvisor; Rec."Service Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(ContainerColor; Rec."Container Color")
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
                    Importance = Additional;
                }
                field(PositionX; Rec.PositionX)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(PositionY; Rec.PositionY)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
            }
        }
    }

    actions
    {
    }
}

