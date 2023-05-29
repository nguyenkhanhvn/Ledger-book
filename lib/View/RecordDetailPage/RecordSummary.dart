import 'package:flutter/material.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/View/Common/BaseTabBar.dart';
import 'package:ledger_book/View/Common/CommonText.dart';

class RecordSummary extends DefaultTabController {
  RecordSummary({super.key, required RecordModel record})
      : super(
          length: 2,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: BaseTabBar(
                    children: [
                      Center(
                        child: BasicText(LocalizationString.Brief),
                      ),
                      Center(
                        child: BasicText(LocalizationString.Detail),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView (
                        child: BasicText(
                            AppData().exportManager.exportRecordString(record)),
                      ),
                      SingleChildScrollView (
                        child: BasicText(AppData()
                            .exportManager
                            .exportRecordString(record, detail: true)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
}
