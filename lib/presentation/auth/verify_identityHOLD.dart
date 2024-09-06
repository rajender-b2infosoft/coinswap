import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/popup_util.dart';
import '../../widgets/custom_elevated_button.dart';

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({super.key});

  @override
  State<VerifyIdentity> createState() => _VerifyIdentityState();
  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=> AuthProvider(),
      child: const VerifyIdentity(),
    );
  }
}



class _VerifyIdentityState extends State<VerifyIdentity> {
  var selfieProvider;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // homeProvider = Provider.of<HomeScreenProvider>(context, listen: false);
      selfieProvider.resetAllData();

    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     selfieProvider = Provider.of<SelfieProvider>(context, listen: true);
    return  WillPopScope(
      onWillPop: () async {
        bool shouldPop = await PopupUtil().onBackPressed(context);
        return shouldPop;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appTheme.main,
          body: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    top: 0,
                    child: CustomImageView(
                      imagePath: ImageConstant.LooperGroup,
                      height: 120.v,
                      width: 120.h,
                      margin: EdgeInsets.only(bottom: 18.v),
                    ),
                  ),
                  Positioned(
                    left: (SizeUtils.width-120)/2.2,
                    bottom: SizeUtils.height/1.35,
                    child: CustomImageView(
                      imagePath: ImageConstant.logo,
                      height: 140.v,
                      width: 140.h,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: SizeUtils.height/1.6,
                    child: CustomImageView(
                      imagePath: ImageConstant.LooperGroupBottom,
                      height: 140.v,
                      width: 140.h,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      height: SizeUtils.height/1.5,
                      decoration: BoxDecoration(
                        color: appTheme.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Verify your identity',style: CustomTextStyles.pageTitleMain,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text('Please upload the picture of any of the documents to complete your registration.',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.gray12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 0, right: 20),
                                      decoration: BoxDecoration(
                                        color: (selfieProvider.groupValue == 'aadhar')?Color(0XFFDEEDFF):appTheme.grayLite,
                                        borderRadius: BorderRadius.circular(10,),
                                        border: Border.all(width: 1, color: (selfieProvider.groupValue == 'aadhar')?Color(0XFF016FD3).withOpacity(0.5):appTheme.grayEE)
                                      ),
                                        child: radioButton(selfieProvider, 'Aadhar ID','aadhar', (selfieProvider.groupValue == 'aadhar')? appTheme.main:appTheme.gray)
                                    ),
                                    const SizedBox(width: 15,),
                                    CustomImageView(
                                      imagePath: ImageConstant.line,
                                    ),
                                    const SizedBox(width: 15,),
                                    Container(
                                        padding: const EdgeInsets.only(left: 0, right: 20),
                                        decoration: BoxDecoration(
                                            color: (selfieProvider.groupValue == 'passport')?appTheme.main.withOpacity(0.2):appTheme.grayLite,
                                            borderRadius: BorderRadius.circular(10,),
                                            border: Border.all(width: 1, color: (selfieProvider.groupValue == 'passport')?appTheme.main:appTheme.grayEE)
                                        ),
                                        child: radioButton(selfieProvider, 'Passport','passport', (selfieProvider.groupValue == 'passport')? appTheme.main:appTheme.gray)
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40,),
                              // (_groupValue == "aadhaar")?upload():uploadSelfie(),
                              upload(),


                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget radioButton(SelfieProvider selfieProvider,String name , String value, color){
    return InkWell(
      onTap: (){
         selfieProvider.setGroupValue(value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
              activeColor: appTheme.main,
              value: value,
              groupValue: selfieProvider.groupValue,
              onChanged: (val){
                selfieProvider.setGroupValue(value);
              },
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return appTheme.main;
              }
              return appTheme.gray;
            }),
          ),
          Text(name,style: TextStyle(
            color: color,
          ),)
        ],
      ),
    );
  }

  void popUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
          ),
          content: const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text('Your identity verified successfully. Upload your selfie',
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            Center(
              child: CustomElevatedButton(
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.main,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)
                    ),
                    elevation: 0
                ),
                buttonTextStyle: CustomTextStyles.white18,
                height: 50,
                width: 200,
                text: "Upload selfie",
                onPressed: () {
                    NavigatorService.pushNamed(AppRoutes.uploadSelfie);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget upload(){
    return Consumer<SelfieProvider>(
        builder: (context, selfieProvider, child) {
        return Column(
          children: [
            InkWell(
              onTap: (){
                // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
                if(selfieProvider.images.length < 1) {
                  selfieProvider.pickImage(context, selfieProvider.groupValue);
                }

                if(selfieProvider.images.length >= 1){
                  // popUp(context);
                  NavigatorService.pushNamed(AppRoutes.uploadSelfie);
                }
              },
              child: Container(
                height: 90,
                width: 200,
                decoration: BoxDecoration(
                  color: appTheme.main,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (selfieProvider.images.length >= 1)?image('proceed'):image('cloud'),
                    // CustomImageView(
                    //   imagePath: (selfieProvider.images.length >= 1)?image('proceed'):image('cloud'), //ImageConstant.arrowRight:ImageConstant.cloud,
                    //   height: 30.v,
                    //   width: 40.h,
                    // ),
                    Text((selfieProvider.images.length >= 1)?'Proceed':'Upload',style: CustomTextStyles.white18,)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: selfieProvider.images.length,
                  itemBuilder: (context, index) {
                    final image = selfieProvider.images[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      children: [
                        Image.file(
                          image.imageFile!,
                          width: 50.v,
                          height: 50.h,
                        ),
                        const SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: SizeUtils.width*0.5,
                                child: Text(image.name.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyles.gray7D7D_11
                                )
                            ),
                            Text(selfieProvider.formatSize(image.size), style: CustomTextStyles.gray11),
                          ],
                        ),
                        const Spacer(),
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(width: 3, color: Colors.green)
                              ),
                              child: const Icon(Icons.done, size: 30, color: Colors.green),
                            ),
                            Positioned(
                              top: 22,
                              left: 22,
                              child: InkWell(
                                onTap:(){
                                  selfieProvider.deleteDocument(image.name.toString(), selfieProvider.groupValue);
                                  selfieProvider.removeImage(image.imageFile);
                                }, child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red
                                    ),
                                    child: const Icon(Icons.delete_rounded, size: 15, color: Colors.white)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              ),
            )
          ],
        );
      }
    );
  }

  Widget image(type){
    if(type == 'proceed'){
      return Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: (selfieProvider.images.length >= 1)?appTheme.white:Colors.transparent,
          borderRadius: BorderRadius.circular(70),
        ),
        child: Icon(Icons.arrow_forward_outlined, size: 20, color: appTheme.main,),
      );
    }else{
      return CustomImageView(
        imagePath: ImageConstant.cloud,
        height: 30.v,
        width: 40.h,
      );
    }
  }

  // Widget uploadSelfie(SelfieProvider selfieProvider){
  //   return Column(
  //     children: [
  //       CustomImageView(
  //         imagePath: ImageConstant.capture,
  //       ),
  //       const SizedBox(height: 40,),
  //       _proceedButton(selfieProvider),
  //     ],
  //   );
  // }
  //
  // Widget _proceedButton(SelfieProvider selfieProvider) {
  //   return CustomElevatedButton(
  //     buttonStyle: ElevatedButton.styleFrom(
  //       backgroundColor: appTheme.main,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(50.0)
  //       ),
  //       elevation: 0
  //     ),
  //     buttonTextStyle: CustomTextStyles.white21,
  //     // height: 41.v,
  //     width: 250,
  //     text: "Capture",
  //     onPressed: () {
  //       // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
  //       if (selfieProvider.selfieImage == null) {
  //         CommonWidget.showToastView('Please take a selfie before proceeding!', appTheme.red);
  //       } else {
  //         var img = selfieProvider.selfieImage;
  //         selfieProvider.addDocument(img, context, 1, 'passport');
  //         // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
  //       }
  //     },
  //   );
  // }
}
