import 'package:cleanify/pages/tabs/account.dart';
import 'package:cleanify/pages/tabs/map.dart';
import 'package:flutter/material.dart';
import 'package:cleanify/elements/project_elements.dart';
import 'package:cleanify/pages/tabs/home.dart';

class MainTabBar extends StatefulWidget {
  const MainTabBar({Key? key}) : super(key: key);

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar> with TickerProviderStateMixin {
  late final TabController tabController;
  late int currentTabIndex;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    currentTabIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: const CommonAppbar(preference: "menu"),
            body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const [MyHomePage(), MapPage(), AccountPage()]),
            bottomNavigationBar: BottomAppBar(
                notchMargin: 10,
                child: TabBar(
                    labelColor: ProjectColors.optionalTextColor2,
                    unselectedLabelColor:
                        ProjectColors.projectSecondaryWidgetColor,
                    onTap: (int index) {
                      setState(() {
                        currentTabIndex = index;
                      });
                      switch (currentTabIndex) {
                        case 0:
                          debugPrint("Currently in Home tab");
                          break;
                        case 1:
                          debugPrint("Currently in Map tab");
                          break;
                        case 2:
                          debugPrint("Currently in Account tab");
                          break;
                        default:
                          debugPrint("Unknown tab");
                      }
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    isScrollable: false,
                    indicatorColor: ProjectColors.optionalTextColor2,
                    controller: tabController,
                    tabs: const [
                      Tab(
                          text: "Home",
                          icon: Icon(Icons.house_outlined, size: 22)),
                      Tab(
                          text: "Map",
                          icon: Icon(Icons.location_pin, size: 22)),
                      Tab(
                          text: "Account",
                          icon: Icon(Icons.account_circle_outlined, size: 22))
                    ]))));
  }
}
