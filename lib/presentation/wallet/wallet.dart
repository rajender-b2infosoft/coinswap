import 'package:crypto_app/presentation/wallet/provider/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../profile/models/profile.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletScreenProvider(),
      child: const WalletScreen(),
    );
  }
}

class _WalletScreenState extends State<WalletScreen> {
  late WalletScreenProvider provider;
// Maintain the expansion state for each tile
  late List<bool> _expandedStates;

  @override
  void initState() {
    super.initState();
    // Initialize an empty list for expansion states
    _expandedStates = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<WalletScreenProvider>(context, listen: false);
      provider.userWalletData();
    });
  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<WalletScreenProvider>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.main,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              NavigatorService.goBack();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: appTheme.white,
            )),
        title: Text(
          'Wallet',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    height: SizeUtils.height-140,
                    child: Consumer<WalletScreenProvider>(
                        builder: (context, provider, child) {
                          if (provider.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (provider.errorMessage != null) {
                            return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(provider.errorMessage!),
                                ));
                          }
                          if (provider.walletData == null || provider.walletData!.data.isEmpty) {
                            return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text('Wallet data not available', style: CustomTextStyles.gray7272_16,),
                                ));
                          }
                          // Accessing transaction data
                          final List<UserProfile> data = provider.walletData!.data;
                          // Initialize _expandedStates list to match data length
                          if (_expandedStates.length != data.length) {
                            _expandedStates = List.generate(data.length, (index) => false);
                          }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final w = data[index];

                            return _buildCryptoTile(
                              cryptoName: w.cryptoType.toString()[0].toUpperCase() + w.cryptoType!.substring(1).toLowerCase(),
                              cryptoSymbol: (w.cryptoType == 'bitcoin')?"BTC":(w.cryptoType == 'ethereum')?"ETH":"USDT",
                              cryptoIcon: (w.cryptoType == 'bitcoin')?ImageConstant.bit:(w.cryptoType == 'ethereum')?ImageConstant.eth:ImageConstant.t,
                              amount: w.balance.toString(),
                              walletAddress: w.walletAddress.toString(),
                              privateKey: w.publicKey.toString(),
                              cryptoColor: (w.cryptoType == 'bitcoin')?appTheme.orange:(w.cryptoType == 'ethereum')?appTheme.color5E8DF7:appTheme.green,
                              isExpanded: _expandedStates[index], // Use the expanded state for the tile
                              onExpansionChanged: (bool expanded) {
                                setState(() {
                                  _expandedStates[index] = expanded; // Update the expansion state
                                });
                              },
                            );
                          }
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoTile({
    required String cryptoName,
    required String cryptoSymbol,
    required cryptoIcon,
    required String amount,
    required String walletAddress,
    required String privateKey,
    required Color cryptoColor,
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.lightBlue,
          boxShadow: [
            BoxShadow(
              color: appTheme.color549FE3,
              blurRadius: 1.0,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: CustomImageView(
              imagePath: cryptoIcon,
              height: 40,
              width: 40,
            ),
            title: Text(
              cryptoName,
              style: CustomTextStyles.gray7272_15,
            ),
            subtitle: Text(cryptoSymbol, style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: cryptoColor
            ),),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(amount, style: CustomTextStyles.gray7272_15),
                Text(isExpanded ? "Hide Details" : "Show Details", style: CustomTextStyles.gray12),
              ],
            ),
            onExpansionChanged: onExpansionChanged,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: appTheme.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Wallet address",
                        style: CustomTextStyles.main16,
                      ),
                      subtitle: Text(
                        walletAddress,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.gray7272_15,
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: IconButton(
                          icon: Icon(Icons.copy, size: 20 , color: appTheme.gray7272,),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: walletAddress.toString()));
                          },
                        ),
                      ),
                    ),
                    // ListTile(
                    //   title: Text(
                    //     "Private Key",
                    //     style: CustomTextStyles.main16,
                    //   ),
                    //   subtitle: Text(privateKey,
                    //     overflow: TextOverflow.ellipsis,style: CustomTextStyles.gray7272_15,),
                    //   trailing: Padding(
                    //     padding: const EdgeInsets.only(top: 20.0),
                    //     child: IconButton(
                    //       icon: Icon(Icons.copy, size: 20 , color: appTheme.gray7272,),
                    //       onPressed: () {
                    //         Clipboard.setData(ClipboardData(
                    //             text: privateKey.toString()));
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

