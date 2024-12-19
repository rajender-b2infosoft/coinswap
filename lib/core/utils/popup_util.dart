import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../routes/app_routes.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_outlined_button.dart';
import 'navigation_service.dart';

class PopupUtil {
  void popUp(BuildContext context, String title, titleStyle, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 160,
                padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
                decoration: BoxDecoration(
                    color: (title == 'Under Review')
                        ? appTheme.colorEA96
                        : (title == 'Active' || title == 'active')
                            ? appTheme.darkGreen
                            : appTheme.colorE132,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Text(
                  title,
                  textAlign: TextAlign.center, // Center the text
                  style: titleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                child: Text(
                  message,
                  textAlign: TextAlign.center, // Center the text
                  style: CustomTextStyles.color7272_17,
                ),
              ),
            ],
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  void imgPopUp(BuildContext context, String title, titleStyle, String message, String img) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
          ),
          title: Column(
            children: [
              CustomImageView(
                imagePath: img,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 10,),
              Text(title, style: titleStyle,
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              message,
              textAlign: TextAlign.center, // Center the text
              style: CustomTextStyles.color7272_17,
            ),
          ),
          actions: <Widget>[],
        );
      },
    );
  }

  void forgorPopUp(BuildContext context, String title, TextStyle titleStyle, String message, String img, page) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
          ),
          title: Column(
            children: [
              CustomImageView(
                imagePath: img,
                height: 80,
                width: 80,
              ),
              const SizedBox(height: 10,),
              Text(title, style: titleStyle),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              message,
              textAlign: TextAlign.center, // Center the text
              style: CustomTextStyles.gray7272_17,
            ),
          ),
          actions: <Widget>[
            Center(
              child: Container(
                height: 50,
                width: 150,
                // padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: appTheme.main,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: TextButton(
                  onPressed: () {
                    if(page == 'profile'){
                      NavigatorService.pushNamed(AppRoutes.profileScreen);
                    }else{
                      NavigatorService.pushNamed(AppRoutes.loginScreen);
                    }
                  },
                  child: Text(
                    'Okay',
                    style: TextStyle(
                      color: appTheme.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> onBackPressed(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit', textAlign: TextAlign.center, style: CustomTextStyles.main24,),
          content: Text('Are you sure you want to exit?', textAlign: TextAlign.center, style: CustomTextStyles.main16,),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Cancel', textAlign: TextAlign.center, style: CustomTextStyles.main21,),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Exit', textAlign: TextAlign.center, style: CustomTextStyles.main21,),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void logOutPopUp(BuildContext context, VoidCallback  onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
          ),
          title: Column(
            children: [
              Icon(Icons.logout, size: 50, color: appTheme.main_mpin,),
              const SizedBox(height: 0,),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              'Logout',
              textAlign: TextAlign.center, // Center the text
              style: CustomTextStyles.main18_mpin,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: appTheme.main_mpin)
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          NavigatorService.goBack();
                        },
                        child: Text(
                          'Cancel',
                          style: CustomTextStyles.main16,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      decoration: BoxDecoration(
                        color: appTheme.main_mpin,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: onConfirm,
                        child: Text(
                          'Logout',
                          style: CustomTextStyles.white17,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}
