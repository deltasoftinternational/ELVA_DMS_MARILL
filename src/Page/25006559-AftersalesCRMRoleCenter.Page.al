Page 25006559 "Aftersales CRM Role Center"
{
    Caption = 'Aftersales CRM Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control2)
            {
                part(Control25006001; "Aftersales CRM Activities")
                {
                }
                part("My Contacts"; "My Contacts")
                {
                }
                systempart(Control27; Outlook)
                {
                }
            }
            group(Control3)
            {
                part(Control6; "Aftersales CRM Chart")
                {
                    Caption = 'Sales Campaign Performance';
                }
                systempart(Control4; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(Campaigns)
            {
                ApplicationArea = Basic;
                Caption = 'Campaigns';
                RunObject = Page "Campaign List";
            }
            action("To-Dos")
            {
                ApplicationArea = Basic;
                Caption = 'To-Dos';
                RunObject = Page "Task List";
            }
            action(Segments)
            {
                ApplicationArea = Basic;
                Caption = 'Segments';
                RunObject = Page "Segment List";
            }
            action(Contracts)
            {
                ApplicationArea = Basic;
                Caption = 'Contracts';
                RunObject = Page "Contract List EDMS";
            }
            action(CustomersList)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(ContactsList)
            {
                ApplicationArea = Basic;
                Caption = 'Contacts';
                RunObject = Page "Contact List";
            }
        }
        area(processing)
        {
            group(Tasks)
            {
                action("New Contact")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Contact';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Contact Card";
                    RunPageMode = Create;
                }
                action("New Campaign")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Campaign';
                    Image = Campaign;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Campaign Card";
                    RunPageMode = Create;
                }
                action("New Opportunity")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Opportunity';
                    Image = Opportunity;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Opportunity Card";
                    RunPageMode = Create;
                }
            }
        }
        area(reporting)
        {
            group(Reports)
            {
                action("Campaign Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Campaign Details';
                    Image = CampaignEntries;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Campaign - Details";
                }
                action("Top 10 Customers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Top 10 Customers';
                    Image = CustomerRating;
                    Promoted = true;
                    PromotedCategory = "Report";
                    RunObject = Report "Customer - Top 10 List";
                }
            }
            group(Worksheets)
            {
                action("Interaction Log Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Log Entries';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Interaction Log Entries";
                }
                action("To-Do")
                {
                    ApplicationArea = Basic;
                    Caption = 'To-Do';
                    Image = TaskPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Task List";
                }
            }
        }
        area(sections)
        {
            group(Catalogues)
            {
                Caption = 'Catalogues';
                action(Makes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Makes';
                    RunObject = Page "Make List";
                }
                action(Models)
                {
                    ApplicationArea = Basic;
                    Caption = 'Models';
                    RunObject = Page "Model List";
                }
                action(Vehicles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicles';
                    RunObject = Page "Vehicle List";
                }
                action(Customers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Customers';
                    RunObject = Page "Customer List";
                }
                action(Vendors)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendors';
                    RunObject = Page "Vendor List";
                }
                action(Contacts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contacts';
                    RunObject = Page "Contact List";
                }
                action(Items)
                {
                    ApplicationArea = Basic;
                    Caption = 'Items';
                    RunObject = Page "Item List";
                }
                action(Labors)
                {
                    ApplicationArea = Basic;
                    Caption = 'Labors';
                    RunObject = Page "Service Labor List";
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Campaign Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Campaign Entries';
                    RunObject = Page "Campaign Entries";
                }
                action("Oportunity Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Oportunity Entries';
                    RunObject = Page "Opportunity Entries";
                }
            }
        }
    }
}

