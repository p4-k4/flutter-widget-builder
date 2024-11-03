import 'package:flutter/material.dart';

// Mock data models
class EnvironmentSound {
  final String name;
  final String icon;
  final double volume;
  final bool isMuted;

  const EnvironmentSound({
    required this.name,
    required this.icon,
    this.volume = 0.5,
    this.isMuted = false,
  });
}

class EnvironmentSettings {
  final String name;
  final List<EnvironmentSound> sounds;
  final Widget background;

  const EnvironmentSettings({
    required this.name,
    required this.sounds,
    required this.background,
  });
}

// Theme data for the sheet
class EnvironmentSheetTheme {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color accentColor;

  const EnvironmentSheetTheme({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.accentColor,
  });
}

class EnvironmentSettingsSheet extends StatelessWidget {
  final EnvironmentSettings settings;
  final EnvironmentSheetTheme theme;
  final VoidCallback? onSavePreset;
  final Function(String soundName, double volume)? onVolumeChanged;
  final Function(String soundName, bool isMuted)? onMuteToggled;

  const EnvironmentSettingsSheet({
    super.key,
    required this.settings,
    required this.theme,
    this.onSavePreset,
    this.onVolumeChanged,
    this.onMuteToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.foregroundColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  settings.name,
                  style: TextStyle(
                    color: theme.foregroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.bookmark_outline,
                    color: theme.accentColor,
                  ),
                  onPressed: onSavePreset,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Background preview
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.foregroundColor.withOpacity(0.05),
            ),
            clipBehavior: Clip.antiAlias,
            child: settings.background,
          ),
          const SizedBox(height: 24),
          // Sound controls
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              itemCount: settings.sounds.length,
              itemBuilder: (context, index) {
                final sound = settings.sounds[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      // Sound icon and name
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.foregroundColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          IconData(
                            int.parse(sound.icon, radix: 16),
                            fontFamily: 'MaterialIcons',
                          ),
                          color: theme.foregroundColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sound.name,
                              style: TextStyle(
                                color: theme.foregroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Volume slider
                            SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: theme.accentColor,
                                inactiveTrackColor:
                                    theme.foregroundColor.withOpacity(0.1),
                                thumbColor: theme.accentColor,
                                overlayColor:
                                    theme.accentColor.withOpacity(0.1),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: sound.volume,
                                onChanged: (value) =>
                                    onVolumeChanged?.call(sound.name, value),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Mute button
                      IconButton(
                        icon: Icon(
                          sound.isMuted ? Icons.volume_off : Icons.volume_up,
                          color: sound.isMuted
                              ? theme.foregroundColor.withOpacity(0.3)
                              : theme.foregroundColor,
                        ),
                        onPressed: () =>
                            onMuteToggled?.call(sound.name, !sound.isMuted),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
