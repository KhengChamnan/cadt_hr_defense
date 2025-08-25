// import 'dart:convert';
// import 'dart:ui';

// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:palm_real_vd_app/Network/fetchingdata.dart';
// import 'package:palm_real_vd_app/util/back_icon.dart';
// import 'package:palm_real_vd_app/util/color-utils.dart';
// import 'package:palm_real_vd_app/util/data.dart';
// import 'package:palm_real_vd_app/util/dialogLoading.dart';
// import 'package:palm_real_vd_app/util/pdfFile.dart';
// import 'package:sticky_headers/sticky_headers.dart';

// class Account extends StatefulWidget {
//   @override
//   _AccountState createState() => _AccountState();
// }

// class _AccountState extends State<Account> {
//   List statementDetail = [];
//   late Map accountDetail, statementPopup;
//   late Map accountBalance;
//   late String accessToken;
//   bool isLoad = true;

//   Widget headerForm() {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Stack(
//         children: [
//           Container(
//             height: 160,
//           ),
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Text("Account Name: ${accountBalance['account_name']}"),
//           ),
//           Positioned(
//             top: 20,
//             left: 0,
//             child: Text(
//               "${accountBalance['account_no']}",
//               style: TextStyle(color: Colors.white.withOpacity(0.5)),
//             ),
//           ),
//           Positioned(
//             top: 60,
//             left: 0,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Center(
//                 child: Wrap(
//                   spacing: 10,
//                   direction: Axis.vertical,
//                   alignment: WrapAlignment.center,
//                   crossAxisAlignment: WrapCrossAlignment.center,
//                   children: [
//                     Text(
//                       "CURRENT BALANCE",
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     // Text(
//                     //   "${NumberFormat("#,##0.00").format(double.parse(accountBalance['current_balance']))}",
//                     //   style: TextStyle(fontSize: 25),
//                     // ),
//                     Text(
//                       "USD",
//                       style: TextStyle(
//                           fontSize: 12, color: Colors.white.withOpacity(0.3)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   showAlertDialog(BuildContext ctx, String id) {
//     // set up the buttons
//     Widget continueButton = FloatingActionButton(
//         onPressed: () {
//           AccountPDF.createFile(
//             id,
//             statementPopup['original_amount'],
//             statementPopup['to_member_id'],
//             statementPopup['remark'],
//             statementPopup['amount'],
//           );
//         },
//         child: Row(
//           children: [
//             Text("Download",
//                 style: TextStyle(color: Colors.teal, fontSize: 16.0),
//             ),
//             Icon(
//               Icons.backup,
//               color: Colors.teal,
//             ),
//           ],
//         ));

//     // set up the AlertDialog
//     Dialog alert = Dialog(
//         elevation: 0,
//         insetPadding: EdgeInsets.fromLTRB(20, 20, 20, 5),
//         backgroundColor: Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               statementPopup['remark'],
//               style: TextStyle(color: Colors.black54, fontSize: 16),
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Divider(
//               color: Colors.teal,
//               height: 2,
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Table(
//               defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//               children: [
//                 TableRow(children: [
//                   TableCell(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'ID:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   TableCell(
//                     child: Text(
//                       id,
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                     ),
//                   )
//                 ]),
//                 TableRow(children: [
//                   TableCell(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Original Amount:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   TableCell(
//                     child: Text(
//                       statementPopup != null
//                           ? num.parse(statementPopup['amount'])
//                               .toStringAsFixed(2)
//                           : '0',
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                     ),
//                   )
//                 ]),
//                 TableRow(children: [
//                   TableCell(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'To Member:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   TableCell(
//                     child: Text(
//                       statementPopup != null
//                           ? statementPopup['to_member_id']
//                           : '',
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                     ),
//                   )
//                 ]),
//                 TableRow(children: [
//                   TableCell(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Remark:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   TableCell(
//                     child: Text(
//                       statementPopup != null ? statementPopup['remark'] : '',
//                       style: TextStyle(color: Colors.black54, fontSize: 14),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                       softWrap: true,
//                     ),
//                   )
//                 ]),
//                 TableRow(children: [
//                   TableCell(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         'Amount:',
//                         style: TextStyle(color: Colors.black, fontSize: 14),
//                       ),
//                     ),
//                   ),
//                   TableCell(
//                     child: Text(
//                       '${statementPopup != null ? num.parse(statementPopup['original_amount']).toStringAsFixed(2) : '0'} USD',
//                       style: TextStyle(
//                           color: Colors.green,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   )
//                 ]),
//               ],
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Divider(
//               color: Colors.teal,
//               height: 2,
//             ),
//             continueButton,
//           ],
//         ));

//     showDialog(
//         builder: (context) => BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaY: 3.0,
//                 sigmaX: 3.0,
//               ),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   color: Colors.transparent,
//                   child: Stack(
//                     clipBehavior: Clip.none, alignment: Alignment.center,
//                     children: <Widget>[
//                       Container(
//                           width: MediaQuery.of(context).size.width - 40,
//                           height: 330,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.white),
//                           // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                           child: alert),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         context: ctx);
//   }

//   Widget contentForm() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: ClampingScrollPhysics(),
//       itemCount: statementDetail.length,
//       itemBuilder: (BuildContext context, int index) {
//         return StickyHeader(
//             header: Container(
//               height: 50.0,
//               color: Color(0xFFCFD8DC),
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 '${DateFormat("EEEE, MMM dd yyyy").format(DateTime.parse(statementDetail[index]))}',
//                 style: const TextStyle(
//                     color: Colors.blueGrey, fontWeight: FontWeight.bold),
//               ),
//             ),
//             content: ListView.separated(
//               shrinkWrap: true,
//               physics: ClampingScrollPhysics(),
//               separatorBuilder: (context, index) => Divider(
//                 height: 1,
//                 color: ColorUtils.bgColor,
//               ),
//               itemCount: accountDetail[statementDetail[index]].length,
//               itemBuilder: (BuildContext context, int i) {
//                 return ListTile(
//                   tileColor: Colors.white,
//                   title: Text(
//                     '${accountDetail[statementDetail[index]][i]['note']}',
//                     style: TextStyle(color: Colors.blueGrey),
//                   ),
//                   leading: Icon(
//                     Icons.account_balance_wallet,
//                     color: Colors.grey.withOpacity(0.5),
//                   ),
//                   subtitle: Text(
//                     '${accountDetail[statementDetail[index]][i]['transation']}',
//                     style: TextStyle(color: Colors.blueGrey),
//                   ),
//                   trailing: Text(
//                     '${NumberFormat("###.00#").format(double.parse(accountDetail[statementDetail[index]][i]['amount']))} \$',
//                     style: TextStyle(
//                         color: Colors.deepOrange, fontWeight: FontWeight.bold),
//                   ),
//                   onTap: () {
//                     accountPopup(accountDetail[statementDetail[index]][i]['id']
//                         .toString());
//                   },
//                 );
//               },
//             ));
//         //   ListTile(
//         //   leading: Icon(
//         //     Icons.account_balance_wallet,
//         //     color: Colors.grey.withOpacity(0.5),
//         //   ),
//         //   title: Text(
//         //     "${accountDetail[statementDetail[index]][i]['note']}",
//         //     style: TextStyle(color: Colors.black, fontSize: 16),
//         //   ),
//         //   isThreeLine: true,
//         //   subtitle: Text(
//         //     'Balance : ${accountDetail[statementDetail[index]][i]['balance']} \n${accountDetail[statementDetail[index]][i]['transation']}',
//         //     style: TextStyle(color: Colors.grey, fontSize: 12),
//         //   ),
//         //   trailing: Text(
//         //     '${accountDetail[statementDetail[index]][i]['amount']}USD',
//         //     style: TextStyle(
//         //         color: Colors.redAccent, fontWeight: FontWeight.bold),
//         //   ),
//         //   tileColor: Colors.white,
//         //   dense: true,
//         //   // tileColor: Colors.white,
//         // );
//       },
//     );
//   }

//   fetchData() async {
//     await FetchingData.getData('api/get-account-statement-master', {
//       "Accept": "application/json",
//       "Authorization": "Bearer $accessToken",
//     }).then((value) {
//       var jsonData = json.decode(value.body);
//       if (value.statusCode == 200) {
//         setState(() {
//           accountBalance = jsonData;
//         });
//       }
//     });
//     await FetchingData.getData('api/get-account-statement-detail', {
//       "Accept": "application/json",
//       "Authorization": "Bearer $accessToken",
//     }).then((value) {
//       var jsonData = json.decode(value.body);
//       if (value.statusCode == 200) {
//         late List list;
//         setState(() {
//           list = jsonData;
//         });
//         accountDetail = list.groupListsBy((obj) =>
//             DateFormat("yyyy-MM-dd").format(DateTime.parse(obj['date'])));
//         statementDetail = accountDetail.entries
//             .map((entry) => "${entry.key}")
//             .toList()
//           ..sort((a, b) => b.compareTo(a));
//       }
//     });
//     setState(() {
//       isLoad = false;
//     });
//   }

//   Future<void> accountPopup(String id) async {
//     DialogLoading.showLoadingDialog(context);
//     await FetchingData.getData("api/get-account-statement-popup/$id", {
//       "Accept": "application/json",
//       "Authorization": "Bearer $accessToken"
//     }).then((value) async {
//       if (value.statusCode == 200) {
//         var jsonData = jsonDecode(value.body);
//         setState(() {
//           statementPopup = jsonData;
//         });
//         Navigator.pop(context);
//         showAlertDialog(context, id);
//       }
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {
//       accessToken = loginData['access_token'];
//     });
//     fetchData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: ColorUtils.bgColor,
//         appBar: new AppBar(
//           elevation: 0,
//           leading: IconButton(
//             icon: BackIcon(),
//             alignment: Alignment.centerLeft,
//             tooltip: 'Back',
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Text("Account"),
//           backgroundColor: ColorUtils.appBarColor,
//         ),
//         body: isLoad
//               ? Center(
//                   child: CircularProgressIndicator(
//                   strokeWidth: 1,
//                 ))
//               : accountBalance['01'] == "0"
//                   ? Center(child: Text('Account not valid!'))
//                   : Column(
//                       children: [headerForm(), Flexible(child: contentForm())],
//                     ),
//         );
//   }
// }