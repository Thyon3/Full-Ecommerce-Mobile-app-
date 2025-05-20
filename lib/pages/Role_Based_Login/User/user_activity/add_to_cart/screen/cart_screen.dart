import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/components/mybutton.dart';
import 'package:thyecommercemobileapp/components/show_snackbar.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/controller/cart_provider.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/user_activity/add_to_cart/screen/my_orders.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/user_activity/add_to_cart/widget/cart_item.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/user_profile/widgets/payment_list.dart';
import 'package:thyecommercemobileapp/services/auth_service.dart';

class CartScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController addressController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showSummary = true;
  bool _hasEnoughContent = false;

  String? selectedPaymentid;
  double? selectedPaymentBalance;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkContentHeight());
  }

  // get the user id

  String? get getUserId {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  void _checkContentHeight() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final viewportHeight = _scrollController.position.viewportDimension;
    setState(() {
      _hasEnoughContent = maxScroll > viewportHeight;
      _showSummary = !_hasEnoughContent;
    });
  }

  void _onScroll() {
    if (!_hasEnoughContent) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 50 && !_showSummary) {
      setState(() => _showSummary = true);
    } else if (currentScroll < maxScroll - 50 && _showSummary) {
      setState(() => _showSummary = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.maxScrollExtent !=
                          _scrollController.position.maxScrollExtent) {
                        _checkContentHeight();
                      }
                      return false;
                    },
                    child: ListView(
                      controller: _scrollController,
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      children: [
                        CartItem(),
                        SizedBox(height: _hasEnoughContent ? 120 : 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showSummary)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildSummaryContainer(context, cartState),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 25),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios_new),
          ),
          SizedBox(width: 100),
          Text(
            'Your Cart',
            style: GoogleFonts.lato(
              textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryContainer(BuildContext context, CartProvider cartState) {
    return AnimatedSlide(
      duration: Duration(milliseconds: 300),
      offset: _showSummary ? Offset.zero : Offset(0, 1),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            color: const Color.fromARGB(255, 90, 108, 117),
          ),
          child: _cartOrdersSummar(context, cartState),
        ),
      ),
    );
  }

  Widget _cartOrdersSummar(BuildContext context, CartProvider cartState) {
    final cart = cartState.getCart;
    double finalCartPrice = cart.fold(
      0,
      (total, item) => total + item.productData['price'] * item.quantity,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _summaryRow(context, 'Delivery', '\$4.43'),
        SizedBox(height: 10),
        _summaryRow(
          context,
          'Total Items',
          '\$${finalCartPrice.toStringAsFixed(2)}',
        ),
        Divider(color: Colors.white24),
        SizedBox(height: 10),
        Mybutton(
          text: 'Pay Now',
          onTap: () => _confirmYourOrder(context, cartState),
        ),
      ],
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Spacer(),
        Text(
          value,
          style: GoogleFonts.lato(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  void _confirmYourOrder(BuildContext context, CartProvider cartState) {
    final cart = cartState.getCart;
    double totalPrice = cart.fold(
      0,
      (total, item) => total + item.productData['price'] * item.quantity,
    );
    double totalWithDelivery = totalPrice + 4.43;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm Your Order',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...cart.map(
                  (item) => Text(
                    '${item.productData['name']} x${item.quantity}',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Select Your Payment Method',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 150,
                  child: PaymentList(
                    selectedPaymentBalance: selectedPaymentBalance,
                    finalAmount: totalWithDelivery,
                    onPaymentSelected: (id, balance) {
                      setState(() {
                        selectedPaymentid = id;
                        selectedPaymentBalance = balance;
                      });
                    },
                    selectedPaymentid: selectedPaymentid,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Add Your Address',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String? userId = FirebaseAuth.instance.currentUser?.uid;
                if (selectedPaymentid == null ||
                    selectedPaymentBalance == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a valid payment method.'),
                    ),
                  );
                }

                if (selectedPaymentBalance! < totalWithDelivery) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Insufficient balance for this payment method.',
                      ),
                    ),
                  );
                  return;
                }

                if (addressController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your delivery address.'),
                    ),
                  );
                  return;
                }

                _saveOrder(
                  cartState,
                  context,
                  totalWithDelivery,
                  addressController,
                  selectedPaymentid,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order placed successfully!')),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return MyOrders();
                //     },
                //   ),
                // );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

Future<void> _saveOrder(
  CartProvider cart,
  BuildContext context,
  totalWithDelivery,
  addressController,
  selectedPaymentid,
) async {
  // first get the user id and check if he user id logged in or not
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    showSnackbar(context, 'Please Login first to confirm');
  }

  cart.saveOrders(
    userId,
    context,
    totalWithDelivery,
    selectedPaymentid,
    addressController.text,
  );
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return MyOrders();
      },
    ),
  );
}
