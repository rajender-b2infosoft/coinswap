import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../theme/theme_helper.dart';

class CommonBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CommonBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0,0.06),
            end: const Alignment(1,0.06),
            colors: [appTheme.main,appTheme.white],
          )
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: currentIndex,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.white,
        // selectedIconTheme: const IconThemeData(size: 30),
        // unselectedIconTheme: const IconThemeData(size: 24),
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: (currentIndex==0)?Colors.deepOrange:Colors.transparent),
                borderRadius: BorderRadius.circular(50)
              ),
                child: Icon(Icons.home)
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: (currentIndex==1)?Colors.deepOrange:Colors.transparent),
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Icon(Icons.person)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: (currentIndex==2)?Colors.deepOrange:Colors.transparent),
                    borderRadius: BorderRadius.circular(50)
                ),child: Icon(Icons.settings)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: (currentIndex==3)?Colors.deepOrange:Colors.transparent),
                    borderRadius: BorderRadius.circular(50)
                ),child: Icon(Icons.dashboard)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: (currentIndex==4)?Colors.deepOrange:Colors.transparent),
                    borderRadius: BorderRadius.circular(50)
                ),child: Icon(Icons.verified_user)),
            label: '',
          ),
        ],
      ),
    );
  }

}
