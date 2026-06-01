report 25006962 "EDMS Remove Contacts - Refine"//5196
{
    Caption = 'Remove Contacts - Refine';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Segment Header"; "Segment Header")
        {
            DataItemTableView = SORTING("No.");

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem(Contact; Contact)
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Search Name", Type, "Salesperson Code", "Post Code", "Country/Region Code", "Territory Code";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem("Contact Profile Answer"; "Contact Profile Answer")
        {
            DataItemTableView = SORTING("Contact No.", "Profile Questionnaire Code", "Line No.");
            RequestFilterFields = "Profile Questionnaire Code", "Line No.";
            RequestFilterHeading = 'Profile';

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem("Contact Mailing Group"; "Contact Mailing Group")
        {
            DataItemTableView = SORTING("Contact No.", "Mailing Group Code");
            RequestFilterFields = "Mailing Group Code";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem("Interaction Log Entry"; "Interaction Log Entry")
        {
            DataItemTableView = SORTING("Entry No.");
            RequestFilterFields = Date, "Segment No.", "Campaign No.", Evaluation, "Interaction Template Code", "Salesperson Code";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem("Contact Job Responsibility"; "Contact Job Responsibility")
        {
            DataItemTableView = SORTING("Contact No.", "Job Responsibility Code");
            RequestFilterFields = "Job Responsibility Code";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem("Contact Industry Group"; "Contact Industry Group")
        {
            DataItemTableView = SORTING("Contact No.", "Industry Group Code");
            RequestFilterFields = "Industry Group Code";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem("Contact Business Relation"; "Contact Business Relation")
        {
            DataItemTableView = SORTING("Contact No.", "Business Relation Code");
            RequestFilterFields = "Business Relation Code";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = SORTING("Source Type", "Source No.", "Item No.", "Posting Date");
            RequestFilterFields = "Item No.", "Variant Code", "Posting Date", "Inventory Posting Group";

            trigger OnPreDataItem()
            begin
                CurrReport.Break();
            end;
        }
        dataitem("Vehicle Contact"; "Vehicle Contact")
        {
            DataItemTableView = sorting("Contact No.");
            RequestFilterFields = "Relationship Code";
            column(ReportForNavId_3985; 3985)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem(Vehicle; Vehicle)
        {
            RequestFilterFields = "Make Code", "Model Code";
            column(ReportForNavId_7543; 7543)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Vehicle Service Plan"; "Vehicle Service Plan")
        {
            RequestFilterFields = "No.", "Service Plan Type", "Template Code";
            column(ReportForNavId_8970; 8970)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Vehicle Service Plan Stage"; "Vehicle Service Plan Stage")
        {
            RequestFilterFields = "Expected Service Date", "Service Date", Status;
            column(ReportForNavId_1757; 1757)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Service Ledger Entry EDMS"; "Service Ledger Entry EDMS")
        {
            RequestFilterFields = "Entry Type", "Posting Date";
            column(ReportForNavId_2609; 2609)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Recall Campaign Vehicle"; "Recall Campaign Vehicle")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(EntireCompanies; EntireCompanies)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Entire Companies';
                        ToolTip = 'Specifies if you want to remove all the person contacts employed in the company that you remove from the segment.';
                    }
                    field(DetailedDeleteVehicle; DetailedDeleteVehicle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Detailed Refine by Vehicle';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        Clear(ReduceRefineSegment);
        ReduceRefineSegment.SetTableView("Segment Header");
        ReduceRefineSegment.SetTableView(Contact);
        ReduceRefineSegment.SetTableView("Contact Profile Answer");
        ReduceRefineSegment.SetTableView("Contact Mailing Group");
        ReduceRefineSegment.SetTableView("Interaction Log Entry");
        ReduceRefineSegment.SetTableView("Contact Job Responsibility");
        ReduceRefineSegment.SetTableView("Contact Industry Group");
        ReduceRefineSegment.SetTableView("Contact Business Relation");
        ReduceRefineSegment.SetTableView("Value Entry");
        ReduceRefineSegment.SetTableview("Vehicle Contact");
        ReduceRefineSegment.SetTableview(Vehicle);
        ReduceRefineSegment.SetTableview("Vehicle Service Plan");
        ReduceRefineSegment.SetTableview("Vehicle Service Plan Stage");
        ReduceRefineSegment.SetTableview("Service Ledger Entry EDMS");
        ReduceRefineSegment.SetTableview("Recall Campaign Vehicle");
        ReduceRefineSegment.SetOptions(Report::"EDMS Remove Contacts - Reduce", EntireCompanies, DetailedDeleteVehicle);
        ReduceRefineSegment.RunModal;
    end;

    var
        ReduceRefineSegment: Report "EDMS Remove Contacts";
        EntireCompanies: Boolean;
        DetailedDeleteVehicle: Boolean;
}