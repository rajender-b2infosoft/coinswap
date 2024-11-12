import 'package:crypto_app/presentation/profile/provider/profile.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/constants.dart';
import 'models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: const ProfileScreen(),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.userProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ProfileProvider>(context);
    final imageUrl = (provider.selfie != null)
        ? Constants.imgUrl + provider.selfie.toString()
        : ImageConstant.iconUser;


    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.main,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                NavigatorService.pushNamed(AppRoutes.homeScreen);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: appTheme.white,
              )),
          title: Text(
            'Profile ',
            style: CustomTextStyles.headlineMediumRegular,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: SizeUtils.height,
            decoration: BoxDecoration(
                color: appTheme.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            child: SingleChildScrollView(
              child: Consumer<ProfileProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (provider.errorMessage != null) {
                      return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(provider.errorMessage!),
                          ));
                    }
                    if (provider.profileData == null || provider.profileData!.data.isEmpty) {
                      return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('Profile data not available'),
                          ));
                    }
                    // Accessing transaction data
                    final List<UserProfile> data = provider.profileData!.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                border: Border.all(color: appTheme.main,width: 1),
                                shape: BoxShape.circle
                            ),
                            child: ClipOval(
                                child: Image.network(imageUrl,
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text("${provider.name}",style: CustomTextStyles.main18_400,),
                                  const SizedBox(width: 5,),
                                  Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: appTheme.main,
                                          shape: BoxShape.circle
                                      ),
                                      child: Icon(Icons.edit, size: 13,color: appTheme.white,))
                                ],
                              ),
                              const SizedBox(height: 2,),
                              SizedBox(
                                width: SizeUtils.width/2.1,
                                  child: Text("${provider.email}",style: CustomTextStyles.color9898_15,)
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: appTheme.white,
                          boxShadow: [
                            BoxShadow(
                              color: appTheme.color549FE3,
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: SizeUtils.width/4,
                                        child: Text("\$${provider.totalBalance}",
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyles.color0072D_20,),
                                      ),
                                      // Text("\$${(data[0].total_amount_sum != null) ? data[0].total_amount_sum : '0.0'}",style: CustomTextStyles.color0072D_20,),
                                      Text("Wallet",style: CustomTextStyles.color9898_18,)
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: appTheme.color0072D,
                                    thickness: 1,
                                  ),
                                  Column(
                                    children: [
                                      // Text("${(data[0].totalTransactions!=null)?data[0].totalTransactions:'0'}",style: CustomTextStyles.color0072D_20),
                                      Text("${(data.length>1)?data.length:0}",style: CustomTextStyles.color0072D_20),
                                      Text("Transfers",style: CustomTextStyles.color9898_18)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Divider(thickness: 1.5,color: appTheme.color0072D,),
                            const SizedBox(height: 20,),
                            SizedBox(
                              height: SizeUtils.height/3,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final profile = data[index];
                                  var type = (profile.cryptoType=='bitcoin')?'BTC':(profile.cryptoType=='ethereum')?'ETH':'USDT';
                                  var img = (type == 'BTC')?ImageConstant.bit:(type == 'ETH')?ImageConstant.eth:ImageConstant.t;
                                  var color = (type == 'BTC')?CustomTextStyles.orange16:(type == 'ETH')?CustomTextStyles.color5E8DF7_16:CustomTextStyles.green16;

                                  var balance = (profile.cryptoType == 'bitcoin')?provider.btcBalance:(profile.cryptoType == 'ethereum')?provider.ethBalance:provider.usdtBalance;


                                  return (profile.cryptoType!= null)?commonContainer(type, img, balance.toString(), color):Container();
                                  // return (profile.cryptoType!= null)?commonContainer(type, img, profile.balance.toString(), color):Container();
                                }
                              ),
                            ),
                            // const SizedBox(height: 15,),
                            // commonContainer("ETH", ImageConstant.eth, "0.031212",CustomTextStyles.color5E8DF7_16),
                            // const SizedBox(height: 15,),
                            // commonContainer("USDT", ImageConstant.t, "0.123122",CustomTextStyles.green16),
                            // const SizedBox(height: 15,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30,),
                      InkWell(
                        onTap: (){
                          NavigatorService.pushNamed(AppRoutes.forgotPassword, argument: {'page': 'profile'});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          decoration: BoxDecoration(
                              color: appTheme.color0071,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Change Password",style: CustomTextStyles.white17_400,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                    color: appTheme.color549FE3,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Icon(Icons.edit,color: appTheme.white,size: 20,),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget commonContainer(String name, String image, String value,style){
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
            color: appTheme.lightBlue,
            borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: appTheme.color549FE3,
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomImageView(imagePath: image,height: 40,),
                const SizedBox(width: 10,),
                Text(name,style: style,),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: SizeUtils.width/3,
                child: Center(
                  child: Text(value,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.color0072D_16,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
