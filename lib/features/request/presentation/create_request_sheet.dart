import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:near_help/l10n/app_localizations.dart';
import 'voice_request_button.dart';
import '../data/request_controller.dart';

class CreateRequestSheet extends ConsumerStatefulWidget {
  final LatLng location;
  
  const CreateRequestSheet({super.key, required this.location});

  @override
  ConsumerState<CreateRequestSheet> createState() => _CreateRequestSheetState();
}

class _CreateRequestSheetState extends ConsumerState<CreateRequestSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
       await ref.read(requestControllerProvider.notifier).createRequest(
         title: _titleController.text.trim(),
         amount: double.parse(_amountController.text.trim()),
         description: _descController.text.trim(),
         lat: widget.location.latitude,
         lng: widget.location.longitude,
       );
       
       if (mounted) {
         Navigator.pop(context);
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Posted!')));
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5)],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Add padding for keyboard
        left: 24, 
        right: 24, 
        top: 12
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            
            Text(l10n.requestHelp, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
             // MIC INPUT ROW
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                  children: [
                      const Icon(Icons.mic, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(child: Text("Tap Mic to Speak Request...", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blue[900]))),
                      VoiceRequestButton(onResult: (text) {
                          setState(() {
                             _titleController.text = text; 
                          });
                      }),
                  ],
              ),
            ),
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.whatNeed, 
                prefixIcon: const Icon(Icons.help_outline),
              ),
              style: const TextStyle(fontSize: 18),
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
             TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.amount, 
                prefixIcon: const Icon(Icons.currency_rupee),
                suffixText: "INR"
              ),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18),
              validator: (val) => val!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: l10n.details, 
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Theme.of(context).colorScheme.primary, // High contrast
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
              child: Text(l10n.postRequest, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
