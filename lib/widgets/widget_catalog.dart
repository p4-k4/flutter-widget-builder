import 'package:flutter/material.dart';
import 'package:flutter_widget_builder/widgets/custom_button.dart';
import 'package:flutter_widget_builder/widgets/environment_settings_sheet.dart';

class CatalogItem {
  final String name;
  final Widget Function(BuildContext) builder;
  final List<String> tags;

  const CatalogItem({
    required this.name,
    required this.builder,
    this.tags = const [],
  });
}

// Sample environment background
class SampleBackground extends StatelessWidget {
  const SampleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF48CAE4), Color(0xFF023E8A)],
        ),
      ),
    );
  }
}

final widgetCatalog = [
  CatalogItem(
    name: 'Custom Button',
    builder: (context) => const CustomButton(
      text: 'Click Me',
      onPressed: null,
    ),
    tags: ['button', 'interactive', 'basic'],
  ),
  CatalogItem(
    name: 'Environment Settings',
    builder: (context) => EnvironmentSettingsSheet(
      settings: EnvironmentSettings(
        name: 'Ocean Breeze',
        background: const SampleBackground(),
        sounds: const [
          EnvironmentSound(
            name: 'Waves',
            icon: 'e45e', // water icon
            volume: 0.7,
          ),
          EnvironmentSound(
            name: 'Seagulls',
            icon: 'e544', // bird icon
            volume: 0.4,
          ),
          EnvironmentSound(
            name: 'Wind',
            icon: 'e5cd', // air icon
            volume: 0.5,
          ),
        ],
      ),
      theme: EnvironmentSheetTheme(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        accentColor: Theme.of(context).colorScheme.primary,
      ),
      onVolumeChanged: (_, __) {},
      onMuteToggled: (_, __) {},
      onSavePreset: () {},
    ),
    tags: ['sheet', 'settings', 'audio', 'environment', 'bottom sheet'],
  ),
];
