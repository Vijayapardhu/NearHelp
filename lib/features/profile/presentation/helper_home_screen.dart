import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_controller.dart';
import '../../request/data/request_repository.dart';
import '../../request/data/request_controller.dart';
import 'package:near_help/l10n/app_localizations.dart';
import '../../../../core/widgets/sos_button.dart';
import 'profile_screen.dart';
import '../../request/data/active_request_provider.dart';
import '../../request/presentation/active_job_card.dart';

final pendingRequestsProvider = FutureProvider.autoDispose((ref) async {
   return ref.watch(requestRepositoryProvider).getPendingRequests();
});

class HelperHomeScreen extends ConsumerStatefulWidget {
  const HelperHomeScreen({super.key});

  @override
  ConsumerState<HelperHomeScreen> createState() => _HelperHomeScreenState();
}

class _HelperHomeScreenState extends ConsumerState<HelperHomeScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(pendingRequestsProvider);
    final activeJobAsync = ref.watch(activeJobForHelperProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white, Colors.green.shade50],
          ),
        ),
        child: Stack(
          children: [
            // 1. Custom Gradient Header
            Container(
              height: 180,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.radar, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.jobRadar,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  // Modern Online/Offline Pill
                  GestureDetector(
                    onTap: () {
                      setState(() => _isOnline = !_isOnline);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isOnline ? "You are now ONLINE" : "You are now OFFLINE"),
                          backgroundColor: _isOnline ? Colors.green : Colors.grey,
                          duration: const Duration(seconds: 1),
                        )
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isOnline ? Colors.white : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: _isOnline 
                           ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] 
                           : [],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10, height: 10,
                            decoration: BoxDecoration(
                              color: _isOnline ? Colors.green : Colors.white54,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isOnline ? "Online" : "Offline",
                            style: TextStyle(
                              color: _isOnline ? Colors.green.shade700 : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Main Content
            Padding(
              padding: const EdgeInsets.only(top: 170), // Clear header
              child: !_isOnline
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text("You are Offline", style: TextStyle(color: Colors.grey[600], fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Go online to receive jobs", style: TextStyle(color: Colors.grey[400])),
                        ],
                      ),
                    )
                  : activeJobAsync.when(
                      data: (activeJob) {
                        if (activeJob != null) {
                          return Center(child: ActiveJobCard(job: activeJob, isUser: false));
                        }
                        return requestsAsync.when(
                          data: (requests) {
                            if (requests.isEmpty) {
                              return Center(child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.radar, size: 60, color: Colors.blue.shade100),
                                  const SizedBox(height: 16),
                                  Text(l10n.noRequests, style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                                ],
                              ));
                            }
                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                              itemCount: requests.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final req = requests[index];
                                final user = req['profiles'] ?? {};
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8)),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                req['title'] ?? l10n.requestHelp,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade50,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Colors.green.shade100),
                                              ),
                                              child: Text(
                                                '₹${req['amount']}',
                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          req['description'] ?? 'No description provided.',
                                          style: TextStyle(color: Colors.grey[600], height: 1.5),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 12,
                                              backgroundColor: Colors.grey[200],
                                              backgroundImage: (user['avatar_url'] != null) ? NetworkImage(user['avatar_url']) : null,
                                              child: (user['avatar_url'] == null) ? const Icon(Icons.person, size: 14, color: Colors.grey) : null,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(user['name'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                            const Spacer(),
                                            ElevatedButton(
                                              onPressed: () => _acceptJob(context, ref, req['id']),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue.shade600,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              ),
                                              child: Text(l10n.accept),
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
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Center(child: Text('Error: $err')),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: const SOSButton(),
    );
  }

  void _acceptJob(BuildContext context, WidgetRef ref, String requestId) async {
     await ref.read(requestControllerProvider.notifier).acceptRequest(requestId);
     if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job Accepted! Proceed to Location.")));
     }
  }
}
