pageextension 25006090 "Transfer Order" extends "Transfer Order"//5740
{
    layout
    {
        addafter("Transfer-to Code")
        {
            field(DocumentProfile; Rec."Document Profile")
            {
                ApplicationArea = Basic;
                trigger OnValidate()
                begin
                    CurrPage.Update;
                end;
            }
        }
        addafter(Status)
        {
            field(CombinedOrder; Rec."Combined Order")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(DocumentStatus; Rec."Document Status")
            {
                ApplicationArea = Basic;
            }
        }
        modify(TransferLines)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(TransferLines)
        {
            part(TransferLinesVehicle; "Transfer Order Subf. (Veh.)")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No."),
                              "Derived From Line No." = const(0);
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Foreign Trade")
        {
            group(Service)
            {
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceNo; Rec."Source No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transfer-to Customer No."; Rec."Transfer-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Customer Name"; Rec."Transfer-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Vehicle Serial No."; Rec."Transfer-to Vehicle Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Vehicle Make Code"; Rec."Transfer-to Vehicle Make Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Vehicle Model Code"; Rec."Transfer-to Vehicle Model Code")
                {
                    ApplicationArea = All;
                }
                field("Transfer-to Vehicle VIN"; Rec."Transfer-to Vehicle VIN")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addafter(Dimensions)
        {
            action(ReceiptDimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Receipt Dimensions';
                Image = Dimensions;

                trigger OnAction()
                begin
                    rec.ShowDocReceiptDim;
                    CurrPage.SaveRecord;
                end;
            }
        }
        addafter(GetReceiptLines)
        {
            action(AutoReserveQtyOutbnd)
            {
                ApplicationArea = Basic;
                Caption = 'Auto Reserve Quantity Outbnd.';
                Image = Reserve;

                trigger OnAction()
                begin
                    ServiceTransferMgt.ReserveTransfOrderQtyOutbnd(Rec);                         // 07.03.2014 Elva Baltic P21
                end;
            }
            //DELTA PROMISE
            action(CreateOrderPromising)
            {
                ApplicationArea = Basic;
                Caption = 'Create Order Promising';
                Image = CreateInventoryPickup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ServiceTransferMgt.CreateReqLinesFromTransfer(Rec, true, 0);                   // 27.03.2014 Elva Baltic P21
                end;
            }
        }
    }


    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //EDMS >>
        case DocumentProfileFilter of
            Format(Rec."document profile"::"Vehicles Trade"):
                begin
                    Rec."Document Profile" := rec."document profile"::"Vehicles Trade";
                    VehicleTradeDocument := true;
                end;
            Format(Rec."document profile"::"Spare Parts Trade"):
                begin
                    Rec."Document Profile" := rec."document profile"::"Spare Parts Trade";
                    SparePartDocument := true;
                end;
            Format(Rec."document profile"::Service):
                begin
                    Rec."Document Profile" := rec."document profile"::Service;
                    ServiceDocument := true;
                end;
            // 11.07.2016 EB.P30 >>
            Format(Rec."document profile"::"Spare Parts Trade") + '|' + Format(rec."document profile"::Service):
                begin
                    Rec."Document Profile" := rec."document profile"::"Spare Parts Trade";
                    SparePartDocument := true;
                end;
        // 11.07.2016 EB.P30 <<
        end;
        //EDMS >>
    end;

    trigger OnOpenPage()
    begin

        //EDMS >>
        Rec.FilterGroup(3);
        DocumentProfileFilter := Rec.GetFilter("Document Profile");
        Rec.FilterGroup(0);
        //EDMS <<
    end;

    trigger OnAfterGetRecord()
    begin
        EnableTransferFields := not IsPartiallyShipped;
        //EDMS >>
        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
        SparePartDocument := Rec."Document Profile" = Rec."document profile"::"Spare Parts Trade";
        ServiceDocument := Rec."Document Profile" = Rec."document profile"::Service;
        //EDMS >>
    end;


    local procedure IsPartiallyShipped(): Boolean
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.SetRange("Document No.", Rec."No.");
        TransferLine.SetFilter("Quantity Shipped", '> 0');
        exit(not TransferLine.IsEmpty);
    end;

    var
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        EnableTransferFields: Boolean;
        ServiceDocument: Boolean;
        DocumentProfileFilter: Text[250];
        CapabletoPromise: Codeunit "Capable to Promise";
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
}
