Codeunit 25006511 "Dead Stock Management"
{
    // 15.05.2014 Elva Baltic P21 #S0105 MMG7.00
    //   Modified function:
    //     FillDeadStockList


    trigger OnRun()
    begin
    end;

    var
        DeadStockSetup: Record "Dead Stock Setup";
        Text001: label 'Dead stock item list processing:';


    procedure FillDeadStockList(var Item: Record Item; var DeadStockBuffer: Record "Dead Stock Statement Buffer" temporary; ShowAll: Boolean)
    var
        StartDate: Date;
        EndDate: Date;
        Window: Dialog;
        CurrentRec: Integer;
        MaxRec: Integer;
    begin
        Window.Open(
          Text001 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1, 0);

        MaxRec := Item.Count;
        CurrentRec := 0;
        DeadStockSetup.Get;
        DeadStockBuffer.DeleteAll;

        if Item.GetFilter("Date Filter") = '' then begin
            DeadStockSetup.TestField("Starting Date");
            DeadStockSetup.TestField("Ending Date");
            Item.SetFilter("Date Filter", '%1..%2', DeadStockSetup."Starting Date", DeadStockSetup."Ending Date");
        end;

        if Item.FindSet then
            repeat
                CurrentRec += 1;
                Window.Update(1, ROUND(CurrentRec / MaxRec * 10000, 1));

                Item.CalcFields("Sales (Qty.)", "Purchases (Qty.)", Inventory, "Net Change", "Transferred (Qty.)", "Reserved Qty. on Inventory");

                if (Item."Sales (Qty.)" + (-Item."Transferred (Qty.)") < DeadStockSetup."Min. Dead Stock Rate")
                   or (Item."Sales (Qty.)" + (-Item."Transferred (Qty.)") = 0) or ShowAll
                then begin
                    DeadStockBuffer.Init;
                    DeadStockBuffer."Item No." := Item."No.";
                    DeadStockBuffer."Sales (Qty.)" := Item."Sales (Qty.)";
                    DeadStockBuffer."Purchase (Qty.)" := Item."Purchases (Qty.)";
                    DeadStockBuffer."Transferred (Qty.)" := -Item."Transferred (Qty.)";
                    DeadStockBuffer."Net Change" := Item."Net Change";
                    DeadStockBuffer.Inventory := Item.Inventory;
                    DeadStockBuffer."Reserved on Inventory" := Item."Reserved Qty. on Inventory";
                    DeadStockBuffer."Available Inventory" := Item.Inventory - Item."Reserved Qty. on Inventory";
                    DeadStockBuffer."Item Category Code" := Item."Item Category Code";
                    //DeadStockBuffer."Product Group Code" := Item."Product Group Code"; //20.06.2019 EB.P7 BC Upgrade
                    DeadStockBuffer."Unit Cost" := Item."Unit Cost";
                    DeadStockBuffer."Cost Amount" := Item.Inventory * Item."Unit Cost";
                    DeadStockBuffer."Reorder Point" := Item."Reorder Point";
                    DeadStockBuffer."Maximum Inventory" := Item."Maximum Inventory";
                    if DeadStockBuffer."Sales (Qty.)" = 0 then begin
                        DeadStockBuffer."No Sales" := true;
                        DeadStockBuffer."Dead Stock Rate 2" := 0
                    end else
                        DeadStockBuffer."Dead Stock Rate 2" := Item."Net Change" / Item."Sales (Qty.)";
                    DeadStockBuffer."Dead Stock Rate" := Item."Purchases (Qty.)" - Item."Sales (Qty.)" + Item."Transferred (Qty.)";
                    DeadStockBuffer.Insert;
                end;
            until Item.Next = 0;
        Window.Close;
    end;
}

