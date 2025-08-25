// import 'package:flutter/material.dart';
// import 'package:indiclassifieds/Components/CutomAppBar.dart';
// import '../../theme/ThemeHelper.dart';
//
// class TransactionsScreen extends StatefulWidget {
//   const TransactionsScreen({super.key});
//
//   @override
//   State<TransactionsScreen> createState() => _TransactionsScreenState();
// }
//
// class _TransactionsScreenState extends State<TransactionsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ThemeHelper.backgroundColor(context),
//       appBar: CustomAppBar1(title: "Transection History", actions: []),
//       body: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: widget.transactions.length,
//               itemBuilder: (context, index) {
//                 final tx = widget.transactions[index];
//                 final bool isSuccess = tx["payment_status"] == "success";
//
//                 return Card(
//                   color: ThemeHelper.cardColor(context),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   margin: const EdgeInsets.only(bottom: 12),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(12),
//                     title: Text(
//                       tx["plan_name"] ?? "Unknown Plan",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: ThemeHelper.textColor(context),
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 6),
//                         Text(
//                           "Amount: \$${tx["amount_paid"]}",
//                           style: TextStyle(
//                             color: ThemeHelper.textColor(
//                               context,
//                             ).withOpacity(0.8),
//                           ),
//                         ),
//                         Text(
//                           "Paid on: ${tx["paid_on"].toString().split("T").first}",
//                           style: TextStyle(
//                             color: ThemeHelper.textColor(
//                               context,
//                             ).withOpacity(0.6),
//                           ),
//                         ),
//                         if (tx["start_date"] != null && tx["end_date"] != null)
//                           Text(
//                             "Valid: ${tx["start_date"]} → ${tx["end_date"]}",
//                             style: TextStyle(
//                               color: ThemeHelper.textColor(
//                                 context,
//                               ).withOpacity(0.6),
//                             ),
//                           ),
//                       ],
//                     ),
//                     trailing: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isSuccess
//                             ? Colors.green.withOpacity(0.2)
//                             : Colors.orange.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text(
//                         tx["payment_status"].toString().toUpperCase(),
//                         style: TextStyle(
//                           color: isSuccess ? Colors.green : Colors.orange,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
