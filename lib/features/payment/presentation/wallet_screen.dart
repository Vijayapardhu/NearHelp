import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final double balance = 450.00;
    final List<Map<String, dynamic>> transactions = [
      {'title': 'Help Request #102', 'date': 'Today, 10:30 AM', 'amount': 150.0, 'isCredit': true},
      {'title': 'Withdrawal', 'date': 'Yesterday, 5:00 PM', 'amount': -500.0, 'isCredit': false},
      {'title': 'Help Request #098', 'date': 'Mon, 2:15 PM', 'amount': 200.0, 'isCredit': true},
      {'title': 'Help Request #095', 'date': 'Sun, 11:00 AM', 'amount': 300.0, 'isCredit': true},
      {'title': 'Bonus', 'date': 'Sat, 9:00 AM', 'amount': 300.0, 'isCredit': true},
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("My Wallet", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Balance Card
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade800, Colors.blue.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text("Total Balance", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("₹${balance.toStringAsFixed(2)}", style: GoogleFonts.poppins(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildActionButton(context, Icons.add, "Add Money", () => _showAddMoneyDialog(context)),
                          Container(width: 1, height: 40, color: Colors.white24),
                          _buildActionButton(context, Icons.arrow_downward, "Withdraw", () => _showWithdrawDialog(context)),
                        ],
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
                    Text("Recent Transactions", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(onPressed: (){}, child: Text("See All", style: GoogleFonts.poppins())),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
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
                                color: (tx['isCredit'] as bool) ? Colors.green.shade50 : Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                (tx['isCredit'] as bool) ? Icons.arrow_downward : Icons.arrow_upward,
                                color: (tx['isCredit'] as bool) ? Colors.green : Colors.red,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tx['title'], style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                                  Text(tx['date'], style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${(tx['isCredit'] as bool) ? '+' : ''}₹${(tx['amount'] as double).abs().toStringAsFixed(0)}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: (tx['isCredit'] as bool) ? Colors.green : Colors.red,
                              ),
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

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Money"),
        content: const TextField(
          decoration: InputDecoration(prefixText: "₹ ", labelText: "Amount"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Money Added Successfully!")));
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Withdraw Money"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
               decoration: InputDecoration(prefixText: "₹ ", labelText: "Amount"),
               keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select Bank"),
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
             child: const Text("Withdraw"),
          ),
        ],
      ),
    );
  }
}
