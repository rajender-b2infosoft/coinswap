import 'package:flutter/material.dart';
import '../core/app_export.dart';

enum BottomBarEnum { Settings, Location, Clock, Lock }

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({this.onChanged});
  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomBarState creatState() => CustomBottomBarState();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;
  List<BottomMenuModel> bottomMenuList =[
    BottomMenuModel(
      icon: ImageConstant.bit,
      activeIcon: ImageConstant.bit,
      type: BottomBarEnum.Settings,
    ),
    BottomMenuModel(
      icon: ImageConstant.bit,
      activeIcon: ImageConstant.bit,
      type: BottomBarEnum.Location,
    ),
    BottomMenuModel(
      icon: ImageConstant.bit,
      activeIcon: ImageConstant.bit,
      type: BottomBarEnum.Clock,
    ),
    BottomMenuModel(
      icon: ImageConstant.bit,
      activeIcon: ImageConstant.bit,
      type: BottomBarEnum.Lock,
    ),
  ];
  @override
  Widget build(BuildContext context){
    return Container(
      height: 74.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0, 0.5),
          end: Alignment(1, 0.5),
          colors: [appTheme.main, appTheme.white],
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedFontSize: 0,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
           return BottomNavigationBarItem(
               icon: CustomImageView(
                 imagePath: bottomMenuList[index].icon,
                 height: 24.adaptSize,
                 width: 24.adaptSize,
                 color: theme.colorScheme.onPrimaryContainer,
               ),
             activeIcon: CustomImageView(
               imagePath: bottomMenuList[index].activeIcon,
               height: 24.adaptSize,
               width: 24.adaptSize,
               color: theme.colorScheme.onPrimaryContainer,
             ),
             label: ''
           );
        }),
        onTap: (index){
          selectedIndex=index;
          widget.onChanged?.call(bottomMenuList[index].type);
          setState(() {
            
          });
        },
      ),
    );
  }
}

class BottomMenuModel {
  BottomMenuModel(
      {required this.icon, required this.activeIcon,required this.type});
  String icon;
  String activeIcon;
  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(
      color: Color(0xffffffff),
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please replace the respective widget here',
            style: TextStyle(fontSize: 18),)
          ],
        ),
      ),
    );
  }
}