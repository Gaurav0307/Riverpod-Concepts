import '../models/item.dart';

class ItemState {
  final List<Item> allItems;
  final List<Item> filteredItems;
  final String search;

  const ItemState({
    required this.allItems,
    required this.filteredItems,
    required this.search,
  });

  ItemState copyWith({
    List<Item>? allItems,
    List<Item>? filteredItems,
    String? search,
  }) {
    return ItemState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      search: search ?? this.search,
    );
  }
}
