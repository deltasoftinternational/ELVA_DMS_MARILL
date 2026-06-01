Page 25006352 "Service Schedule Search"
{
    Caption = 'Service Schedule Search';

    layout
    {
        area(content)
        {
            group(Resource)
            {
                Caption = 'Resource';
                field(ResourceNo; ResourceNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource No.';
                    TableRelation = Resource;
                }
            }
        }
    }

    actions
    {
    }

    var
        ResourceNo: Code[20];


    procedure TargetResourceNo(): Code[20]
    begin
        exit(ResourceNo);
    end;
}

