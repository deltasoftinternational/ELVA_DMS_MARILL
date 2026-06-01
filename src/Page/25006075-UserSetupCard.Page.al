Page 25006075 "User Setup Card"
{
    // 14.04.2016 EB.P30
    //   Added field: Register Statistics
    // 
    // 16.02.2015 EB.P7 #SingleInst.
    //   Removed "Profile ID" field
    // 
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Allow Cancel Service Reserv."
    // 
    // 11.02.2014 Elva Baltic P8 #xxx MMG7.00
    //   * Added fields:
    //     "Allow Block Customer"
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 19.03.2013 EDMS P8
    //   * Add fields

    Caption = 'User Setup Card';
    PageType = Card;
    SourceTable = "User Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field(AllowPostingFrom; Rec."Allow Posting From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the earliest date on which the user is allowed to post to the company.';
                }
                field(AllowPostingTo; Rec."Allow Posting To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date on which the user is allowed to post to the company.';
                }
                field(AllowPostingOnlyToday; Rec."Allow Posting Only Today")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if user is allowed to post documents only with current posting date.';
                }
                field("Allow Return Not Only Today"; rec."Allow Return Not Only Today")
                {
                    ApplicationArea = All;
                }

                field(RegisterTime; Rec."Register Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to register the user''s time usage defined as the time spent from when the user logs in to when the user logs out. Unexpected interruptions, such as idle session timeout, terminal server idle session timeout, or a client crash are not recorded.';
                }
                field(SalespersPurchCode; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the salesperson or purchaser for the user.';
                }
                field(AllowFAPostingFrom; Rec."Allow FA Posting From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the earliest date on which the user is allowed to post fixed asset entries.';
                }
                field(AllowFAPostingTo; Rec."Allow FA Posting To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date on which the user is allowed to post fixed asset entries.';
                }
                field(SPSalesDiscGroupCode; Rec."SP Sales Disc. Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sales discount limit group. It defines max discount user will be able to provide.';

                }
                //field(StartingFormID; "Starting Form ID")
                //{
                //    ApplicationArea = Basic;
                //}
                field(ItemMarkupRestrictionGroup; Rec."Item Markup Restriction Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the markup restriction group that is assigned to user. It defines minimum markups that must be on sales or service documents.';
                }
                field(VehAccCycleChangeFunct; Rec."Veh. Acc. Cycle Change Funct.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if user is allowed to use function that changes vehicle accounting cycle on posted entries.';
                }
                field(AllowUseServiceSchedule; Rec."Allow Use Service Schedule")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the user''s access rights to the service schedule. Blank means no access, View Only - means user can see allocations, Time Registration - designed for mechanics to see and change allocation by time clocking, Planning - can allocate and change, All - full access including changing of finished allocations.';
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resource code that is related to this user and is used in service time clocking.';
                }
                field(BranchCode; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the branch code assigned to the user. Together with user profile it provides ability to define Branch Profile Setup.';
                }
                field(CancelOnlyOwnReservation; Rec."Cancel Only Own Reservation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the user is allowed to cancel only his own reservations.';
                }
                field(SIEmanagement; Rec."SIE management")
                {
                    ApplicationArea = Basic;
                }
                //field(CustCreditControl; "Cust. Credit Control")
                //{
                //    ApplicationArea = Basic;
                //}
                field(AllowBlockCustomer; Rec."Allow Block Customer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the user is allowed to block customers.';
                }
                field(AllowCancelServiceReserv; Rec."Allow Cancel Service Reserv.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the user is allowed to cancel service reservations. If it is not allowed, user will not be able to cancel reservations in service lines and will be forced to use transfer orders to move items back to warehouse before line can be deleted.';
                }
                //field(RegisterStatistics; "Register Statistics")
                //{
                //    ApplicationArea = Basic;
                //}
            }
            group(Filters)
            {
                field(SalesRespCtrFilter; Rec."Sales Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the responsibility center to which you want to assign the user.';
                }
                field(PurchaseRespCtrFilter; Rec."Purchase Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the responsibility center to which you want to assign the user.';
                }
                field(ServiceRespCtrFilter; Rec."Service Resp. Ctr. Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the responsibility center to which you want to assign the user.';
                }
                field(ServiceRespCtrFilterEDMS; Rec."Service Resp. Ctr. Filter EDMS")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the responsibility center to which you want to assign the user.';
                }
            }
            group(Approval)
            {
                field(SalesAmountApprovalLimit; Rec."Sales Amount Approval Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UnlimitedSalesApproval; Rec."Unlimited Sales Approval")
                {
                    ApplicationArea = Basic;
                }
                field(VehSalesAmountApprLimit; Rec."Veh. Sales Amount Appr. Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UnlimitedVehSalesApproval; Rec."Unlimited Veh. Sales Approval")
                {
                    ApplicationArea = Basic;
                }
                field(SparePartsSalesApprLimit; Rec."Spare Parts Sales Appr. Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UnlimitedSparePartsSales; Rec."Unlimited Spare Parts Sales")
                {
                    ApplicationArea = Basic;
                }
                field(VehServiceApprovalLimit; Rec."Veh. Service Approval Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UnlimitedVehServiceAppr; Rec."Unlimited Veh. Service Appr.")
                {
                    ApplicationArea = Basic;
                }
                field(PurchaseAmountApprovalLimit; Rec."Purchase Amount Approval Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UnlimitedPurchaseApproval; Rec."Unlimited Purchase Approval")
                {
                    ApplicationArea = Basic;
                }
                field(RequestAmountApprovalLimit; Rec."Request Amount Approval Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UnlimitedRequestApproval; Rec."Unlimited Request Approval")
                {
                    ApplicationArea = Basic;
                }
                field(VehPurchAmountApprLimit; Rec."Veh. Purch. Amount Appr. Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UnlimitedVehPurchApproval; Rec."Unlimited Veh. Purch. Approval")
                {
                    ApplicationArea = Basic;
                }
                field(SparePartsPurchApprLimit; Rec."Spare Parts Purch. Appr. Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UnlimitedSparePartsPurch; Rec."Unlimited Spare Parts Purch.")
                {
                    ApplicationArea = Basic;
                }
                field(ApproverID; Rec."Approver ID")
                {
                    ApplicationArea = Basic;
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the user''s email address.';
                }
                field(Substitute; Rec.Substitute)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies who will be the substitute for the user in approval workflow.';
                }
                group(Additional)
                {
                }
                field(ScheduleAddInLogPath; Rec."Schedule Add-In Log Path")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the path where schedule log should be placed.';
                }
                field(ScheduleAddInLogActive; Rec."Schedule Add-In Log Active")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if scheduler activities should be logged.';
                }
            }
            group("Document Profiles")
            {
                field(SPDocProfileEnabled; Rec."SP Doc. Profile Enabled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Spare Parts document profile is enabled for the user. If profile is enabled then user can see and create documents with this profile.';
                }

                field(VehDocProfileEnabled; Rec."Veh. Doc. Profile Enabled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Vehicle Trade document profile is enabled for the user. If profile is enabled then user can see and create documents with this profile.';
                }

                field(ServDocProfileEnabled; Rec."Serv. Doc. Profile Enabled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Service document profile is enabled for the user. If profile is enabled then user can see and create documents with this profile.';
                }

                field(RentDocProfileEnabled; Rec."Rent Doc. Profile Enabled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Rent document profile is enabled for the user. If profile is enabled then user can see and create documents with this profile.';
                }

                field(EmptyDocProfileEnabled; Rec."Empty Doc. Profile Enabled")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if documents with empty profile are enabled for the user. If profile is enabled then user can see and create documents with this profile.';
                }

                field(DefaultDocProfile; Rec."Default Doc. Profile")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default document profile for the user.';
                }
            }
        }
    }
    actions
    {
    }
}

