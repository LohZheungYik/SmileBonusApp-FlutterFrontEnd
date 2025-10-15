import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/constants.dart';
import 'package:winkclone/view/login_page.dart';
import 'package:winkclone/view/search_page.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view-model/home_view_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: vm.selectedIndex == 0
            ? PlacesSearchBar()
            : vm.selectedIndex == 3
            ? UserNameBar()
            : Text("Wink 😉"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              constants.session = {};
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) =>
                    false, // this removes all previous routes
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.selectedIndex,
        onTap: (index) {
          setState(() {
            vm.selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          bottomNavBarItem(vm, 0, Icons.home_outlined, "Home"),
          bottomNavBarItem(vm, 1, Icons.sentiment_satisfied_outlined, "Earn"),
          bottomNavBarItem(vm, 2, Icons.attach_money, "Redeem"),
          bottomNavBarItem(vm, 3, Icons.person_2_outlined, "Profile"),
          
        ],
      ),
      body: vm.pages[vm.selectedIndex],
    );
  }

  BottomNavigationBarItem bottomNavBarItem(
    HomeViewModel vm,
    int navIndex,
    var icon,
    var label,
  ) {
    return BottomNavigationBarItem(
      icon: vm.selectedIndex == navIndex
          ? Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: WinkTheme.color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white),
            )
          : Icon(icon, color: WinkTheme.color),
      label: label,
    );
  }
}

class UserNameBar extends StatelessWidget {
  const UserNameBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            constants.session['name'],
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          Text(
            constants.session['email'],
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class PlacesSearchBar extends StatelessWidget {
  const PlacesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      child: TextField(
        readOnly: true, // Prevent keyboard
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPage()),
          );
        },
        decoration: InputDecoration(
          hintText: "Try 'Jurong Point'",
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: WinkTheme.color,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.search, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}
