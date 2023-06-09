import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Common/Utils.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/RecordModel.dart';
import 'package:ledger_book/Model/SubItemModel.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/Footer.dart';
import 'package:ledger_book/View/Common/SimpleDialog.dart';
import 'package:ledger_book/View/ItemDetailPage//SubItemField.dart';
import 'package:ledger_book/View/PageRouting.dart';
import 'package:ledger_book/View/SubItemDetailPage/SubItemTile.dart';
import 'package:ledger_book/View/SubItemDetailPage/SubItemDetail.dart';

class ItemDetail extends StatefulWidget {
  final ItemModel model;

  const ItemDetail({super.key, required this.model});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  RecordCategory modelCategory = AppData().currentRecordCategory;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('vi'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        widget.model.dateTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: AppBarTitleText(LocalizationString.Item)),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return BasicDialog(
                title: TitleText(LocalizationString.Confirm_Back),
                successWidget: BasicText(LocalizationString.Confirm),
                onSuccess: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                onCancel: () => Navigator.pop(context),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context, [PageAction.save, modelCategory]);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return BasicDialog(
                  title: TitleText(LocalizationString.Confirm_Delete),
                  successWidget: BasicText(LocalizationString.Confirm),
                  onSuccess: () async {
                    Navigator.pop(context);
                    Navigator.pop(context, [PageAction.delete]);
                  },
                  onCancel: () => Navigator.pop(context),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Scrollbar(
          thickness: 5,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.fromBorderSide(BasicBorderSide(width: 2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<RecordCategory>(
                    value: modelCategory,
                    items: RecordCategory.values
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child:
                                  BasicText(Utils.recordCategoryString(category)),
                            ))
                        .toList(),
                    onChanged: (value) => setState(
                        () => modelCategory = value ?? RecordCategory.expense),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                child: SubItemFieldEdit(
                  model: widget.model.data,
                  setParentState: setState,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BasicIcon(
                        Icons.calendar_month,
                        size: 40,
                      ),
                      BasicText(widget.model.dateTimeString),
                    ],
                  ),
                  onPressed: () => _selectDate(context),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BasicBorderSide(width: 2),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                          child: TitleText(LocalizationString.List_Sub_Item)),
                    ),
                    BaseIconButton(
                      icon: BasicIcon(Icons.add),
                      size: 30,
                      width: 100,
                      onPressed: () {
                        final subItem = SubItemModel();
                        PageRouting.routeWithConditionalCallback(
                          context,
                          builder: (context) => SubItemDetail(
                            model: subItem,
                          ),
                          actionCallback: {
                            PageAction.save: () => setState(
                                () => widget.model.addSubItem(subItem)),
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.model.listSubItem.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < widget.model.listSubItem.length) {
                    return SubItemTile(
                      context,
                      model: widget.model.listSubItem[index],
                      editModelCallback: (newSubItem) => setState(
                          () => widget.model.editSubItem(index, newSubItem)),
                      deleteModelCallback: () =>
                          setState(() => widget.model.removeSubItem(index)),
                    );
                  } else {
                    SubItemModel subItem = SubItemModel();
                    return SubItemFieldTile(
                      context,
                      model: subItem,
                      callback: () {
                        setState(() {
                          widget.model.addSubItem(subItem);
                        });
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PriceFooter(
        title: LocalizationString.Total,
        value: widget.model.totalPrice,
        number: widget.model.listSubItem.length,
        numberSuffix: LocalizationString.Sub_Item,
      ),
    );
  }
}
