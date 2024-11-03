import 'package:get_it/get_it.dart';
import 'package:flutter_widget_builder/core/theme_state.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<ThemeState>(() => ThemeState());
}
