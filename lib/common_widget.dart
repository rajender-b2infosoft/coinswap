import 'package:crypto_app/theme/theme_helper.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'core/utils/navigation_service.dart';
import 'core/utils/size_utils.dart';

class CommonWidget {
  Widget customIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Icon(
          icon,
          size: 25,
          color: appTheme.white,
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(context,color,msg){
   return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            content: Text(msg,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: appTheme.white,
                  fontFamily: 'Raleway',
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              ),
            )
        )
    );
  }

  Widget titleHeader(BuildContext context,title){
    return
      Container(//header Container start
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: SizeUtils.width,
        decoration: BoxDecoration(
          color: appTheme.main,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: CommonWidget().customIconButton(
                icon: Icons.arrow_back_ios,
                onPressed: () {
                  NavigatorService.goBack();
                },
              ),
            ),
            Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24
              ),
            ),
          ],
        ),
      );
  }

  static void showToastView (var msgg, color) {
    Fluttertoast.showToast(
        msg: msgg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}










