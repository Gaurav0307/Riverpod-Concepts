import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Provider (Read-Only Provider)
/// - Used for providing constant values, services, or pure functions
/// - Doesn't change over time (immutable)
/// - Rebuilt only when the provider itself changes
final titleProvider = Provider<String>((ref) => 'Riverpod Concepts');

/// StateProvider (Mutable State)
/// - Used for simple state management (like counters, toggles, enums)
/// - Provides a simple way to expose a mutable state
/// - Automatically rebuilds widgets that depend on it when the state changes
/// - Use .notifier to access the StateController for state modifications
final counterProvider = StateProvider<int>((ref) => 0);

/// A widget that demonstrates Riverpod state management
///
/// ConsumerWidget is a StatelessWidget that can read providers
/// It receives a `WidgetRef` object in its build method
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using ref.read to access the titleProvider once (not listening to changes)
    // This is efficient for values that don't change or when you only need them once
    final title = ref.read(titleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        foregroundColor: Colors.black87,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Consumer widget allows rebuilding only specific parts of the widget tree
          // when the watched providers change
          Consumer(
            builder: (context, ref, child) {
              // Using ref.watch to listen to counterProvider
              // The widget will rebuild whenever the counter changes
              final counter = ref.watch(counterProvider);
              return Text(
                '$counter',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Modifying state using .notifier and .state
                  // This will trigger a rebuild of widgets watching counterProvider
                  ref.read(counterProvider.notifier).state--;
                },
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
              FloatingActionButton(
                onPressed: () {
                  // Alternative way to update state using the update method
                  // This is equivalent to the decrement operation above
                  ref.read(counterProvider.notifier).update((state) => state++);
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
