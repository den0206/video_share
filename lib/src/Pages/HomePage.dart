import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_share/src/Extension/CustomWidgets.dart';
import 'package:video_share/src/Pages/TabPage/AddPage.dart';

import 'TabPage/VideoPage.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  final List _tabPages = [
    VideoPage(),
    Text("Search"),
    AddPage(),
    Text("Message"),
    Text("Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageModel>(
      create: (context) => HomePageModel(),
      builder: (context, child) {
        return Consumer<HomePageModel>(
          builder: (context, model, child) {
            final tabItems = [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 30),
                label: "Search",
              ),
              BottomNavigationBarItem(
                icon: CustomIcon(),
                label: "Add",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message, size: 30),
                label: "Message",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30),
                label: "Profile",
              )
            ];

            return Scaffold(
              body: _tabPages[model.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                onTap: model.setIndex,
                currentIndex: model.currentIndex,
                selectedItemColor: Colors.lightBlue,
                unselectedItemColor: Colors.black,
                items: tabItems,
              ),
            );
          },
        );
      },
    );
  }
}

class HomePageModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

// class MainTabPage extends StatefulWidget {
//   MainTabPage({Key key}) : super(key: key);

//   @override
//   _MainTabPageState createState() => _MainTabPageState();
// }

// class _MainTabPageState extends State<MainTabPage>
//     with SingleTickerProviderStateMixin {
//   TabController _tabController;
//   int selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void selextedItem(int index) {
//     setState(() {
//       selectedIndex = index;
//       _tabController.index = selectedIndex;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tabItems = [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.home, size: 30),
//         label: "Home",
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.search, size: 30),
//         label: "Search",
//       ),
//       BottomNavigationBarItem(
//         icon: _CustomIcon(),
//         label: "Add",
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.message, size: 30),
//         label: "Message",
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.person, size: 30),
//         label: "Profile",
//       )
//     ];
//     return Scaffold(
//       body: TabBarView(
//         physics: NeverScrollableScrollPhysics(),
//         controller: _tabController,
//         children: [
//           VideoPage(),
//           Text("Search"),
//           Text("Add"),
//           Text("Message"),
//           Text("Profile"),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         onTap: selextedItem,
//         currentIndex: selectedIndex,
//         selectedItemColor: Colors.lightBlue,
//         unselectedItemColor: Colors.black,
//         items: tabItems,
//       ),
//     );
//   }
// }
