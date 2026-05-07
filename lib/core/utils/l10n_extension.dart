import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExt on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations == null) {
      // Return a dummy implementation or throw to avoid null errors when context isn't localized yet
      throw Exception('AppLocalizations not found in context');
    }
    return localizations;
  }
}
