import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../backend/controllers/add_transaction_controller.dart';
import '../backend/controllers/home_controller.dart';
import '../backend/controllers/theme_controller.dart';
import '../widgets/transaction_tile.dart';
import 'edit_transaction_screen.dart';

class AllTransactionsScreen extends StatelessWidget {
  AllTransactionsScreen({Key? key}) : super(key: key);
  final HomeController _homeController = Get.find();
  final AddTransactionController _addTransactionController =
      Get.put(AddTransactionController());
  final ThemeController _themeController = Get.find();

  final List<String> _transactionTypes = ['Income', 'Expense'];
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      print("_homeController.myTransactions ==>> inside all transation ==>> ${_homeController.myTransactions}");
      return Scaffold(
        appBar: _appBar(),
        body: ListView.builder(
          itemCount: _homeController.myTransactions.length,
          itemBuilder: (context, i) {
            final transaction = _homeController.myTransactions[i];
            final text =
                '${_homeController.selectedCurrency.symbol}${transaction.amount}';

            if (transaction.type == _addTransactionController.transactionType) {
              final bool isIncome = transaction.type == 'Income' ? true : false;
              final formatAmount = isIncome ? '+ $text' : '- $text';
              return GestureDetector(
                onTap: () async {
                  await Get.to(() => EditTransactionScreen(tm: transaction));
                  _homeController.getTransactions();
                },
                child: TransactionTile(
                    transaction: transaction,
                    formatAmount: formatAmount,
                    isIncome: isIncome),
              );
            }
            return SizedBox();
          },
        ),
      );
    });
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        'All Transactions',
        style: TextStyle(color: _themeController.color),
      ),
      leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: _themeController.color)),
      actions: [
        Row(
          children: [
            Text(
              _addTransactionController.transactionType.isEmpty
                  ? _transactionTypes[0]
                  : _addTransactionController.transactionType,
              style: TextStyle(
                fontSize: 14.sp,
                color: _themeController.color,
              ),
            ),
            SizedBox(
              width: 40.w,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customItemsHeight: 10.h,
                  customButton: Icon(
                    Icons.keyboard_arrow_down,
                    color: _themeController.color,
                  ),
                  items: _transactionTypes
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    _addTransactionController
                        .changeTransactionType((val as String));
                  },
                  itemHeight: 30.h,
                  dropdownPadding: EdgeInsets.all(4.h),
                  dropdownWidth: 125.w,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
