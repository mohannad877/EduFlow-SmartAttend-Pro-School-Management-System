import 'package:school_schedule_app/core/utils/l10n_extension.dart';
import 'package:flutter/material.dart';

import 'package:school_schedule_app/domain/entities/validation_result.dart';

class ValidationSummaryDialog extends StatelessWidget {
  final ValidationResult result;

  const ValidationSummaryDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            result.isValid ? Icons.check_circle : Icons.warning,
            color: result.isValid ? Colors.green : Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Text(result.isValid
              ? context.l10n.validationSuccess
              : context.l10n.validationErrors, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: result.isValid
            ? Text(context.l10n.noConflictsFound, maxLines: 1, overflow: TextOverflow.ellipsis)
            : ListView(
                shrinkWrap: true,
                children: [
                  if (result.errors.isNotEmpty) ...[
                    Text(
                      context.l10n.errors,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    ...result.errors.map((e) => ListTile(
                          leading: const Icon(Icons.error,
                              color: Colors.red, size: 20),
                          title: Text(e, style: const TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                          dense: true,
                        )),
                    const SizedBox(height: 12),
                  ],
                  if (result.warnings.isNotEmpty) ...[
                    Text(
                      context.l10n.warnings,
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    ...result.warnings.map((e) => ListTile(
                          leading: const Icon(Icons.warning,
                              color: Colors.blue, size: 20),
                          title: Text(e, style: const TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                          dense: true,
                        )),
                  ],
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.ok, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
