import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thyecommercemobileapp/components/mybutton.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/controller/cart_provider.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/user_activity/add_to_cart/widget/cart_item.dart';

class CartScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    // TODO: implement createState
    return _CartScreenState();
  }
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController addressController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showSummary = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Trigger animation when user scrolls near the bottom
    if (currentScroll >= maxScroll - 50) {
      if (!_showSummary) {
        setState(() => _showSummary = true);
      }
    } else {
      if (_showSummary) {
        setState(() => _showSummary = false);
      }
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
                  child: ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    children: [
                      CartItem(),
                      SizedBox(height: 120), // Extra space to scroll into
                    ],
                  ),
                ),
              ],
            ),

            // Sliding summary at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                offset: _showSummary ? Offset(0, 0) : Offset(0, 1),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: _cartOrdersSummar(context, cartState),
                ),
              ),
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

  Widget _cartOrdersSummar(BuildContext context, CartProvider cartState) {
    final cart = cartState.getCart;
    double finalCartPrice = cart.fold(
      0,
      (total, item) => total + item.productData['price'] * item.quantity,
    );

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 90, 108, 117),
        ),
        child: Column(
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
        ),
      ),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm Your Order ',
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...cartState.getCart.map(
                  (item) => Text(
                    '${item.productData['name']} x${item.quantity}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
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
            TextButton(onPressed: () {}, child: Text('Confirm')),
          ],
        );
      },
    );
  }
}
