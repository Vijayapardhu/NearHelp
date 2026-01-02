import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:near_help/l10n/app_localizations.dart';

class SOSButton extends StatelessWidget {
  const SOSButton({super.key});

  Future<void> _callEmergency() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '112');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _callEmergency,
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.warning_amber_rounded),
      label: Text(AppLocalizations.of(context)!.sosButton, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
