import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Earnings
    final double totalEarnings = 1250.00;
    final double pendingClearance = 300.00;
    final double withdrawable = 950.00;

    final List<Map<String, dynamic>> transactions = [
      {'title': 'Help Request #102', 'date': 'Today, 10:30 AM', 'amount': 150.0, 'status': 'Cleared'},
      {'title': 'Help Request #098', 'date': 'Mon, 2:15 PM', 'amount': 200.0, 'status': 'Cleared'},
      {'title': 'Help Request #095', 'date': 'Sun, 11:00 AM', 'amount': 300.0, 'status': 'Pending'},
      {'title': 'Completion Bonus', 'date': 'Sat, 9:00 AM', 'amount': 300.0, 'status': 'Cleared'},
      {'title': 'Help Request #080', 'date': 'Fri, 4:30 PM', 'amount': 300.0, 'status': 'Cleared'},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("My Earnings", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.white, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Earnings Summary Card
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade700, Colors.teal.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text("Total Earnings", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("₹${totalEarnings.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text("Withdrawable", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text("₹${withdrawable.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 40, color: Colors.white24),
                          Expanded(
                            child: Column(
                              children: [
                                const Text("Pending", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text("₹${pendingClearance.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showWithdrawDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green.shade800,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Withdraw Earnings", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    const Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(onPressed: (){}, child: const Text("See All")),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isPending = tx['status'] == 'Pending';
                    return FadeInUp(
                      delay: Duration(milliseconds: 100 * index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isPending ? Colors.orange.shade50 : Colors.green.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPending ? Icons.hourglass_empty : Icons.check_circle_outline,
                                color: isPending ? Colors.orange : Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(tx['date'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "+₹${(tx['amount'] as double).toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  tx['status'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isPending ? Colors.orange : Colors.green,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Withdraw Earnings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
               decoration: InputDecoration(prefixText: "₹ ", labelText: "Amount to Withdraw"),
               keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select Bank Account"),
              items: const [
                 DropdownMenuItem(value: "HDFC", child: Text("HDFC Bank **** 1234")),
                 DropdownMenuItem(value: "SBI", child: Text("SBI **** 9876")),
              ],
              onChanged: (val) {},
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
             onPressed: () {
               Navigator.pop(ctx);
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Withdrawal Request Sent!")));
             },
             child: const Text("Confirm Withdraw"),
          ),
        ],
      ),
    );
  }
}
