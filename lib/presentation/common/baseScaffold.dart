import 'package:flutter/material.dart';
import 'package:crypto_app/core/app_export.dart';
import '../../widgets/common_drawer.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget bottomNavBar;

  BaseScaffold({super.key, required this.title, required this.body, required this.bottomNavBar});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: ()=> openDrawer(),
              child: CustomImageView(
                imagePath: ImageConstant.wallet,
                height: 8,
                width: 8,
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "CoinSwap".tr,
                    style: theme.textTheme.headlineMedium
                ),
                TextSpan(
                    text: "lbl_entry2".tr,
                    style: theme.textTheme.headlineMedium
                )
              ],
            ),
            textAlign: TextAlign.left,
          ),
          actions: [
            const Icon(Icons.autorenew_rounded,size: 40, color: Colors.white,),
            SizedBox(width: 15.h,),
            const Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(Icons.notifications,size: 40, color: Colors.white,),
            ),
          ],
        ),
        drawer: const CommonDrawer(),
        bottomNavigationBar: bottomNavBar,
        body: body,
      ),
    );
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

}
