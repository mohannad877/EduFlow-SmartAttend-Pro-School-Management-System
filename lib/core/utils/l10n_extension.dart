import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExt on BuildContext {
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    return localizations;
  }
}
