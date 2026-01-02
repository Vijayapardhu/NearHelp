import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:near_help/l10n/app_localizations.dart';
import '../data/request_controller.dart';

class ActiveJobCard extends ConsumerWidget {
  final Map<String, dynamic> job;
  final bool isUser; // true if viewing as User, false if Helper

  const ActiveJobCard({super.key, required this.job, required this.isUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = job['status'];
    final otherParty = job['profiles'] ?? {};
    final name = otherParty['name'] ?? 'Unknown';
    final title = job['title'] ?? 'Help Request';
    final amount = job['amount'];
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.blue, width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isUser ? l10n.helperOnWay : l10n.jobInProgress, 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, letterSpacing: 1.2)),
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('₹$amount', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
            const Divider(height: 30),
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isUser ? 'Helper: $name' : 'User: $name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(l10n.tapToCall, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildActionButtons(context, ref, status, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, String status, AppLocalizations l10n) {
    // Action Logic based on Status and Role
    if (isUser) {
      if (status == 'accepted' || status == 'arrived') {
        return ElevatedButton(
          onPressed: () => _updateStatus(ref, 'in_progress'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, 
            minimumSize: const Size(double.infinity, 60)
          ),
          child: Text(l10n.confirmArrival, style: const TextStyle(fontSize: 18, color: Colors.white)),
        );
      } else if (status == 'in_progress') {
        return ElevatedButton(
          onPressed: () => _updateStatus(ref, 'completed'),
          style: ElevatedButton.styleFrom(
             backgroundColor: Colors.blueAccent,
             minimumSize: const Size(double.infinity, 60)
          ),
          child: Text(l10n.jobDonePaid, style: const TextStyle(fontSize: 18, color: Colors.white)),
        );
      }
    } else {
      // Helper View
      if (status == 'accepted') {
        return ElevatedButton(
           onPressed: () => _updateStatus(ref, 'arrived'),
           style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: const Size(double.infinity, 60)),
           child: Text(l10n.iHaveArrived, style: const TextStyle(fontSize: 18, color: Colors.white)),
        );
      } else if (status == 'in_progress') {
        return Text(l10n.jobInProgress, 
          textAlign: TextAlign.center,
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16));
      }
    }
    
    return const SizedBox.shrink();
  }

  void _updateStatus(WidgetRef ref, String newStatus) {
    ref.read(requestControllerProvider.notifier).updateRequestStatus(job['id'], newStatus);
  }
}
