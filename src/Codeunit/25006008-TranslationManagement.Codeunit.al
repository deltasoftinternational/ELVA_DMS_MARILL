Codeunit 25006008 "Translation Management"
{

    trigger OnRun()
    begin
    end;


    procedure fItemTranslationToNonstock(var recItemTranslation: Record "Item Translation"; var xrecItemTranslation: Record "Item Translation"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recNonstockItemTranslation: Record "Nonstock Item Translation";
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */


        if not recItem.Get(recItemTranslation."Item No.") then
            exit;
        if not recItem."Created From Nonstock Item" then
            exit;

        recNonstockItem.Reset;
        recNonstockItem.SetCurrentkey("Item No.");
        recNonstockItem.SetRange("Item No.", recItem."No.");
        if recNonstockItem.IsEmpty then
            exit;

        case intActivity of
            0: //Insert
                begin
                    recNonstockItemTranslation.Init;
                    recNonstockItemTranslation."Nonstock Item Entry No." := recItemTranslation."Item No.";
                    recNonstockItemTranslation."Language Code" := recItemTranslation."Language Code";
                    recNonstockItemTranslation.Description := recItemTranslation.Description;
                    recNonstockItemTranslation."Description 2" := recItemTranslation."Description 2";
                    recNonstockItemTranslation.Insert;
                end;
            1, 2: //modify,rename
                begin
                    recNonstockItemTranslation.Reset;
                    recNonstockItemTranslation.SetRange("Nonstock Item Entry No.", xrecItemTranslation."Item No.");
                    recNonstockItemTranslation.SetRange("Language Code", xrecItemTranslation."Language Code");

                    if recNonstockItemTranslation.FindSet then
                        recNonstockItemTranslation.Delete;

                    recNonstockItemTranslation.Init;
                    recNonstockItemTranslation."Nonstock Item Entry No." := recItemTranslation."Item No.";
                    recNonstockItemTranslation."Language Code" := recItemTranslation."Language Code";
                    recNonstockItemTranslation.Description := recItemTranslation.Description;
                    recNonstockItemTranslation."Description 2" := recItemTranslation."Description 2";
                    recNonstockItemTranslation.Insert;
                end;
            3:  //delete
                begin
                    recNonstockItemTranslation.Reset;
                    recNonstockItemTranslation.SetRange("Nonstock Item Entry No.", recItemTranslation."Item No.");
                    recNonstockItemTranslation.SetRange("Language Code", recItemTranslation."Language Code");

                    if recNonstockItemTranslation.FindSet then
                        recNonstockItemTranslation.Delete;
                end;
        end;

    end;


    procedure fNonstockTranslationToItem(var recNonstockItemTranslation: Record "Nonstock Item Translation"; var xrecNonstockItemTranslation: Record "Nonstock Item Translation"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recItemTranslation: Record "Item Translation";
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */

        if not recNonstockItem.Get(recNonstockItemTranslation."Nonstock Item Entry No.") then
            exit;
        if recNonstockItem."Item No." = '' then
            exit;
        if not recItem.Get(recNonstockItem."Item No.") then
            exit;

        recNonstockItem.TestField("Item No.", recNonstockItem."Entry No.");

        case intActivity of
            0: //Insert
                begin
                    recItemTranslation.Init;
                    recItemTranslation."Item No." := recNonstockItemTranslation."Nonstock Item Entry No.";
                    recItemTranslation."Language Code" := recNonstockItemTranslation."Language Code";
                    recItemTranslation.Description := recNonstockItemTranslation.Description;
                    recItemTranslation."Description 2" := recNonstockItemTranslation."Description 2";
                    recItemTranslation.Insert;

                end;
            1, 2: //modify,rename
                begin
                    recItemTranslation.Reset;
                    recItemTranslation.SetRange("Item No.", xrecNonstockItemTranslation."Nonstock Item Entry No.");
                    recItemTranslation.SetRange("Language Code", xrecNonstockItemTranslation."Language Code");

                    if recItemTranslation.FindSet then
                        recItemTranslation.Delete;

                    recItemTranslation.Init;
                    recItemTranslation."Item No." := recNonstockItemTranslation."Nonstock Item Entry No.";
                    recItemTranslation."Language Code" := recNonstockItemTranslation."Language Code";
                    recItemTranslation.Description := recNonstockItemTranslation.Description;
                    recItemTranslation."Description 2" := recNonstockItemTranslation."Description 2";
                    recItemTranslation.Insert;
                end;
            3:  //delete
                begin
                    recItemTranslation.Reset;
                    recItemTranslation.SetRange("Item No.", recNonstockItemTranslation."Nonstock Item Entry No.");
                    recItemTranslation.SetRange("Language Code", recNonstockItemTranslation."Language Code");

                    if recItemTranslation.FindSet then
                        recItemTranslation.Delete;
                end;
        end;

    end;
}

