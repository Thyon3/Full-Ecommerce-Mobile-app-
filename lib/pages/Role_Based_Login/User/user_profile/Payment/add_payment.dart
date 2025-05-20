import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:thyecommercemobileapp/components/mybutton.dart';
import 'package:thyecommercemobileapp/components/show_snackbar.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final _userNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _balanceController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _maskFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  double balance = 0.0;
  String? selectedMethod;
  Map<String, dynamic>? selectedPaymentMethod;
  bool _isLoading = false; // Added loading state

  String? get getUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<List<Map<String, dynamic>>> fetchPaymentMethodsFromFirestore() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('PaymentMethods').get();
    return snapshot.docs
        .map((item) => item.data() as Map<String, dynamic>)
        .toList();
  }

  Future<bool> _checkExistingPayment(String paymentType) async {
    if (getUserId == null) return false;

    final query =
        await FirebaseFirestore.instance
            .collection('UsersPaymentInformation')
            .doc(getUserId)
            .collection('PaymentDetail')
            .where('PaymentSystem', isEqualTo: paymentType)
            .get();

    return query.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPaymentMethodSelector(),
                      const SizedBox(height: 20),
                      _buildPaymentForm(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 30),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 35),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 60),
          Text(
            'Add Payment Method',
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Payment System',
          style: GoogleFonts.lato(
            fontSize: 20,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchPaymentMethodsFromFirestore(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No payment methods available.');
            }

            return DropdownButtonFormField<String>(
              hint: const Text('Select Payment Method'),
              value: selectedMethod,
              items:
                  snapshot.data!.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['name'],
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: item['image'],
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            item['name'],
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                  selectedPaymentMethod = snapshot.data!.firstWhere(
                    (item) => item['name'] == value,
                  );
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a payment method';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: _userNameController,
            decoration: const InputDecoration(
              label: Text('Card Holder Name'),
              hintText: 'e.g. John Doe',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              if (value.trim().length < 3) {
                return 'Name too short';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _cardNumberController,
            inputFormatters: [_maskFormatter],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text('Card Number'),
              hintText: 'e.g. 1111 1111 1111 1111',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.replaceAll(' ', '').length != 16) {
                return 'Card number must be 16 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _balanceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text('Balance'),
              prefixText: '\$',
              hintText: '100.00',
              border: OutlineInputBorder(),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter initial balance';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid amount';
              }
              return null;
            },
            onChanged: (value) => balance = double.tryParse(value) ?? 0.0,
          ),
          const SizedBox(height: 30),
          Mybutton(text: 'Add Payment Method', onTap: _submitPaymentMethod),
        ],
      ),
    );
  }

  Future<void> _submitPaymentMethod() async {
    if (!_formkey.currentState!.validate()) return;
    if (selectedPaymentMethod == null) {
      showSnackbar(context, 'Please select a payment method');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if user already has this payment type
      final alreadyExists = await _checkExistingPayment(
        selectedPaymentMethod!['name'],
      );
      if (alreadyExists) {
        showSnackbar(
          context,
          'You already have a ${selectedPaymentMethod!['name']} payment method. '
          'You can only have one payment method per type.',
        );
        return;
      }

      // Add new payment method
      await FirebaseFirestore.instance
          .collection('UsersPaymentInformation')
          .doc(getUserId)
          .collection('PaymentDetail')
          .add({
            'UserName': _userNameController.text.trim(),
            'CardNumber': _cardNumberController.text.trim(),
            'balance': double.parse(_balanceController.text.trim()),
            'PaymentSystem': selectedPaymentMethod!['name'],
            'image': selectedPaymentMethod!['image'],
            'createdAt': FieldValue.serverTimestamp(),
          });

      showSnackbar(context, 'Payment method added successfully!');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      showSnackbar(context, 'Error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _cardNumberController.dispose();
    _balanceController.dispose();
    super.dispose();
  }
}
