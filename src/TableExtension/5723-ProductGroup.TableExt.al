// tableextension 25006063 "Product Group" extends "Product Group" //5723
// {
//     // 15.08.2007. EDMS P2
//     //   * Added new fields
//     //        Date Filter
//     //        Global Dimension 1 Filter
//     //        Global Dimension 2 Filter
//     //        Location Filter
//     //        Sales (LCY)
//     //        COGS (LCY)
//     //        Cost Amount Net Change
//     fields
//     {
//         field(25006671; "Date Filter"; Date)
//         {
//             Caption = 'Date Filter';
//             FieldClass = FlowFilter;
//         }
//         field(25006672; "Global Dimension 1 Filter"; Code[20])
//         {
//             CaptionClass = '1,3,1';
//             Caption = 'Global Dimension 1 Filter';
//             FieldClass = FlowFilter;
//             TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
//         }
//         field(25006673; "Global Dimension 2 Filter"; Code[20])
//         {
//             CaptionClass = '1,3,2';
//             Caption = 'Global Dimension 2 Filter';
//             FieldClass = FlowFilter;
//             TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
//         }
//         field(25006674; "Location Filter"; Code[10])
//         {
//             Caption = 'Location Filter';
//             FieldClass = FlowFilter;
//             TableRelation = Location;
//         }
//         field(25006681; "Sales (LCY)"; Decimal)
//         {
//             AutoFormatType = 1;
//             CalcFormula = sum("Value Entry"."Sales Amount (Actual)" where("Item Ledger Entry Type" = const(Sale),
//                                                                            "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
//                                                                            "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
//                                                                            "Location Code" = field("Location Filter"),
//                                                                            "Posting Date" = field("Date Filter"),
//                                                                            "Item Category Code" = field("Item Category Code"),
//                                                                            "Product Group Code" = field(Code)));
//             Caption = 'Sales (LCY)';
//             Editable = false;
//             FieldClass = FlowField;
//         }
//         field(25006682; "COGS (LCY)"; Decimal)
//         {
//             AutoFormatType = 1;
//             CalcFormula = - sum("Value Entry"."Cost Amount (Actual)" where("Item Ledger Entry Type" = const(Sale),
//                                                                            "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
//                                                                            "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
//                                                                            "Location Code" = field("Location Filter"),
//                                                                            "Posting Date" = field("Date Filter"),
//                                                                            "Item Category Code" = field("Item Category Code"),
//                                                                            "Product Group Code" = field(Code)));
//             Caption = 'COGS (LCY)';
//             Editable = false;
//             FieldClass = FlowField;
//         }
//         field(25006683; "Cost Amount Net Change"; Decimal)
//         {
//             CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Posting Date" = field("Date Filter"),
//                                                                           "Location Code" = field("Location Filter"),
//                                                                           "Item Category Code" = field("Item Category Code"),
//                                                                           "Product Group Code" = field(Code)));
//             Caption = 'Cost Amount Net Change';
//             DecimalPlaces = 0 : 5;
//             Editable = false;
//             FieldClass = FlowField;
//         }

//     }

// }