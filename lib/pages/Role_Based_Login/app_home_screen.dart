import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/screen/item_details_screen/Screen/homescreen.dart';
import 'package:thyecommercemobileapp/pages/Role_Based_Login/User/screen/item_details_screen/Screen/user_profile.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AppHomeScreenState();
  }
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  @override
  // lets have the list of pages we will show for our items of bottom navigation bar
  List pages = [
    HomeScreen(),
    const Center(child: Text('Search')),
    const Center(child: Text('notifications')),
    UserProfile(),
  ];

  int _selectedBarIndex = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.black,
        currentIndex: _selectedBarIndex,
        onTap:
            (value) => {
              setState(() {
                _selectedBarIndex = value;
              }),
            },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 35),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 35),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add_outlined, size: 35),
            label: 'notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 35),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[_selectedBarIndex],
    );
  }
}
