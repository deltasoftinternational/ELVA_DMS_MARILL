tableextension 25006128 "Item Template" extends "Item Templ." //1301
{
    // 08.02.2017 EB.P7 EDMS Upgrade 2017
    //   Added fields:
    //     25006670Item Type
    //   Modified function CreateFieldRefArray
    fields
    {
        field(25006670; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
    }
}
