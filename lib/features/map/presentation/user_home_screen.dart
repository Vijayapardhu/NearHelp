import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_controller.dart';
import '../../request/presentation/create_request_sheet.dart';
import '../../request/presentation/active_job_card.dart';
import '../../request/data/active_request_provider.dart';
import 'package:near_help/l10n/app_localizations.dart';
import '../../../../core/widgets/sos_button.dart';
import '../../profile/presentation/profile_screen.dart';
import '../data/location_service.dart';
import '../data/map_repository.dart';

class UserHomeScreen extends ConsumerStatefulWidget {
  const UserHomeScreen({super.key});

  @override
  ConsumerState<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends ConsumerState<UserHomeScreen> {
  final MapController _mapController = MapController();
  
  // Default to Hyderabad (demo location) if GPS fails initially
  LatLng _center = const LatLng(17.3850, 78.4867); 

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(currentLocationProvider);
    final nearbyHelpersAsync = ref.watch(nearbyHelpersProvider);
    final activeRequestAsync = ref.watch(activeRequestProvider);
    
    // Listen to location updates to center map once
    ref.listen(currentLocationProvider, (previous, next) {
      next.whenData((position) {
        if (mounted) {
           setState(() {
             _center = LatLng(position.latitude, position.longitude);
           });
           _mapController.move(_center, 15);
        }
      });
    });

    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      extendBodyBehindAppBar: true, // Allow map to go behind header
      body: Stack(
        children: [
          // 1. Full Screen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.near_help',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    width: 60,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                    ),
                  ),
                ],
              ),
              nearbyHelpersAsync.when(
                data: (helpers) => MarkerLayer(
                  markers: helpers.map((helper) => Marker(
                    point: LatLng(17.3850 + (0.01 * (helper.hashCode % 10)), 78.4867 + (0.01 * (helper.hashCode % 8))),
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.location_on, color: Colors.green, size: 40),
                  )).toList(),
                ),
                loading: () => const MarkerLayer(markers: []),
                error: (_, __) => const MarkerLayer(markers: []),
              ),
            ],
          ),
          
          // 2. Glassmorphic Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
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
                         child: Image.asset('assets/images/logo.png', height: 32, color: Colors.white),
                       ),
                       const SizedBox(width: 12),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(l10n.appName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                           const Text("Finding help nearby...", style: TextStyle(fontSize: 12, color: Colors.white70)),
                         ],
                       ),
                     ],
                   ),
                   const SOSButton(), // Assuming SOSButton can adapt or is visible on blue
                ],
              ),
            ),
          ),

          // 3. Bottom Action Area
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: activeRequestAsync.when(
              data: (activeReq) {
                if (activeReq != null) return ActiveJobCard(job: activeReq, isUser: true);
                
                return GestureDetector(
                  onTap: () {
                     showModalBottomSheet(
                       context: context,
                       isScrollControlled: true,
                       backgroundColor: Colors.transparent,
                       builder: (_) => CreateRequestSheet(location: _center),
                     );
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.campaign, color: Colors.white, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          l10n.requestHelp.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (err, _) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

final nearbyHelpersProvider = FutureProvider((ref) async {
  return ref.watch(mapRepositoryProvider).getNearbyHelpers();
});
