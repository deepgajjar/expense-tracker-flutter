import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_expense_tracker/screens/add_transaction_screen.dart';
import 'package:my_expense_tracker/screens/all_transactions_screen.dart';
import 'package:my_expense_tracker/screens/chart_screen.dart';
import 'package:my_expense_tracker/widgets/income_expense.dart';
import 'package:my_expense_tracker/widgets/placeholder.dart';

import 'backend/controllers/home_controller.dart';
import 'backend/controllers/theme_controller.dart';
import 'data/colors.dart';
import 'models/currency.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.put(HomeController());

  final _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: _appBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 12.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Balance',
                    style: TextStyle(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w400,
                      color: _themeController.color,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_homeController.selectedCurrency.symbol} ${_homeController.totalBalance.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w700,
                      color: _themeController.color,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              //income and expense row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IncomeExpence(
                    isIncome: true,
                    symbol: _homeController.selectedCurrency.symbol,
                    amount: _homeController.totalIncome.value,
                  ),
                  IncomeExpence(
                    isIncome: false,
                    symbol: _homeController.selectedCurrency.symbol,
                    amount: _homeController.totalExpense.value,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .04.h,
              ),
              //today section
              _homeController.myTransactions.isEmpty
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Center(
                              child: IconButton(
                                  onPressed: () => _showDatePicker(context),
                                  icon: Icon(
                                    Icons.calendar_month,
                                    color: _themeController.color,
                                  ))),
                        ),
                        title: Text(
                          _homeController.selectedDate.day == DateTime.now().day
                              ? 'Today'
                              : DateFormat.yMd()
                                  .format(_homeController.selectedDate),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: _themeController.color,
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              _homeController.totalForSelectedDate < 0
                                  ? 'You spent'
                                  : 'You earned',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: _themeController.color,
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              '${_homeController.selectedCurrency.symbol} ${_homeController.totalForSelectedDate.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: _themeController.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                   PlaceholderInfo(),
              _homeController.myTransactions.isNotEmpty
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: GestureDetector(
                        onTap: () => Get.to(() => AllTransactionsScreen()),
                        child: Text(
                          'Show all transactions',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () async {
            await Get.to(() => AddTransactionScreen());
            _homeController.getTransactions();
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      );
    });
  }

  _showDatePicker(BuildContext context) async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2012),
        initialDate: DateTime.now(),
        lastDate: DateTime(2122));
    if (pickerDate != null) {
      _homeController.updateSelectedDate(pickerDate);
    }
  }

  AppBar _appBar() {
    print("mode in _appBar ${Get.isDarkMode}");
    return AppBar(
      leading: IconButton(
        onPressed: () async {
          _themeController.switchTheme(_themeController.key == 'isDarkMode'?'isLightMode':'isDarkMode');
        },
        icon: Icon(Get.isDarkMode ? Icons.nightlight : Icons.wb_sunny),
        color: _themeController.color,
      ),
      actions: [
        IconButton(
          onPressed: () => Get.to(() => ChartScreen()),
          icon: Icon(
            Icons.bar_chart,
            size: 27.sp,
            color: _themeController.color,
          ),
        ),
        Row(
          children: [
            Text(
              _homeController.selectedCurrency.currency,
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
                  items: Currency.currencies
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item.currency,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    _homeController.updateSelectedCurrency((val as Currency));
                  },
                  itemHeight: 30.h,
                  dropdownPadding: EdgeInsets.all(4.h),
                  dropdownWidth: 125.w,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
