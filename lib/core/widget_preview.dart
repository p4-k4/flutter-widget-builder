import 'package:flutter/material.dart';
import 'package:flutter_widget_builder/core/app_bar.dart';
import 'package:flutter_widget_builder/core/pubsub.dart';

class WidgetPreviewCard extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext) builder;
  final VoidCallback onTap;

  const WidgetPreviewCard({
    super.key,
    required this.title,
    required this.builder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                child: Center(
                  child: Sub((_) => builder(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetPreviewPage extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext) builder;

  const WidgetPreviewPage({
    super.key,
    required this.title,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Sub((_) => builder(context));
  }
}
