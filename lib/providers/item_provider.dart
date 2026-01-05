import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_concepts/models/item.dart';

import 'item_state.dart';

final itemStateNotifierProvider =
    StateNotifierProvider<ItemStateNotifier, ItemState>((ref) {
      return ItemStateNotifier();
    });

class ItemStateNotifier extends StateNotifier<ItemState> {
  ItemStateNotifier()
    : super(ItemState(allItems: [], filteredItems: [], search: ""));

  void addItem({String name = "", bool isFavourite = false}) {
    state = state.copyWith(
      allItems: [
        ...state.allItems,
        Item(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          isFavourite: isFavourite,
        ),
      ],
    );

    _updateFilteredItems(state.allItems);
  }

  void removeItem(int id) {
    state = state.copyWith(
      allItems: state.allItems.where((item) => item.id != id).toList(),
    );

    _updateFilteredItems(state.allItems);
  }

  void toggleFavourite(int id) {
    state = state.copyWith(
      allItems: state.allItems
          .map(
            (item) => item.id == id
                ? item.copyWith(isFavourite: !item.isFavourite)
                : item,
          )
          .toList(),
    );

    _updateFilteredItems(state.allItems);
  }

  void _updateFilteredItems(List<Item> items) {
    state = state.copyWith(filteredItems: items);
  }

  void search(String searchQuery) {
    _updateFilteredItems(
      state.allItems.where((item) {
        return item.name.toLowerCase().contains(searchQuery);
      }).toList(),
    );
  }

  void showAllItems() {
    _updateFilteredItems(state.allItems);
  }

  void showFavouriteItems() {
    _updateFilteredItems(
      state.allItems.where((item) => item.isFavourite == true).toList(),
    );
  }
}
