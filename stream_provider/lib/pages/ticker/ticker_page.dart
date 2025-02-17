import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_provider/pages/ticker/ticker_provider.dart';

class TickerPage extends ConsumerWidget {
  const TickerPage({super.key});

  String zeroPaddedTwoDigits(double ticks) {
    return ticks.floor().toString().padLeft(2, '0');
  }

  String formatTimer(int value) {
    final minutes = zeroPaddedTwoDigits((value / 60) % 60);
    final seconds = zeroPaddedTwoDigits(value % 60);

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickeValue = ref.watch(tickerProvider);
    print(tickeValue);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticker'),
      ),
      body: Center(
        child: tickeValue.when(
            data: (tickerValue) => Text(
                  formatTimer(tickerValue),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
            error: (e, st) => Text(
                  e.toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
            loading: () => CircularProgressIndicator()),
      ),
    );
  }
}
