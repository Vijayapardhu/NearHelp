import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:near_help/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import '../../request/data/request_repository.dart';
import '../../profile/data/profile_controller.dart';
import '../../../../core/widgets/skeleton_list_item.dart';

// Provider for User History
final userHistoryProvider = FutureProvider.autoDispose((ref) async {
  return ref.watch(requestRepositoryProvider).getUserHistory(ref.watch(userProfileProvider).asData?.value?['id']);
});

// Provider for Helper History
final helperHistoryProvider = FutureProvider.autoDispose((ref) async {
  return ref.watch(requestRepositoryProvider).getHelperHistory(ref.watch(userProfileProvider).asData?.value?['id']);
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. Gradient Header
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade700, Colors.blue.shade500],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: SafeArea(
              child: Center(
                child: Text(
                  l10n.myHistory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // 2. Main Content
          Padding(
            padding: const EdgeInsets.only(top: 140),
            child: profileAsync.when(
              data: (profile) {
                if (profile == null) return const Center(child: Text("Profile not found"));
                final isHelper = profile['role'] == 'helper';
                return isHelper 
                    ? _buildHistoryList(ref, helperHistoryProvider) 
                    : _buildHistoryList(ref, userHistoryProvider);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(WidgetRef ref, AutoDisposeFutureProvider<List<Map<String, dynamic>>> provider) {
    final historyAsync = ref.watch(provider);
    
    return historyAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                  child: Icon(Icons.history, size: 60, color: Colors.blue.shade300),
                ),
                const SizedBox(height: 16),
                const Text("No history yet.", style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final job = history[index];
            final date = DateTime.tryParse(job['created_at']) ?? DateTime.now();
            final formattedDate = DateFormat.yMMMd().format(date);
            final statusColor = _getStatusColor(job['status']);

            return FadeInUp(
              delay: Duration(milliseconds: index * 100),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_getStatusIcon(job['status']), color: statusColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            job['status'].toString().toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount", style: TextStyle(color: Colors.grey[600])),
                        Text(
                          '₹${job['amount']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => ListView.separated(
        itemCount: 6,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (ctx, idx) => const SkeletonListItem(),
      ),
      error: (err, _) => Center(child: Text(err.toString())),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'paid': return Colors.blue;
      case 'cancelled': return Colors.red;
      default: return Colors.orange;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed': return Icons.check_circle_outline;
      case 'paid': return Icons.verified_outlined;
      case 'cancelled': return Icons.cancel_outlined;
      default: return Icons.schedule;
    }
  }
}
