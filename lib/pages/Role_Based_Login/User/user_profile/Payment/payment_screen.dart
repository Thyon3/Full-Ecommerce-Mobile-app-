import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/components/show_snackbar.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/user_profile/Payment/add_payment.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? userId;
  // a text editing controller for the amount
  TextEditingController _amount = TextEditingController();

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top AppBar Section
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new, size: 28),
                  ),
                  const SizedBox(width: 120),
                  Text(
                    'Payment',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment List Section
            Expanded(
              child:
                  userId == null
                      ? const Center(
                        child: Text(
                          'Please log in to see your payment methods.',
                        ),
                      )
                      : StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('UsersPaymentInformation')
                                .doc(userId)
                                .collection('PaymentDetail')
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Something went wrong.'),
                            );
                          }

                          final paymentDocuments = snapshot.data?.docs ?? [];

                          if (paymentDocuments.isEmpty) {
                            return const Center(
                              child: Text(
                                'You do not have any payment methods.',
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: paymentDocuments.length,
                            itemBuilder: (context, index) {
                              final paymentItem = paymentDocuments[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    imageUrl: paymentItem['image'],
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    paymentItem['PaymentSystem'],
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w900,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Activate',
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: CupertinoColors.activeGreen,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  trailing: MaterialButton(
                                    onPressed: _onAddingFundsToFirestore,
                                    child: Text(
                                      'Add Funds',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPayment()),
          );
        },
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Icon(
            Icons.add,
            size: 38,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  // lets have a fucntion for adding funds

  Future<void> _onAddingFundsToFirestore() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Funds',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          content: TextField(
            controller: _amount,
            decoration: InputDecoration(
              label: Text('Amount'),

              border: OutlineInputBorder(),
              fillColor: const Color.fromARGB(54, 255, 255, 255),
              filled: true,
              prefixText: "\$",
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            MaterialButton(
              onPressed: () async {
                //  first get the amount the user entered

                final amount = double.tryParse(_amount.text);
                if (amount == null || amount <= 0) {
                  showSnackbar(context, 'Please Enter a valid positive Amount');
                  return;
                }
                // if not add the fund in the existing amount of the payment mehod in firestore

                try {
                  await FirebaseFirestore.instance
                      .collection('UsersPaymentInformation')
                      .doc(userId)
                      .collection('PaymentDetail')
                      .doc()
                      .update({'balance': FieldValue.increment(amount)});
                } catch (e) {
                  showSnackbar(context, e.toString());
                }
                showSnackbar(context, 'Amount added succefully');
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
