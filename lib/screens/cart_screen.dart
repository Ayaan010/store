import 'package:flutter/material.dart';
import '../utils/logger_util.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Load cart items (mock data for now)
  Future<void> _loadCartItems() async {
    LoggerUtil.info('Loading cart items');

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data
      final mockItems = [
        {
          'id': '1',
          'name': 'Chicken Sandwich',
          'price': 299,
          'quantity': 2,
          'image': 'assets/images/food1.png',
        },
        {
          'id': '2',
          'name': 'Veggie Burger',
          'price': 199,
          'quantity': 1,
          'image': 'assets/images/food2.png',
        },
        {
          'id': '3',
          'name': 'French Fries',
          'price': 99,
          'quantity': 1,
          'image': 'assets/images/food3.png',
        },
      ];

      if (mounted) {
        setState(() {
          _cartItems = mockItems;
          _isLoading = false;
        });
      }
    } catch (e) {
      LoggerUtil.error('Error loading cart items', e);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading cart: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Calculate total price
  int get _totalPrice {
    return _cartItems.fold(0, (total, item) {
      return total + (item['price'] as int) * (item['quantity'] as int);
    });
  }

  // Update item quantity
  void _updateQuantity(int index, int change) {
    setState(() {
      final newQuantity = (_cartItems[index]['quantity'] as int) + change;
      if (newQuantity > 0) {
        _cartItems[index]['quantity'] = newQuantity;
      } else {
        // Remove item if quantity becomes zero
        _cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFAB40),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Color(0xFF2D3250),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3250)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF004D40)),
              )
              : _cartItems.isEmpty
              ? _buildEmptyCart()
              : _buildCartContent(),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3250),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Add items to get started',
            style: TextStyle(fontSize: 16, color: Color(0xFF2D3250)),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004D40),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Browse Menu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              '${_cartItems.length} items in your cart',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3250),
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildCartItem(index),
            childCount: _cartItems.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 100), // Space for bottom bar
        ),
      ],
    );
  }

  Widget _buildCartItem(int index) {
    final item = _cartItems[index];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item image or icon placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF628673).withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.fastfood, color: Color(0xFF628673), size: 30),
            ),
          ),
          const SizedBox(width: 15),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3250),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '₹${item['price'].toInt()}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          // Quantity controls
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: const Color(0xFF628673),
                onPressed: () => _updateQuantity(index, -1),
              ),
              Text(
                '${item['quantity']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF628673),
                onPressed: () => _updateQuantity(index, 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Total price
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 14, color: Color(0xFF2D3250)),
                  ),
                  Text(
                    '₹${_totalPrice.toInt()}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D40),
                    ),
                  ),
                ],
              ),
            ),
            // Checkout button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Checkout functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Proceeding to checkout...'),
                      backgroundColor: Color(0xFF004D40),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
