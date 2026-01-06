import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_concepts/screens/screen1.dart';

final futureProvider = FutureProvider<String>((ref) async {
  await Future.delayed(Duration(seconds: 2));

  if (false) {
    log("Exception Occurred!");
    throw Exception("Exception Occurred!");
  }

  return "Hello World!";
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.read(titleProvider);
    final futureProvider_ = ref.watch(futureProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        foregroundColor: Colors.black87,
        backgroundColor: Colors.blue.shade100,
      ),
      body: Center(
        child: futureProvider_.when(
          skipLoadingOnRefresh: false,
          data: (value) => Text(
            value,
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.w600,
              color: Colors.indigo,
            ),
          ),
          error: (e, stackTrace) => Text(
            e.toString(),
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          loading: () => CircularProgressIndicator(color: Colors.green),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.invalidate(futureProvider);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
