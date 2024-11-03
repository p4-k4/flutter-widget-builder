import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_builder/widgets/widget_catalog.dart';
import 'package:flutter_widget_builder/core/widget_preview.dart';
import 'package:flutter_widget_builder/core/theme_state.dart';
import 'package:flutter_widget_builder/core/pubsub.dart';
import 'package:flutter_widget_builder/core/service_locator.dart';
import 'package:flutter_widget_builder/core/app_bar.dart';

void main() {
  setupServiceLocator();
  runApp(const WidgetBuilderApp());
}

class WidgetBuilderApp extends StatelessWidget {
  const WidgetBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sub(
      (_) => MaterialApp(
        title: 'Flutter Widget Builder',
        themeMode: sl<ThemeState>().mode,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        home: const WidgetGallery(),
      ),
    );
  }
}

class WidgetGallery extends StatefulWidget {
  const WidgetGallery({super.key});

  @override
  State<WidgetGallery> createState() => _WidgetGalleryState();
}

class _WidgetGalleryState extends State<WidgetGallery> {
  SortOrder? _sortOrder;
  String _searchQuery = '';

  List<CatalogItem> get _filteredAndSortedWidgets {
    var widgets = List<CatalogItem>.from(widgetCatalog);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      widgets = widgets
          .where((w) =>
              w.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              w.tags.any((tag) =>
                  tag.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();
    }

    // Apply sorting
    if (_sortOrder != null) {
      widgets.sort((a, b) => _sortOrder == SortOrder.aToZ
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyT, control: true): () {
          sl<ThemeState>().toggleTheme();
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: GlobalAppBar(
            title: 'Widget Gallery',
            showSort: true,
            currentSort: _sortOrder,
            onSortChanged: (order) => setState(() => _sortOrder = order),
            onSearchChanged: (query) => setState(() => _searchQuery = query),
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _filteredAndSortedWidgets.length,
            itemBuilder: (context, index) {
              final widget = _filteredAndSortedWidgets[index];
              return WidgetPreviewCard(
                title: widget.name,
                builder: widget.builder,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CallbackShortcuts(
                        bindings: {
                          const SingleActivator(LogicalKeyboardKey.escape): () {
                            Navigator.of(context).pop();
                          },
                        },
                        child: Focus(
                          autofocus: true,
                          child: Scaffold(
                            appBar: GlobalAppBar(title: widget.name),
                            body: WidgetPreviewPage(
                              title: widget.name,
                              builder: widget.builder,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
