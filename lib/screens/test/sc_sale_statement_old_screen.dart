// import 'dart:convert';
// import 'dart:ui';

// import 'package:collection/collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:intl/intl.dart';
// import 'package:palm_real_vd_app/Network/fetchingdata.dart';
// import 'package:palm_real_vd_app/util/back_icon.dart';
// import 'package:palm_real_vd_app/util/color-utils.dart';
// import 'package:palm_real_vd_app/util/data.dart';
// import 'package:palm_real_vd_app/util/dialogLoading.dart';
// import 'package:palm_real_vd_app/util/pdfFile.dart';
// import 'package:sticky_headers/sticky_headers.dart';

// class SaleStatement extends StatefulWidget {
//   @override
//   _SaleStatementState createState() => _SaleStatementState();
// }

// class _SaleStatementState extends State<SaleStatement> {
//   var txtDateRang = TextEditingController();
//   late String dateFrom, dateTo;
//   DateFormat dateFormat = DateFormat("yyyy-MM-dd");
//   late String accessToken;

//   late Map<String, dynamic> statementMaster, statementPopup;

//   List statementDetail = [];
//   late Map sellDetail;

//   //Master Sale Statement
//   masterSale() {
//     FetchingData.getData("api/get-sale-statement-master/$dateFrom/$dateTo", {
//       "Accept": "application/json",
//       "Authorization": "Bearer $accessToken"
//     }).then((value) async {
//       if (value.statusCode == 200) {
//         var jsonData = jsonDecode(value.body);
//         setState(() {
//           statementMaster = jsonData;
//         });
//       }
//     });
//   }

//   //Detail Sale Statement
//   detailSale() async {
//     DialogLoading.showLoadingDialog(context);
//     try{
//       await FetchingData.getData("api/get-sale-statement-detail/$dateFrom/$dateTo", {
//         "Accept": "application/json",
//         "Authorization": "Bearer $accessToken"
//       }).then((value) async {
//         if (value.statusCode == 200) {
//           var jsonData = jsonDecode(value.body);
//           if (jsonData['msg']==null){
//             List list;
//             setState(() {
//               list = jsonData["direct"] + jsonData["indirect"];
//               sellDetail=list.groupListsBy((element) => DateFormat("yyyy-MM-dd").format(DateTime.parse(element['Date'])));
//               statementDetail=sellDetail.entries.map((entry) => "${entry.key}").toList()..sort((a,b)=>b.compareTo(a));
//             });
//           }else{
//             setState(() {
//               statementDetail.clear();
//             });
//           }
//         }
//         Navigator.pop(context);
//       });
//     }catch(e){
//       Navigator.pop(context);
//     }

//   }

//   salePopup(id) async {
//     DialogLoading.showLoadingDialog(context);
//     try{
//       await FetchingData.getData("api/get-sale-statement-popup/$id", {
//         "Accept": "application/json",
//         "Authorization": "Bearer $accessToken"
//       }).then((value) async {
//         if (value.statusCode == 200) {
//           var jsonData = jsonDecode(value.body);
//           setState(() {
//             statementPopup = jsonData;
//           });
//           Navigator.pop(context);
//           showAlertDialog(context,id,statementPopup['remark']);
//         }
//       });
//     }catch(e){
//       Navigator.pop(context);
//     }

//   }

//   @override
//   void initState() {
//     setData();
//     // TODO: implement initState
//     super.initState();
//   }


//   setData() async {
//     if (loginData.length > 0) {
//       setState(() {
//         accessToken = loginData['access_token'];
//         dateFrom =
//             dateFormat.format((new DateTime.now()).add(new Duration(days: -28)));
//         dateTo = dateFormat.format(new DateTime.now());
//       });

//     }
//     fetchData();
//   }

//   fetchData() async {
//     await masterSale();
//     await detailSale();
//   }


//   showAlertDialog(BuildContext ctx, String id, String desc) {
//     // set up the buttons
//     Widget continueButton = FloatingActionButton(
//         child: Row(
//           children: [
//             Text("Download",
//             style: TextStyle(color: Colors.teal, fontSize: 16.0)),
//             Icon(
//               Icons.backup,
//               color: Colors.teal,
//             ),
//           ],
//         ),
//         onPressed: () {
//           FilePDF.createFile(
//               "Sale Statement",
//               id,
//               statementPopup['direct_from'],
//               statementPopup['to_member'],
//               statementPopup['remark'],
//               statementPopup['original_amount'],
//               statementPopup['original_amount'],
//               statementPopup['from_customer']
//           );
//         },
//     );

//     // set up the AlertDialog
//     Dialog alert = Dialog(
//       elevation: 0,
//       insetPadding: EdgeInsets.fromLTRB(20, 20, 20, 5),
//       backgroundColor: Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             desc,
//             style: TextStyle(color: Colors.black54, fontSize: 16),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Divider(
//             color: Colors.teal,
//             height: 2,
//           ),
//           Table(
//             defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//             children: [
//               TableRow(
//                   children: [
//                     TableCell(child:Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'ID:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),),
//                     TableCell(child:
//                     Text(
//                       id,
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                     ),)
//                   ]
//               ),
//               TableRow(
//                   children: [
//                     TableCell(child:Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Direct From:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),),
//                     TableCell(child:
//                     Text(
//                       statementPopup != null ? statementPopup['direct_from'] : '',
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                     ),)
//                   ]
//               ),
//               TableRow(
//                   children: [
//                     TableCell(child:Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'To Member:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),),
//                     TableCell(child:
//                     Text(
//                       statementPopup != null ? statementPopup['to_member'] : '',
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                     ),)
//                   ]
//               ),
//               TableRow(
//                   children: [
//                     TableCell(child:Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'From Customer:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),),
//                     TableCell(child:
//                     Text(
//                       statementPopup != null
//                           ? statementPopup['from_customer']
//                           : '',
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                     ),)
//                   ]
//               ),
//               TableRow(
//                   children: [
//                     TableCell(child:Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Remark:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),),
//                     TableCell(child:
//                     Text(
//                       statementPopup != null ? statementPopup['remark'] : '',
//                       style: TextStyle(color: Colors.black54, fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 2,softWrap: true,
//                     ),)
//                   ]
//               ),
//               TableRow(
//                   children: [
//                     TableCell(child:Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Amount:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),),
//                     TableCell(child:
//                     Text(
//                       '${statementPopup != null ? statementPopup['original_amount'] : '0'} USD',
//                       style: TextStyle(
//                           color: Colors.green,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold),
//                     ),)
//                   ]
//               ),

//             ],
//           ),
//           Divider(
//             color: Colors.teal,
//             height: 2,
//           ),
//           continueButton,
//         ],
//       ),
//     );
//     showDialog(
//         builder: (context) => BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaY: 10,
//             sigmaX: 10,
//           ),
//           child: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               color: Colors.blue.withOpacity(0.2),
//               child: Stack(
//                 clipBehavior: Clip.none, alignment: Alignment.center,
//                 children: <Widget>[
//                   Container(
//                       width: MediaQuery.of(context).size.width - 40,
//                       height:320,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.white),
//                       // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                       child: alert),
//                 ],
//               ),
//             ),
//           ),
//         ), context: ctx);
//   }

//   headerForm() {
//     return Container(
//       margin: EdgeInsets.all(10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(10)
//             ),
//             width: MediaQuery.of(context).size.width/2 -20,
//             height: MediaQuery.of(context).size.width/2 -30,
//             padding: EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text('Direct Sale',style: TextStyle(fontSize: 12),),
//                 // Divider(height: 2,color: Colors.yellowAccent,),
//                 Text(
//                   '${statementMaster != null ? statementMaster['count_sell_direct'] : '0'}',
//                   style:
//                   TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                     '${statementMaster != null ? statementMaster['amount_direct'] : '0'} USD',
//                     style: TextStyle(fontSize: 12)),
//               ],
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(10)
//             ),
//             width: MediaQuery.of(context).size.width/2 -20,
//             height: MediaQuery.of(context).size.width/2 -30,
//             padding: EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text('Indirect Sale',style: TextStyle(fontSize: 12),),
//                 // Divider(height: 2,color: Colors.yellowAccent,),
//                 Text(
//                   '${statementMaster != null ? statementMaster['count_sell_indirect'] : '0'}',
//                   style:
//                   TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                     '${statementMaster != null ? statementMaster['amount_indirect'] : '0'} USD',
//                     style: TextStyle(fontSize: 12)),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//   detailContent() {
//     return ListView.builder(
//         shrinkWrap: true,
//         itemCount: statementDetail.length,
//         itemBuilder: (context, index) {
//           return  StickyHeader(
//               header: Container(
//                 height: 50.0,
//                 color:  Color(0xFFCFD8DC),
//                 padding: EdgeInsets.symmetric(horizontal: 16.0),
//                 alignment: Alignment.centerLeft,
//                 child: Text('${DateFormat("EEEE, MMM dd yyyy").format(DateTime.parse(statementDetail[index]))}',
//                   style: const TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),
//                 ),
//               ),
//               content: ListView.separated(
//                 shrinkWrap: true,
//                 physics: ClampingScrollPhysics(),
//                 separatorBuilder: (context, index) => Divider(height: 1,
//                   color: ColorUtils.bgColor,
//                 ),
//                 itemCount: sellDetail[statementDetail[index]].length,
//                 itemBuilder: (BuildContext context,int i){
//                   return
//                     ListTile(
//                       tileColor: Colors.white,
//                       title: Text('${sellDetail[statementDetail[index]][i]['Description']}',style: TextStyle(color: Colors.blueGrey),),
//                       leading: Icon(
//                         Icons.account_balance_wallet,
//                         color: Colors.grey.withOpacity(0.5),
//                       ),
//                       trailing: Text(
//                         '${sellDetail[statementDetail[index]][i]['Amount']} \$',
//                         style: TextStyle(
//                             color: Colors.deepOrange, fontWeight: FontWeight.bold),
//                       ),
//                       onTap: () {
//                          // showAlertDialog(context,sellDetail[statementDetail[index]][i]['id'].toString(),sellDetail[statementDetail[index]][i]['Description']);
//                         salePopup(sellDetail[statementDetail[index]][i]['Id'].toString());
//                       },
//                     );

//                 },
//               )
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorUtils.bgColor,
//       appBar: new AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: BackIcon(),
//           alignment: Alignment.centerLeft,
//           tooltip: 'Back',
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           PopupMenuButton(
//             itemBuilder: (context)=>[
//               PopupMenuItem(child: Text("Last 7 days"), value: "7"),
//               PopupMenuItem(child: Text("Last 28 days"), value: "28"),
//               PopupMenuItem(child: Text("Last 90 days"), value: "90"),
//               PopupMenuItem(child: Text("Last 365 days"), value: "365"),
//               PopupMenuItem(child: Text("Lifetime"), value: "1000"),
//             ],
//             icon: Icon(Icons.filter_list),
//             color: ColorUtils.bgColor,
//             onSelected: (value){
//              setState(() {
//                dateFrom =
//                    dateFormat.format((new DateTime.now()).add(new Duration(days: - int.parse(value))));
//                dateTo = dateFormat.format(new DateTime.now());
//              });
//              fetchData();
//             },

//           )
//         ],
//         title: Text("Sale Statement"),
//         backgroundColor: ColorUtils.appBarColor,
//       ),
//       body: Column(
//         children: [
//           headerForm(),
//           // dateRangeForm(),
//           Flexible(child: detailContent())
//         ],
//       ),
//       // body: detailContent(),
//     );
//   }
// }