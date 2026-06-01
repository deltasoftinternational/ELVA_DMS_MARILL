Page 25006880 "3rd Parties Services"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "3rd Parties Services";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ServiceCode; Rec."Service Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = Basic;
                }
                field(Enabled; Rec.Enabled)
                {
                    ApplicationArea = Basic;
                }
                field(EndpointURL1; Rec."End point URL 1")
                {
                    ApplicationArea = Basic;
                }
                field(EndpointURL2; Rec."End point URL 2")
                {
                    ApplicationArea = Basic;
                }
                field(EndpointURL3; Rec."End point URL 3")
                {
                    ApplicationArea = Basic;
                }
                field(APIKey; Rec."API Key")
                {
                    ApplicationArea = Basic;
                }
                field(UserName; Rec."User Name")
                {
                    ApplicationArea = Basic;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = Basic;
                }
                field(TokensEnabled; Rec."Tokens Enabled")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

