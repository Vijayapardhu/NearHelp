import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Mock State
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _promoEnabled = false;
  bool _securityEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSwitchTile(
                      "Push Notifications",
                      "Get instant alerts on your device",
                      _pushEnabled,
                      (val) => setState(() => _pushEnabled = val),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      "Email Alerts",
                      "Receive summaries and important updates",
                      _emailEnabled,
                      (val) => setState(() => _emailEnabled = val),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      "Promotional Offers",
                      "Coupons, discounts and marketing",
                      _promoEnabled,
                      (val) => setState(() => _promoEnabled = val),
                    ),
                    const Divider(height: 1),
                    _buildSwitchTile(
                      "Security Alerts",
                      "Login attempts and password changes",
                      _securityEnabled,
                      (val) => setState(() => _securityEnabled = val),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      activeColor: Theme.of(context).primaryColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    );
  }
}
