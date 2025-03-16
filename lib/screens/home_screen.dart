import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('HomeScreen initialized');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Building HomeScreen');
    }

    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog when back button is pressed
        bool? exitConfirmed = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Do you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
        );

        // Return true only if the user confirmed exit
        return exitConfirmed ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFAB40),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CAMPUS CART',
                                  style: TextStyle(
                                    color: Color(0xFF2D3250),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D3250).withAlpha(51),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.notifications_none),
                              onPressed: () {},
                              color: const Color(0xFF2D3250),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // Enhanced Search Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Color(0xFFFFAB40)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search products...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFAB40).withAlpha(26),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.tune,
                                color: Color(0xFFFFAB40),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Featured Products
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF628673),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Featured Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder:
                              (context, index) => Container(
                                width: 160,
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(26),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.fastfood,
                                          size: 40,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Product ${index + 1}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '₹${(index + 1) * 3}',
                                            style: const TextStyle(
                                              color: Color(0xFFFFAB40),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Categories and Products Container
              SliverToBoxAdapter(
                child: Container(
                  color: const Color(0xFF628673),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildCategoryItem('Drinks', Icons.local_drink),
                            _buildCategoryItem('Snacks', Icons.restaurant_menu),
                            _buildCategoryItem('Sweets', Icons.cake),
                            _buildCategoryItem('Fast Food', Icons.fastfood),
                            _buildCategoryItem('Fruits', Icons.apple),
                            _buildCategoryItem(
                              'Groceries',
                              Icons.shopping_basket,
                            ),
                            _buildCategoryItem('Dairy', Icons.egg),
                            _buildCategoryItem('More', Icons.more_horiz),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Popular Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                            ),
                        itemCount: 6,
                        padding: const EdgeInsets.only(bottom: 20),
                        itemBuilder:
                            (context, index) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(26),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.fastfood,
                                          size: 40,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Product ${index + 1}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                'Category',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹${index == 4 ? '25' : ((index + 1) * 5).toInt()}',
                                                style: const TextStyle(
                                                  color: Color(0xFFFFAB40),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFFFFAB40,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFFFAB40),
            unselectedItemColor: Colors.grey,
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (kDebugMode) {
                print('Bottom navigation tapped: $index');
              }

              setState(() {
                _selectedIndex = index;
              });

              // Navigate to the appropriate screen based on the selected index
              if (index == 3) {
                // Profile tab
                if (kDebugMode) {
                  print('Navigating to ProfileScreen');
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFAB40).withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFFFAB40), size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
