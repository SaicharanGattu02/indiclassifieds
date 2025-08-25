import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:indiclassifieds/Components/CutomAppBar.dart';
import 'package:indiclassifieds/data/cubit/Transections/transactions_cubit.dart';
import 'package:indiclassifieds/data/cubit/Transections/transactions_states.dart';
import 'package:indiclassifieds/model/TransectionHistoryModel.dart';
import '../../theme/ThemeHelper.dart';
import '../../widgets/CommonLoader.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().getTransactions();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<TransactionCubit>().getMoreTransactions();
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.backgroundColor(context),
      appBar: CustomAppBar1(title: "Transaction History", actions: []),
      body: BlocBuilder<TransactionCubit, TransactionsStates>(
        builder: (context, state) {
          if (state is TransactionsLoading) {
            return const Center(child: DottedProgressWithLogo());
          } else if (state is TransactionsFailure) {
            return Center(child: Text(state.error));
          } else if (state is TransactionsLoaded ||
              state is TransactionsLoadingMore) {
            final model = (state as dynamic).transactionModel;
            final rows = model.data?.formattedRows ?? [];
            final hasNextPage = (state as dynamic).hasNextPage;

            if (rows.isEmpty) {
              return const Center(child: Text("No transactions found"));
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        if (index == rows.length) {
                          return hasNextPage
                              ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : const SizedBox.shrink();
                        }
                        final FormattedRows tx = rows[index];
                        if (rows.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/nodata/no_data.png',
                                  width: MediaQuery.of(context).size.width * 0.22,
                                  height: MediaQuery.of(context).size.height * 0.12,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No Transactions Found!',
                                  style: TextStyle(
                                    color: ThemeHelper.textColor(context),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        final bool isSuccess =
                            (tx.paymentStatus ?? "").toLowerCase() == "success";

                        return Card(
                          color: ThemeHelper.cardColor(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            title: Text(
                              tx.planName ?? "Unknown Plan",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ThemeHelper.textColor(context),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Text(
                                  "Amount: \₹${tx.amountPaid ?? 0}",
                                  style: TextStyle(fontWeight: FontWeight.w700,
                                    color: ThemeHelper.textColor(context)
                                        .withOpacity(0.8),
                                  ),
                                ),
                                if (tx.paidOn != null)
                                  Text(
                                    "Paid on: ${tx.paidOn!.split("T").first}",
                                    style: TextStyle(
                                      color: ThemeHelper.textColor(context)
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                if (tx.startDate != null && tx.endDate != null)
                                  Text(
                                    "Valid: ${tx.startDate} → ${tx.endDate}",
                                    style: TextStyle(
                                      color: ThemeHelper.textColor(context)
                                          .withOpacity(0.6),
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSuccess
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                (tx.paymentStatus ?? "").toUpperCase(),
                                style: TextStyle(
                                  color:
                                  isSuccess ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: rows.length + 1,
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
