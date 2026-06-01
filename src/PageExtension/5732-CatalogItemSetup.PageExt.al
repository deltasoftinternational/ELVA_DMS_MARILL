pageextension 25006801 "Catalog Item Setup" extends "Catalog Item Setup" //5732
{
    layout
    {
        addafter("No. Format Separator")
        {
            field("Updt. Nonstock with Item rel."; rec."Updt. Nonstock with Item rel.")
            {
                ApplicationArea = All;
            }
        }

    }
}