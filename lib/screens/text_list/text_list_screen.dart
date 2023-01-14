import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_hooks/flutter_hooks.dart' as hooks;

import 'text_list_action.dart' as act;

extension AddRemoveItems<T> on Iterable<T> {
  Iterable<T> operator +(T other) => followedBy([other]);
  Iterable<T> operator -(T other) => where((e) => e != other);
}

@immutable
class State {
  final Iterable<String> items;
  final act.ItemFilter itemFilter;

  const State({
    required this.items,
    required this.itemFilter,
  });

  Iterable<String> get getFilteredItems {
    switch (itemFilter) {
      case act.ItemFilter.all:
        return items;
      case act.ItemFilter.longText:
        return items.where((element) => element.length >= 10);
      case act.ItemFilter.shortText:
        return items.where((element) => element.length <= 3);
    }
  }
}

Iterable<String> addItemReducer(
  Iterable<String> oldItems,
  act.AddItemAction action,
) =>
    oldItems + action.item;

Iterable<String> removeItemReducer(
  Iterable<String> oldItems,
  act.RemoveItemAction action,
) =>
    oldItems - action.item;

act.ItemFilter itemFilterReducer(State oldState, act.Action action) {
  if (action is act.ChangeFilterTypeAction) {
    return action.itemFilter;
  } else {
    return oldState.itemFilter;
  }
}

Reducer<Iterable<String>> itemReducer = combineReducers<Iterable<String>>([
  TypedReducer<Iterable<String>, act.AddItemAction>(addItemReducer),
  TypedReducer<Iterable<String>, act.RemoveItemAction>(removeItemReducer),
]);

State appStateReducer(State oldState, action) {
  return State(
    items: itemReducer(oldState.items, action),
    itemFilter: itemFilterReducer(oldState, action),
  );
}

class TextListScreen extends hooks.HookWidget {
  const TextListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Store(
      appStateReducer,
      initialState: const State(
        items: [],
        itemFilter: act.ItemFilter.all,
      ),
    );
    final textController = hooks.useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('List'),
      ),
      body: StoreProvider(
        store: store,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    store.dispatch(
                      const act.ChangeFilterTypeAction(
                        itemFilter: act.ItemFilter.all,
                      ),
                    );
                  },
                  child: const Text('All'),
                ),
                TextButton(
                  onPressed: () {
                    store.dispatch(
                      const act.ChangeFilterTypeAction(
                        itemFilter: act.ItemFilter.longText,
                      ),
                    );
                  },
                  child: const Text('Long items'),
                ),
                TextButton(
                  onPressed: () {
                    store.dispatch(
                      const act.ChangeFilterTypeAction(
                        itemFilter: act.ItemFilter.shortText,
                      ),
                    );
                  },
                  child: const Text('Short items'),
                ),
              ],
            ),
            TextField(
              controller: textController,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    final text = textController.text;
                    store.dispatch(act.AddItemAction(item: text));
                    textController.clear();
                  },
                  child: const Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    final text = textController.text;
                    store.dispatch(act.RemoveItemAction(item: text));
                    textController.clear();
                  },
                  child: const Text('Remove'),
                ),
              ],
            ),
            StoreConnector<State, Iterable<String>>(
              converter: (store) => store.state.getFilteredItems,
              builder: (context, items) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(items.elementAt(index)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
