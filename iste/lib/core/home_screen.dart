import 'package:flutter/material.dart';
import 'package:iste/board/requests/requests_screen.dart';
import 'package:iste/core/broadcasts/broadcasts_screen.dart';
import 'package:iste/core/profile/profile.dart';
import 'package:iste/core/storage/storage_screen.dart';
import 'package:iste/core/tasks/tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> pages = [
    TasksScreen(),
    BroadcastsScreen(),
    RequestsScreen(),
    StorageScreen(),
    ProfileScreen(),
  ];

  int selectedPageIndex = 0;
  late PageController pageController = PageController(initialPage: selectedPageIndex);
  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
      pageController.jumpToPage(selectedPageIndex);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    // final route = ModalRoute.of(context);

    // if (route == null)
    //   return SizedBox(height: 1);
    // else {
    //   final routeArgs = route.settings.arguments as Map<String, Object>;
    // }

    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.black,
        // body: pages[selectedPageIndex],
        body: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.09), bottom: BorderSide(color: Colors.grey, width: 0.09))),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black,
              primaryColor: Colors.black,
              textTheme: Theme.of(context).textTheme.copyWith(
                    caption: new TextStyle(color: Colors.black),
                  ),
            ),
            child: BottomNavigationBar(
              onTap: selectPage,
              unselectedItemColor: Colors.grey,
              selectedItemColor: Color.fromRGBO(141, 131, 252, 1), //Color.fromRGBO(41, 120, 181, 1),
              currentIndex: selectedPageIndex,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              backgroundColor: Colors.black,
              items: [
                BottomNavigationBarItem(
                  icon: Container(height: 0.05842 * c, child: Icon(Icons.task)),
                  //Icon(Icons.category_outlined),
                  title: Text(
                    "Tasks",
                    style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 0.05842 * c,
                    child: Icon(Icons.notifications),
                  ),
                  title: Text("Broadcasts", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                ),
                BottomNavigationBarItem(
                  icon: Container(height: 0.05842 * c, child: Icon(Icons.message)),
                  title: Text("Requests", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                ),
                BottomNavigationBarItem(
                  icon: Container(height: 0.05842 * c, child: Icon(Icons.storage)),
                  title: Text("Storage", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                ),
                BottomNavigationBarItem(
                  icon: Container(height: 0.05842 * c, child: Icon(Icons.person)),
                  title: Text("Profile", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
