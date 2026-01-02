import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:near_help/l10n/app_localizations.dart';
import 'login_screen.dart';
import '../../../../core/providers/language_provider.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Logo or Icon
              Center(
                 child: Icon(Icons.language, size: 80, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 24),
              Text(
                'NearHelp',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                'Select Language / भाषा चुनें / భాషను ఎంచుకోండి',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Grid for Languages
              Expanded(
                child: ListView(
                   children: [
                      _LanguageCard(
                        label: 'English',
                        subLabel: 'Hello',
                        icon: 'A',
                        locale: const Locale('en'),
                        onTap: () => ref.read(languageProvider.notifier).setLanguage(const Locale('en')),
                        isSelected: ref.watch(languageProvider).languageCode == 'en',
                      ),
                      const SizedBox(height: 16),
                      _LanguageCard(
                        label: 'हिन्दी',
                        subLabel: 'Hindi',
                        icon: 'अ',
                        locale: const Locale('hi'),
                        onTap: () => ref.read(languageProvider.notifier).setLanguage(const Locale('hi')),
                        isSelected: ref.watch(languageProvider).languageCode == 'hi',
                      ),
                      const SizedBox(height: 16),
                      _LanguageCard(
                        label: 'తెలుగు',
                        subLabel: 'Telugu',
                        icon: 'అ',
                        locale: const Locale('te'),
                        onTap: () => ref.read(languageProvider.notifier).setLanguage(const Locale('te')),
                        isSelected: ref.watch(languageProvider).languageCode == 'te',
                      ),
                   ],
                ),
              ),
              
              // Continue Button
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const LoginScreen()),
                   );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: Text(
                  AppLocalizations.of(context)?.loginButton ?? "Continue", 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String label;
  final String subLabel;
  final String icon;
  final Locale locale;
  final VoidCallback onTap;
  final bool isSelected;

  const _LanguageCard({
    required this.label,
    required this.subLabel,
    required this.icon,
    required this.locale,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.white,
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected 
             ? [BoxShadow(color: colorScheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
             : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                icon,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? colorScheme.onPrimaryContainer : Colors.black87,
                  ),
                ),
                Text(
                  subLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? colorScheme.onPrimaryContainer.withOpacity(0.7) : Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 32)
            else
              Icon(Icons.circle_outlined, color: Colors.grey.shade300, size: 32),
          ],
        ),
      ),
    );
  }
}
