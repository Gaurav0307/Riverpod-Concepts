class Item {
  final int id;
  final String name;
  final bool isFavourite;

  const Item({required this.id, required this.name, required this.isFavourite});

  Item copyWith({int? id, String? name, bool? isFavourite}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
