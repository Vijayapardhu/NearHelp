import 'package:flutter/material.dart';

class TrustScoreWidget extends StatelessWidget {
  final int score;
  const TrustScoreWidget({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    // Simple color logic
    Color color = score >= 80 ? Colors.green : (score >= 50 ? Colors.orange : Colors.red);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          const Text("Trust Score", style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("$score", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                  const Text("/100", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(score >= 80 ? "Excellent" : "Average", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class ProfileStatsWidget extends StatelessWidget {
  final int totalRequests;
  final double rating;
  final String joinDate;

  const ProfileStatsWidget({
    super.key,
    required this.totalRequests,
    required this.rating,
    required this.joinDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, "$totalRequests", "Services", Icons.work_outline, Colors.blue),
          _buildVerticalDivider(),
          _buildStatItem(context, "$rating", "Rating", Icons.star_border, Colors.orange),
          _buildVerticalDivider(),
          _buildStatItem(context, "12+", "Hours", Icons.access_time, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() => Container(height: 40, width: 1, color: Colors.grey[200]);

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
