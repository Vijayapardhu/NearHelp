import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:near_help/l10n/app_localizations.dart';
import 'widgets/role_switch_screen.dart';
import 'edit_profile_screen.dart';
import '../../auth/data/auth_controller.dart';
import '../../auth/data/auth_repository.dart';
import '../data/profile_controller.dart';
import '../../auth/presentation/language_selection_screen.dart';
import 'edit_profile_screen.dart';
import 'static_pages.dart';
import 'profile_widgets.dart';
import 'notifications_screen.dart';
import 'package:near_help/features/payment/presentation/earnings_screen.dart';
import '../../../../core/providers/language_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentLocale = ref.watch(languageProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: profileAsync.when(
          data: (profile) {
            if (profile == null) return const Center(child: Text("Profile not found"));
            
            final int trustScore = profile['base_trust_score'] ?? 100;
            final int requests = 15; 
            final double rating = 4.8;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade50, Colors.white, Colors.green.shade50],
                ),
              ),
              child: Stack(
                children: [
                  // 1. Custom Gradient Header (Job Radar Style)
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
                              child: const Icon(Icons.person, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.profile,
                              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        
                        // Edit Button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Main Content
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 100, 24, 24), // Overlap header
                          child: Column(
                            children: [
                              FadeInDown(
                                duration: const Duration(milliseconds: 600),
                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                // 2. Main Profile Content (Avatar + Name)
                                Padding(
                                  padding: const EdgeInsets.only(top: 0), // Removed top padding
                                  child: Column(
                                    children: [
                                      // Avatar with Border
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.blue.shade50,
                                        backgroundImage: (profile['avatar_url'] != null && profile['avatar_url'].isNotEmpty)
                                            ? NetworkImage(profile['avatar_url'])
                                            : null,
                                        child: (profile['avatar_url'] == null || profile['avatar_url'].isEmpty)
                                            ? Text(
                                                profile['name']?[0].toUpperCase() ?? 'U',
                                                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: theme.primaryColor),
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Name & Verification
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          profile['name'] ?? 'No Name',
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (profile['is_verified'] == true) ...[
                                          const SizedBox(width: 6),
                                          const Icon(Icons.verified, color: Colors.blue, size: 24),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      profile['role'].toString().toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: profile['role'] == 'helper' ? Colors.green : Colors.blue,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 36,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                                        },
                                        icon: const Icon(Icons.edit, size: 16),
                                        label: const Text("Edit Profile"),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.blue.shade700,
                                          side: BorderSide(color: Colors.blue.shade200),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                  ],
                                ), // Closes Stack
                              ), // Closes FadeInDown,


                        // Stats Strip
                        const SizedBox(height: 24),
                        FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: Container(
                             margin: const EdgeInsets.symmetric(horizontal: 16),
                             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                             decoration: BoxDecoration(
                               color: Colors.white,
                               borderRadius: BorderRadius.circular(20),
                               boxShadow: [
                                 BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
                               ],
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                  Expanded(child: _buildStatItem("Requests", "$requests")),
                                  Container(height: 40, width: 1, color: Colors.grey[200]),
                                  Expanded(child: _buildStatItem("Rating", "$rating ★")),
                                  Container(height: 40, width: 1, color: Colors.grey[200]),
                                  Expanded(child: _buildStatItem("Trust Score", "$trustScore%")),
                               ],
                             ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Settings Sections
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                            children: [
                              _buildSettingsSection(
                                title: "Preferences",
                                children: [
                                  if (profile['role'] == 'helper')
                                    _buildSettingTile(
                                      icon: Icons.currency_rupee, // Changed to currency icon
                                      color: Colors.green,
                                      title: "Earnings", // Renamed from Wallet
                                      subtitle: "₹1,250.00", // Updated Value
                                      onTap: () {
                                         Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningsScreen()));
                                      },
                                    ),
                                  // Language Dropdown Tile
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(color: Colors.purple.withOpacity(0.1), shape: BoxShape.circle),
                                          child: const Icon(Icons.language, color: Colors.purple, size: 22),
                                        ),
                                        const SizedBox(width: 16),
                                        const Text("Language", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                        const Spacer(),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<Locale>(
                                            value: currentLocale,
                                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                            items: const [
                                              DropdownMenuItem(value: Locale('en'), child: Text("English")),
                                              DropdownMenuItem(value: Locale('hi'), child: Text("हिंदी")),
                                              DropdownMenuItem(value: Locale('te'), child: Text("తెలుగు")),
                                            ],
                                            onChanged: (Locale? newLocale) {
                                              if (newLocale != null) {
                                                ref.read(languageProvider.notifier).setLanguage(newLocale);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),



                                  // Switch Role Button
                                  _buildSettingTile(
                                    icon: Icons.swap_horiz,
                                    color: Colors.deepOrange,
                                    title: profile['role'] == 'helper' ? "Switch to User Mode" : "Switch to Helper Mode",
                                    subtitle: "Swap your role",
                                    onTap: () => _confirmRoleSwitch(context, profile['id'], profile['role'] == 'helper' ? 'user' : 'helper'),
                                  ),

                                  _buildSettingTile(
                                    icon: Icons.notifications_outlined,
                                    color: Colors.orange,
                                    title: "Notifications",
                                    onTap: () {
                                       Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildSettingsSection(
                                title: "Support",
                                children: [
                                  _buildSettingTile(
                                    icon: Icons.lock_outline,
                                    color: Colors.teal,
                                    title: "Privacy & Security",
                                    onTap: () {
                                       Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyScreen()));
                                    },
                                  ),
                                  _buildSettingTile(
                                    icon: Icons.help_outline,
                                    color: Colors.blue,
                                    title: "Help & Support",
                                    onTap: () {
                                       Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen()));
                                    },
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 40),
                              
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                                  icon: const Icon(Icons.logout),
                                  label: Text(l10n.logout),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red,
                                    elevation: 2,
                                    shadowColor: Colors.red.withOpacity(0.2),
                                    side: BorderSide(color: Colors.red.shade100),
                                    padding: const EdgeInsets.all(16),
                                  ).copyWith(
                                    overlayColor: MaterialStateProperty.all(Colors.red.shade50),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text("Version 1.1.0", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                            ],
                          ),
                          ), // Closes Padding
                        ), // Closes FadeInUp
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }


  Widget _buildSettingsSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final index = entry.key;
              final widget = entry.value;
              return Column(
                children: [
                  widget,
                  if (index != children.length - 1)
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20),
                       child: Divider(height: 1, color: Colors.grey[100]),
                     ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required Color color,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (subtitle != null)
             Flexible(child: Text(subtitle, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
          if (subtitle != null) const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[50], // Small background for arrow
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _confirmRoleSwitch(BuildContext context, String userId, String targetRole) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Switch Role"),
        content: Text("Are you sure you want to switch to ${targetRole.toUpperCase()} mode? The app will restart."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => RoleSwitchScreen(targetRole: targetRole, userId: userId)));
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
}
