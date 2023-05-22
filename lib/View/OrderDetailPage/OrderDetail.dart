import 'package:flutter/material.dart';
import 'package:ledger_book/Common/Define.dart';
import 'package:ledger_book/Controller/Controller.dart';
import 'package:ledger_book/Localization/LocalizationString.dart';
import 'package:ledger_book/Model/CheckboxModel.dart';
import 'package:ledger_book/Model/ItemModel.dart';
import 'package:ledger_book/Model/OrderModel.dart';
import 'package:ledger_book/Model/SubItemModel.dart';
import 'package:ledger_book/View/Common/CommonListview.dart';
import 'package:ledger_book/View/Common/CommonMaterial.dart';
import 'package:ledger_book/View/Common/CommonText.dart';
import 'package:ledger_book/View/Common/Footer.dart';
import 'package:ledger_book/View/Common/SimpleDialog.dart';
import 'package:ledger_book/View/Common/MyFlutterIcons.dart';
import 'package:ledger_book/View/ItemDetailPage/ItemDetail.dart';
import 'package:ledger_book/View/OrderDetailPage/CheckboxItemTile.dart';
import 'package:ledger_book/View/OrderDetailPage/ItemTile.dart';
import 'package:ledger_book/View/PageRouting.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool editMode = false;
  final List<CheckboxModel<ItemModel>> listModel = [];

  void _initListModel({List<int> checkedList = const []}) {
    listModel.clear();
    if (AppData().currentOrder == null) return;
    for (int i = 0; i < AppData().currentOrder!.listItem.length; i++) {
      listModel.add(CheckboxModel<ItemModel>(
          model: AppData().currentOrder!.listItem[i],
          checked: checkedList.contains(i)));
    }
  }

  void _switchMode(bool mode, {List<int> checkedList = const []}) {
    setState(() {
      _initListModel(checkedList: checkedList);
      editMode = mode;
    });
  }

  void _sortOrder(int Function(ItemModel, ItemModel) compare) {
    OrderModel order = AppData().currentOrder ?? OrderModel();
    List<ItemModel> newItemList = AppData().currentOrder?.listItem ?? [];
    newItemList.sort(compare);
    order.listItem = newItemList;
    Controller().editOrder(order);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _initListModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: editMode
              ? TextFormField(
                  decoration: const InputDecoration(border: InputBorder.none),
                  initialValue: AppData().currentOrder?.title ?? '',
                  style: AppBarTitleTextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  cursorColor: Theme.of(context).appBarTheme.foregroundColor,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    OrderModel newModel =
                        AppData().currentOrder ?? OrderModel();
                    newModel.title = value;
                    Controller().editOrder(newModel);
                  },
                )
              : AppBarTitleText(
                  AppData().currentOrder?.title ?? LocalizationString.Error),
        ),
        leading: BackButton(
          onPressed: editMode
              ? () => _switchMode(false)
              : () => Navigator.pop(context),
        ),
        actions: editMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BasicDialog(
                        title:
                            TitleText(LocalizationString.Confirm_Delete_Items),
                        successWidget: BasicText(LocalizationString.Confirm),
                        onSuccess: () async {
                          Navigator.pop(context);
                          for (int i = 0; i < listModel.length; i++) {
                            if (listModel[i].checked) {
                              await Controller().deleteItem(i);
                            }
                          }
                          _switchMode(false);
                        },
                        onCancel: () => Navigator.pop(context),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _switchMode(false);
                  },
                ),
              ]
            : [
                BaseIconButton(
                  width: 36,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final newModel = ItemModel(data: SubItemModel());
                    PageRouting.routeWithConditionalCallback(
                      context,
                      builder: (context) => ItemDetail(model: newModel),
                      actionCallback: {
                        PageAction.save: () async {
                          await Controller().addItem(newModel);
                          _switchMode(false);
                        },
                      },
                    );
                  },
                ),
                BaseIconButton(
                  width: 36,
                  icon: const Icon(Icons.edit_note),
                  onPressed: () => _switchMode(true),
                ),
                BaseIconButton(
                  width: 36,
                  icon: const Icon(Icons.delete),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BasicDialog(
                        title:
                            TitleText(LocalizationString.Confirm_Delete_Order),
                        successWidget: BasicText(LocalizationString.Confirm),
                        onSuccess: () async {
                          Navigator.pop(context);
                          Navigator.pop(context, PageAction.delete);
                        },
                        onCancel: () => Navigator.pop(context),
                      );
                    },
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) {
                    return {
                      [
                        SortType.byDateAscending,
                        LocalizationString.Sort_By_Date_Ascending,
                        BasicIcon(MyFlutterIcons.sort_alt_up)
                      ],
                      [
                        SortType.byDateDescending,
                        LocalizationString.Sort_By_Date_Descending,
                        BasicIcon(MyFlutterIcons.sort_alt_down)
                      ],
                      [
                        SortType.byPriceAscending,
                        LocalizationString.Sort_By_Price_Ascending,
                        BasicIcon(MyFlutterIcons.sort_number_up)
                      ],
                      [
                        SortType.byPriceDescending,
                        LocalizationString.Sort_By_Price_Descending,
                        BasicIcon(MyFlutterIcons.sort_number_down)
                      ],
                      [
                        SortType.byNameAscending,
                        LocalizationString.Sort_By_Title_Ascending,
                        BasicIcon(MyFlutterIcons.sort_name_up)
                      ],
                      [
                        SortType.byNameDescending,
                        LocalizationString.Sort_By_Title_Descending,
                        BasicIcon(MyFlutterIcons.sort_name_down)
                      ],
                    }.map((List<dynamic> choice) {
                      return PopupMenuItem<SortType>(
                        value: choice[0],
                        child: Row(
                          children: [
                            Expanded(child: BasicText(choice[1])),
                            choice[2],
                          ],
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (value) {
                    print(value);
                    switch (value) {
                      case SortType.none:
                        break;
                      case SortType.byDateAscending:
                        _sortOrder((a, b) {
                          if (a.dateTime.isBefore(b.dateTime)) {
                            return -1;
                          } else if (a.dateTime == b.dateTime) {
                            return 0;
                          }
                          return 1;
                        });
                        break;
                      case SortType.byDateDescending:
                        _sortOrder((a, b) {
                          if (a.dateTime.isAfter(b.dateTime)) {
                            return -1;
                          } else if (a.dateTime == b.dateTime) {
                            return 0;
                          }
                          return 1;
                        });
                        break;
                      case SortType.byPriceAscending:
                        _sortOrder((a, b) {
                          if (a.totalPrice < b.totalPrice) {
                            return -1;
                          } else if (a.totalPrice == b.totalPrice) {
                            return 0;
                          }
                          return 1;
                        });
                        break;
                      case SortType.byPriceDescending:
                        _sortOrder((a, b) {
                          if (a.totalPrice > b.totalPrice) {
                            return -1;
                          } else if (a.totalPrice == b.totalPrice) {
                            return 0;
                          }
                          return 1;
                        });
                        break;
                      case SortType.byNameAscending:
                        _sortOrder(
                            (a, b) => a.data.title.compareTo(b.data.title));
                        break;
                      case SortType.byNameDescending:
                        _sortOrder(
                                (a, b) => b.data.title.compareTo(a.data.title));
                        break;
                    }
                    //   OrderModel order = AppData().currentOrder ?? OrderModel();
                    //   List<ItemModel> data =
                    //       AppData().currentOrder?.listItem ?? [];
                    //   data.sort((a, b) {
                    //     if (a.dateTime.isBefore(b.dateTime)) {
                    //       return -1;
                    //     } else if (a.dateTime == b.dateTime) {
                    //       return 0;
                    //     }
                    //     return 1;
                    //   });
                    //   order.listItem = data;
                    //   Controller().editOrder(order);
                    //   setState(() {});
                  },
                )
              ],
      ),
      body: Column(
        children: [
          Expanded(
            child: editMode
                ? BaseListView(
                    itemCount: listModel.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxItemTile(
                          model: listModel[index], setState: setState);
                    },
                  )
                : BaseListView(
                    itemCount: AppData().currentOrder?.listItem.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemTile(
                        context,
                        index: index,
                        callback: () => _switchMode(false),
                        onLongPress: () =>
                            _switchMode(true, checkedList: [index]),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: PriceFooter(
        value: AppData().currentOrder?.totalPrice ?? 0,
      ),
    );
  }
}
