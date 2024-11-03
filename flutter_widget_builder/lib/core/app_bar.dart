import 'package:flutter/material.dart';
import 'package:flutter_widget_builder/core/theme_state.dart';
import 'package:flutter_widget_builder/core/pubsub.dart';
import 'package:flutter_widget_builder/core/service_locator.dart';

enum SortOrder {
  aToZ,
  zToA;

  String get label => this == SortOrder.aToZ ? 'A to Z' : 'Z to A';
  IconData get icon =>
      this == SortOrder.aToZ ? Icons.arrow_downward : Icons.arrow_upward;
}

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSort;
  final SortOrder? currentSort;
  final ValueChanged<SortOrder>? onSortChanged;
  final ValueChanged<String>? onSearchChanged;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.showSort = false,
    this.currentSort,
    this.onSortChanged,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(title),
          if (onSearchChanged != null) ...[
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search widgets...',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onChanged: onSearchChanged,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (showSort) ...[
          PopupMenuButton<SortOrder>(
            tooltip: 'Sort widgets',
            icon: Icon(currentSort?.icon ?? Icons.sort),
            onSelected: onSortChanged,
            itemBuilder: (context) => [
              for (final order in SortOrder.values)
                PopupMenuItem(
                  value: order,
                  child: Row(
                    children: [
                      Icon(
                        order.icon,
                        color: order == currentSort
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.label,
                        style: TextStyle(
                          color: order == currentSort
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          fontWeight:
                              order == currentSort ? FontWeight.bold : null,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
        Sub(
          (_) => IconButton(
            icon: Icon(
                sl<ThemeState>().isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle theme (Ctrl + T)',
            onPressed: sl<ThemeState>().toggleTheme,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
