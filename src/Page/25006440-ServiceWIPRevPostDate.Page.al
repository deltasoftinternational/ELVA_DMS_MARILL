Page 25006440 "Service WIP Rev. Post. Date"
{
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
        }
    }

    actions
    {
    }

    var
        WIPReversalPostingDate: Date;


    procedure SetParam(WIPReversalPostingDatePar: Date)
    begin
        WIPReversalPostingDate := WIPReversalPostingDatePar;
    end;


    procedure GetParam(var WIPReversalPostingDatePar: Date)
    begin
        WIPReversalPostingDatePar := WIPReversalPostingDate;
    end;
}

