import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_concepts/screen1.dart';

/// A demo screen showing advanced Riverpod state management
/// - Demonstrates State Notifier Provider with complex state
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
                appStateNotifierProvider.select((state) => state.enabled),
              );

              return Switch(
                value: enabled,
                onChanged: (value) {
                  // Get the StateController for appStateProvider
                  final appStateController = ref.read(
                    appStateNotifierProvider.notifier,
                  );

                  appStateController.toggleSwitch(value);
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
                appStateNotifierProvider.select((state) => state.slider),
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
                        appStateNotifierProvider.notifier,
                      );

                      appStateController.updateSlider(value);
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

/// A Riverpod StateNotifierProvider that manages the application state.
/// - Manages an instance of AppStateNotifier
/// - Automatically handles the notifier's lifecycle
/// - Provides a way to access and modify the state throughout the widget tree
/// - Uses generics to specify the notifier type (AppStateNotifier) and state type (AppState)
final appStateNotifierProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((Ref ref) {
      // Create and return a new instance of AppStateNotifier
      // This will be called only once and the instance will be kept alive
      // as long as there are listeners
      return AppStateNotifier();
    });

/// A Riverpod StateNotifier that manages the application state.
/// - Holds the current state (AppState)
/// - Provides methods to update the state in an immutable way
/// - Notifies listeners when the state changes
class AppStateNotifier extends StateNotifier<AppState> {
  /// Initialize the notifier with default state
  /// - slider: Initial value of 0.1 (10%)
  /// - enabled: Initially set to false
  AppStateNotifier() : super(AppState(slider: 0.1, enabled: false));

  /// Updates the slider value in the state
  /// - Creates a new state with the updated slider value
  /// - Triggers a rebuild of widgets that depend on this state
  void updateSlider(double slider) {
    // Using copyWith pattern to create a new state with updated slider value
    // This maintains immutability of the state
    state = state.copyWith(slider: slider);
  }

  /// Toggles the enabled state
  /// - Creates a new state with the updated enabled value
  /// - Triggers a rebuild of widgets that depend on this state
  void toggleSwitch(bool enabled) {
    // Using copyWith pattern to create a new state with updated enabled value
    // This maintains immutability of the state
    state = state.copyWith(enabled: enabled);
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
