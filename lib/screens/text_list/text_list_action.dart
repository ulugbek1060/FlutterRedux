import 'package:flutter/foundation.dart';

enum ItemFilter { all, longText, shortText }

@immutable
abstract class Action {
  const Action();
}

@immutable
abstract class ItemAction extends Action {
  final String item;
  const ItemAction(this.item);
}

@immutable
class AddItemAction extends ItemAction {
  const AddItemAction({required String item}) : super(item);
}

@immutable
class RemoveItemAction extends ItemAction {
  const RemoveItemAction({required String item}) : super(item);
}

@immutable
class ChangeFilterTypeAction extends Action {
  final ItemFilter itemFilter;
  const ChangeFilterTypeAction({required this.itemFilter});
}
