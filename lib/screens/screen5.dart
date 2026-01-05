import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_concepts/screens/screen1.dart';

import '../providers/item_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.read(titleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        foregroundColor: Colors.black87,
        backgroundColor: Colors.blue.shade100,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("All"),
                  onTap: () {
                    final itemController = ref.read(
                      itemStateNotifierProvider.notifier,
                    );

                    itemController.showAllItems();
                  },
                ),
                PopupMenuItem(
                  child: Text("Favourite"),
                  onTap: () {
                    final itemController = ref.read(
                      itemStateNotifierProvider.notifier,
                    );

                    itemController.showFavouriteItems();
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.black87),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black87),
                prefixIconColor: Colors.black87,
              ),
              onChanged: (value) {
                final itemController = ref.read(
                  itemStateNotifierProvider.notifier,
                );

                itemController.search(value);
              },
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final itemProvider = ref.watch(itemStateNotifierProvider);

                return ListView.builder(
                  itemCount: itemProvider.filteredItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: IconButton(
                        onPressed: () {
                          final itemController = ref.read(
                            itemStateNotifierProvider.notifier,
                          );

                          itemController.toggleFavourite(
                            itemProvider.filteredItems[index].id,
                          );
                        },
                        icon: Icon(
                          itemProvider.filteredItems[index].isFavourite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: itemProvider.filteredItems[index].isFavourite
                              ? Colors.redAccent
                              : Colors.grey,
                        ),
                      ),
                      title: Text(
                        itemProvider.filteredItems[index].name,
                        style: TextStyle(),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          final itemController = ref.read(
                            itemStateNotifierProvider.notifier,
                          );

                          itemController.removeItem(
                            itemProvider.filteredItems[index].id,
                          );
                        },
                        icon: Icon(Icons.delete, color: Colors.blue),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final todoController = ref.read(itemStateNotifierProvider.notifier);

          todoController.addItem(
            name: "New Item - ${DateTime.now().millisecondsSinceEpoch}",
          );
        },
      ),
    );
  }
}
