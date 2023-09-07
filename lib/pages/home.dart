import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final user = FirebaseAuth.instance.currentUser!;

  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);

  int maxCount = 5;

  @override
  void initState() {
    super.initState();

    // print(user);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const Page1(),
    const Page2(),
    const Page3(),
    const Page4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: [
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 1',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.map,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.map,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 2',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.add,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 3',
                ),
                const BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  itemLabel: 'Page 4',
                ),
              ],
              onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages
                print('current selected index $index');
                _pageController.jumpToPage(index);
              },
            )
          : null,
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          children: [
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Text(
                "Jakebrake Logistics Load Management",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: SizedBox(height: 15),
            ),
            Container(
              width: sw,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Trackers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: SizedBox(height: 10),
            ),
            Container(
                child: Divider(
              color: Colors.black,
            ))
          ],
        )));
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white, child: const Center(child: Text('Page 2')));
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          children: [
            Container(
              child: SizedBox(
                height: 15,
              ),
            ),
            Container(
              child: Text(
                "Jakebrake Logistics Load Management",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: SizedBox(height: 15),
            ),
            Container(
              width: sw,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Adding Trackers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: SizedBox(height: 10),
            ),
            Container(
                child: Divider(
              color: Colors.black,
            ))
          ],
        )));
  }
}

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          children: [
            Container(
              child: SizedBox(height: 50),
            ),
            Container(
              child: Text("Personal Information"),
            ),
            Container(
              child: Text(""),
            ),
            Container(
              child: ElevatedButton(
                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                },
              ),
            )
          ],
        )));
  }
}
