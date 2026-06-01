Report 25006125 "ABC Category Update"
{
    Caption = 'ABC Category Update';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item; Item)
        {
            CalcFields = "Sales Entries", "Sales Return Entries";
            RequestFilterFields = "Date Filter";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Break;
            end;

            trigger OnPostDataItem()
            begin
                ItemToUpdate.Reset;
                ItemToUpdate.CopyFilters(Item);

                // --
                Window.Open(StrSubstNo('%1', WindowItemTxt));
                RC := 5;
                CP := 0;
                // --

                ItemToUpdate.SetAutocalcFields("Sales Entries", "Sales Return Entries", "Nonstock Entry No.");
                // C Category
                ItemToUpdate.ModifyAll("ABC Category", ItemToUpdate."abc category"::C);

                // --
                CP += 1;
                Window.Update(2, ROUND(CP / RC * 10000, 1, '<'));
                // --

                // B Category
                ItemToUpdate.SetRange("Sales Entries", CriteriaB, CriteriaA - 1);
                ItemToUpdate.ModifyAll("ABC Category", ItemToUpdate."abc category"::B);

                // --
                CP += 1;
                Window.Update(2, ROUND(CP / RC * 10000, 1, '<'));
                // --

                ItemToUpdate.SetFilter("Sales Return Entries", '<>0');
                if ItemToUpdate.FindSet(true) then
                    repeat
                        if (ItemToUpdate."Sales Entries" - ItemToUpdate."Sales Return Entries") < CriteriaB then begin
                            ItemToUpdate."ABC Category" := ItemToUpdate."abc category"::C;
                            ItemToUpdate.Modify;
                        end;
                    until ItemToUpdate.Next = 0;

                // --
                CP += 1;
                Window.Update(2, ROUND(CP / RC * 10000, 1, '<'));
                // --

                // A Category
                ItemToUpdate.SetFilter("Sales Return Entries", '');
                ItemToUpdate.SetFilter("Sales Entries", '>=%1', CriteriaA);
                ItemToUpdate.ModifyAll("ABC Category", ItemToUpdate."abc category"::A);

                // --
                CP += 1;
                Window.Update(2, ROUND(CP / RC * 10000, 1, '<'));
                // --

                ItemToUpdate.SetFilter("Sales Return Entries", '<>0');
                if ItemToUpdate.FindSet(true) then
                    repeat
                        if (ItemToUpdate."Sales Entries" - ItemToUpdate."Sales Return Entries") < CriteriaB then begin
                            ItemToUpdate."ABC Category" := ItemToUpdate."abc category"::C;
                            ItemToUpdate.Modify;
                        end else
                            if (ItemToUpdate."Sales Entries" - ItemToUpdate."Sales Return Entries") < CriteriaA then begin
                                ItemToUpdate."ABC Category" := ItemToUpdate."abc category"::B;
                                ItemToUpdate.Modify;
                            end;
                    until ItemToUpdate.Next = 0;

                // --
                CP += 1;
                Window.Update(2, ROUND(CP / RC * 10000, 1, '<'));
                Window.Close;
                // --


                // Calculate Replacement picks >>
                if IncludeSubstitutedItems then begin

                    TmpDataBuffer.Reset;
                    TmpDataBuffer.DeleteAll;

                    // TmpDataBuffer."Code Field 1"  - "Item No."
                    // TmpDataBuffer."Code Field 2"  - "Nonstock Entry No."
                    // TmpDataBuffer."Integer Field 1"  - "Item No." Picks
                    // TmpDataBuffer."Integer Field 2"  - Replaced by Picks

                    n := 0;
                    ItemToUpdate.CopyFilters(Item);
                    ItemToUpdate.SetRange("ABC Category", ItemToUpdate."abc category"::B, ItemToUpdate."abc category"::C);
                    ItemToUpdate.SetFilter("Nonstock Entry No.", '<>%1', '''');
                    if ItemToUpdate.FindSet then
                        repeat
                            n += 1;
                            TmpDataBuffer.Init;
                            TmpDataBuffer."Entry No." := n;
                            TmpDataBuffer."Code Field 1" := ItemToUpdate."No.";
                            TmpDataBuffer."Code Field 2" := ItemToUpdate."Nonstock Entry No.";
                            TmpDataBuffer."Integer Field 1" := ItemToUpdate."Sales Entries" - ItemToUpdate."Sales Return Entries";
                            TmpDataBuffer.Insert;
                        until ItemToUpdate.Next = 0;

                    TmpDataBufferSubstitution.Reset;
                    TmpDataBufferSubstitution.DeleteAll;
                    // TmpDataBufferSubstitution."Code Field 1"  - "Nonstock Entry No." Replaces
                    // TmpDataBufferSubstitution."Code Field 2"  - "Nonstock Entry No." Replaced by
                    // TmpDataBufferSubstitution."Integer Field 1"  - Replaced by Picks

                    m := 0;
                    ItemSubstitution.Reset;
                    ItemSubstitution.SetRange(ItemSubstitution."Substitute Type", ItemSubstitution."substitute type"::"Nonstock Item");
                    ItemSubstitution.SetRange(ItemSubstitution.Type, ItemSubstitution.Type::"Nonstock Item");
                    ItemSubstitution.SetRange(ItemSubstitution."Replacement Info.", ItemSubstitution."replacement info."::Replacement);
                    if ItemSubstitution.FindSet then
                        repeat
                            TmpDataBuffer.Reset;
                            TmpDataBuffer.SetRange("Code Field 2", ItemSubstitution."No.");
                            if TmpDataBuffer.FindFirst then begin
                                m += 1;
                                TmpDataBufferSubstitution.Init;
                                TmpDataBufferSubstitution."Entry No." := m;
                                TmpDataBufferSubstitution."Code Field 1" := ItemSubstitution."No.";
                                TmpDataBufferSubstitution."Code Field 2" := ItemSubstitution."Substitute No.";
                                TmpDataBufferSubstitution."Integer Field 1" := TmpDataBuffer."Integer Field 1";
                                TmpDataBufferSubstitution.Insert;
                            end;
                        until ItemSubstitution.Next = 0;

                    if ItemToUpdate.FindSet(true) then
                        repeat
                            i := 0;
                            TmpDataBufferCircularReferenceCheck.Reset;
                            TmpDataBufferCircularReferenceCheck.DeleteAll;
                            // TmpDataBufferCircularReferenceCheck."Code Field 1" - this field used for nonstock entry no. already in replacement tree
                            ReplacementPicks := GetReplacedByPicks(ItemToUpdate."Nonstock Entry No.", 0);
                            TotalItemPicks := ReplacementPicks + ItemToUpdate."Sales Entries" - ItemToUpdate."Sales Return Entries";
                            if TotalItemPicks >= CriteriaA then begin
                                ItemToUpdate."ABC Category" := ItemToUpdate."abc category"::A;
                                ItemToUpdate.Modify;
                            end;
                            if (TotalItemPicks >= CriteriaB) and (TotalItemPicks < CriteriaA) then begin
                                ItemToUpdate."ABC Category" := ItemToUpdate."abc category"::B;
                                ItemToUpdate.Modify;
                            end;
                        until ItemToUpdate.Next = 0;

                end;
                // Calculate Replacement picks <<

                Message(CalcCompletedTxt);
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
                    field(CriteriaA; CriteriaA)
                    {
                        ApplicationArea = Basic;
                        Caption = 'A Category Criteria';
                    }
                    field(CriteriaB; CriteriaB)
                    {
                        ApplicationArea = Basic;
                        Caption = 'B Category Criteria';
                    }
                    field(CriteriaC; CriteriaC)
                    {
                        ApplicationArea = Basic;
                        Caption = 'C Category Criteria';
                    }
                    field(IncludeSubstitutedItems; IncludeSubstitutedItems)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Substituted Items';
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

    var
        ItemToUpdate: Record Item;
        CriteriaA: Integer;
        CriteriaB: Integer;
        CriteriaC: Integer;
        IncludeSubstitutedItems: Boolean;
        Window: Dialog;
        RC: Integer;
        CP: Integer;
        WindowItemTxt: label 'Categories                 @2@@@@@@@@@@@@@@@@@@@';
        CalcCompletedTxt: label 'Calculation completed.';
        TmpDataBuffer: Record "Data Buffer" temporary;
        ItemSubstitution: Record "Item Substitution";
        TmpDataBufferSubstitution: Record "Data Buffer" temporary;
        n: Integer;
        m: Integer;
        TmpDataBufferCircularReferenceCheck: Record "Data Buffer" temporary;
        ReplacementPicks: Integer;
        TotalItemPicks: Integer;
        i: Integer;

    local procedure GetReplacedByPicks(NextNonstockItemNo: Code[20]; LoopNo: Integer): Integer
    var
        PickQty: Integer;
        ItemNotInFilter: Record Item;
    begin
        // To resolve circular references >>
        TmpDataBufferCircularReferenceCheck.Reset;
        TmpDataBufferCircularReferenceCheck.SetRange("Code Field 1", NextNonstockItemNo);
        if TmpDataBufferCircularReferenceCheck.FindFirst then
            exit(0);
        i += 1;
        TmpDataBufferCircularReferenceCheck.Init;
        TmpDataBufferCircularReferenceCheck."Entry No." := i;
        TmpDataBufferCircularReferenceCheck."Code Field 1" := NextNonstockItemNo;
        TmpDataBufferCircularReferenceCheck.Insert;
        // To resolve circular references <<

        if LoopNo = 10 then
            exit(0);
        TmpDataBufferSubstitution.Reset;
        TmpDataBufferSubstitution.SetRange("Code Field 1", NextNonstockItemNo);
        if TmpDataBufferSubstitution.FindSet then begin
            repeat
                PickQty := TmpDataBufferSubstitution."Integer Field 1" + GetReplacedByPicks(TmpDataBufferSubstitution."Code Field 2", LoopNo);
            until TmpDataBufferSubstitution.Next = 0;
        end else begin
            if ItemNotInFilter.Get(NextNonstockItemNo) then;
            ItemNotInFilter.CalcFields("Sales Entries", "Sales Return Entries");
            PickQty := ItemNotInFilter."Sales Entries" + ItemNotInFilter."Sales Return Entries" + GetReplacedByPicks(TmpDataBufferSubstitution."Code Field 2", LoopNo);
        end;
        LoopNo += 1;
        exit(PickQty);
    end;
}

