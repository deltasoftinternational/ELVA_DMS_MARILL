pageextension 25006025 "Opportunity Card" extends "Opportunity Card"//5124
{
    layout
    {
        addafter("Salesperson Code")
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
        modify("Show Sales Quote")
        {
            visible = false;
        }
        addafter("Show Sales Quote")
        {
            action("Show Sales Quote1")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Show Sales Quote';
                Image = Quote;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show the assigned sales quote.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    ServiceHeaderEDMS: Record "Service Header EDMS";
                    RentHeader: Record "Rent Header";
                    Text001: Label 'There is no sales quote assigned to this opportunity.';

                begin
                    if (Rec."Sales Document Type" <> Rec."Sales Document Type"::Quote) or
                       (Rec."Sales Document No." = '')
                    then
                        Error(Text001);


                    case Rec.Type of
                        Rec.Type::Sales:
                            if SalesHeader.Get(SalesHeader."document type"::Quote, Rec."Sales Document No.") then
                                Page.Run(Page::"Sales Quote", SalesHeader)
                            else
                                Error(Text002, Rec."Sales Document No.");
                        Rec.Type::Service:
                            if ServiceHeaderEDMS.Get(ServiceHeaderEDMS."document type"::Quote, Rec."Sales Document No.") then
                                Page.Run(Page::"Service Quote EDMS", ServiceHeaderEDMS)
                            else
                                Error(Text002, Rec."Sales Document No.");
                        Rec.Type::Rent:
                            if RentHeader.Get(RentHeader."document type"::Quote, Rec."Sales Document No.") then
                                Page.Run(Page::"Rent Quote", RentHeader)
                            else
                                Error(Text002, Rec."Sales Document No.");
                    end;
                end;
            }
        }
    }
    var
        Text002: Label 'Sales quote %1 doesn''t exist.';
}

