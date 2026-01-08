import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_concepts/screens/screen1.dart';

final streamProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(Duration(seconds: 1), (_) => DateTime.now());
});

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
      ),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final streamProvider_ = ref.watch(streamProvider);

            return streamProvider_.when(
              skipLoadingOnRefresh: false,
              data: (value) => Text(
                "${DateFormat('dd MMMM yyyy').format(value)}\n${DateFormat('hh:mm:ss a').format(value)}",
                textAlign: TextAlign.center,
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
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.invalidate(streamProvider);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
