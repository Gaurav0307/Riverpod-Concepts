import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_concepts/screens/screen1.dart';

/// StateProvider with a complex state object (AppState)
/// - Manages multiple related pieces of state (slider value and enabled state)
/// - Uses a custom state class with copyWith pattern for immutable updates
/// - Initial state sets slider to 0.1 and enabled to true
final appStateProvider = StateProvider<AppState>(
  (Ref ref) => AppState(slider: 0.1, enabled: true),
);

/// A demo screen showing advanced Riverpod state management
/// - Demonstrates StateProvider with complex state
/// - Shows how to use select() for optimized rebuilds
/// - Implements a toggle switch and slider that update the same state object
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using ref.read for one-time access to titleProvider
    // This won't cause rebuilds when titleProvider changes
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
          // First Consumer widget - Only rebuilds when 'enabled' changes
          Consumer(
            builder: (context, ref, child) {
              // Debug print to track rebuilds
              debugPrint("Rebuild-1 - Switch widget");

              // final enabled = ref.watch(appStateProvider).enabled;

              // Using select to only listen to the 'enabled' property
              // This prevents unnecessary rebuilds when other properties change
              final enabled = ref.watch(
                appStateProvider.select((state) => state.enabled),
              );

              return Switch(
                value: enabled,
                onChanged: (value) {
                  // Get the StateController for appStateProvider
                  final appStateController = ref.read(
                    appStateProvider.notifier,
                  );

                  // Update state immutably using copyWith
                  appStateController.state = appStateController.state.copyWith(
                    enabled: value,
                  );
                },
                activeThumbColor: Colors.green,
              );
            },
          ),

          // Second Consumer widget - Only rebuilds when 'slider' changes
          Consumer(
            builder: (context, ref, child) {
              // Debug print to track rebuilds
              debugPrint("Rebuild-2 - Slider widget");

              // final slider = ref.watch(appStateProvider).slider;

              // Using select to only listen to the 'slider' property
              // This is more efficient than watching the entire state object
              final slider = ref.watch(
                appStateProvider.select((state) => state.slider),
              );

              return Column(
                children: [
                  // Visual representation of the slider value
                  Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.red.withValues(alpha: slider),
                    ),
                  ),
                  SizedBox(height: 20.0),

                  // Slider control
                  Slider(
                    value: slider,
                    onChanged: (value) {
                      // Get the StateController for appStateProvider
                      final appStateController = ref.read(
                        appStateProvider.notifier,
                      );

                      // Update state immutably using copyWith
                      appStateController.state = appStateController.state
                          .copyWith(slider: value);
                    },
                    activeColor: Colors.black54,
                    thumbColor: Colors.red,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Immutable state class that holds the application state
/// - Uses final fields to ensure immutability
/// - Implements copyWith pattern for state updates
class AppState {
  final double slider; // Value between 0.0 and 1.0 for the slider position
  final bool enabled; // Toggle state for the switch

  const AppState({required this.slider, required this.enabled});

  /// Creates a new instance of AppState with updated fields
  /// - Only updates the fields that are provided
  /// - Maintains immutability by returning a new instance
  AppState copyWith({double? slider, bool? enabled}) {
    return AppState(
      slider: slider ?? this.slider,
      enabled: enabled ?? this.enabled,
    );
  }
}
