import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mealbookapp/screen/categoriesscreen.dart';
import 'package:mealbookapp/screen/explore_screen.dart';
import 'package:mealbookapp/screen/home.dart';
import 'package:mealbookapp/screen/settingscreen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;
  String categoryName = "Chicken Tikka";

  List<Widget> getScreens() {
    return [
      const Home(),
CategoryScreen(),
      ExploreScreen(),
      const SettingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreens()[selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: Colors.grey[300],
        indicatorColor: Colors.black.withOpacity(0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final color = states.contains(MaterialState.selected)
              ? Colors.black
              : Colors.grey[600];

          return TextStyle(
            color: color,
            fontWeight:
            states.contains(MaterialState.selected) ? FontWeight.w600 : null,
          );
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home, color: Colors.black54),
            selectedIcon: Icon(Iconsax.home, color: Colors.black),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.category_outlined, // icon for unselected state
              color: Colors.black54,
            ),
            selectedIcon: Icon(
              Icons.category, // icon for selected state
              color: Colors.black,
            ),
            label: "Categories",
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu, color: Colors.black54), // represents meals, cuisines
            selectedIcon: Icon(Icons.restaurant_menu, color: Colors.black),
            label: "Explore",
          )
,

          // NavigationDestination(
          //   icon: Icon(Icons.explore_outlined, color: Colors.black54), // unselected
          //   selectedIcon: Icon(Icons.explore, color: Colors.black),   // selected
          //   label: "Explore",
          // ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.black54),
            selectedIcon: Icon(Icons.person, color: Colors.black),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
