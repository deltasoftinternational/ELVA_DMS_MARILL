Page 25006278 "Vehicle MapView FactBox"
{
    Caption = 'Vehicle MapView';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    PromotedActionCategories = 'Test1,Test2,Test3,Planner';
    RefreshOnActivate = true;
    SourceTable = Vehicle;

    layout
    {
        area(content)
        {

            usercontrol(MapView; MapViewAddIn)
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady()
                var
                    AddInData: Text;
                begin
                    MapViewMgt.ClearVehiclesFromMap();
                    MapViewMgt.AddVehicleToMap(rec."Serial No.");
                    MapViewMgt.FillAddInData(AddInData);
                    CurrPage.MapView.RecieveInitMapViewData(AddInData);
                end;
            }

        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    var
        AddInData: Text;
    begin
    end;

    trigger OnAfterGetRecord()
    var
        AddInData: Text;
    begin
        MapViewMgt.ClearVehiclesFromMap();
        MapViewMgt.AddVehicleToMap(rec."Serial No.");
        MapViewMgt.FillAddInData(AddInData);
        CurrPage.MapView.RecieveRefreshMapViewData(AddInData);
    end;

    var
        TCardPageLbl: label 'TCard Planner';
        EditModeLbl: label 'EDIT';
        GoToEditModeTxt: label 'Please switch to configuration mode first.';
        AreYouSureTxt: label 'Are You sure, You want to delete container box?';
        MapViewMgt: Codeunit "MapView Management";
}

