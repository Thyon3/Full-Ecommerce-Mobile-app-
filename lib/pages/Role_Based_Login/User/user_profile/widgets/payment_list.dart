import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentList extends StatefulWidget {
  final String? selectedPaymentid;
  final double? selectedPaymentBalance;
  final double? finalAmount;
  final Function(String?, double?) onPaymentSelected;

  const PaymentList({
    super.key,
    required this.selectedPaymentBalance,
    required this.finalAmount,
    required this.onPaymentSelected,
    required this.selectedPaymentid,
  });

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  String? get getUserId => FirebaseAuth.instance.currentUser?.uid;

  // Helper method to safely convert dynamic to double
  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.maxFinite,
      child: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('UsersPaymentInformation')
                .doc(getUserId)
                .collection('PaymentDetail')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(
              'Error loading payment methods',
              style: GoogleFonts.lato(color: Colors.red),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No payment methods found', style: GoogleFonts.lato()),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Navigate to add payment method
                  },
                  child: Text(
                    'Add Payment Method',
                    style: GoogleFonts.lato(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            );
          }

          final paymentMethodList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: paymentMethodList.length,
            itemBuilder: (context, index) {
              final paymentItem = paymentMethodList[index];
              final data = paymentItem.data() as Map<String, dynamic>? ?? {};

              return ListTile(
                leading: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        data['image']?.toString() ??
                            'https://via.placeholder.com/20', // Fallback image
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  data['PaymentSystem']?.toString() ?? 'Unknown Payment',
                  style: GoogleFonts.lato(),
                ),
                subtitle: _availableBalance(
                  data['balance'],
                  widget.finalAmount,
                ),
                selected: widget.selectedPaymentid == paymentItem.id,
                selectedTileColor: Colors.grey.shade300,
                onTap: () {
                  widget.onPaymentSelected(
                    paymentItem.id,
                    _parseToDouble(data['balance']),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _availableBalance(dynamic balance, dynamic fund) {
    final b = _parseToDouble(balance);
    final f = _parseToDouble(fund);

    return Text(
      b >= f ? 'Active' : 'Insufficient Balance',
      style: GoogleFonts.lato(color: b >= f ? Colors.green : Colors.red),
    );
  }
}
