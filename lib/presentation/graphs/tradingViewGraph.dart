import 'package:crypto_app/core/app_export.dart';
import 'package:crypto_app/presentation/graphs/providers/btcProvider.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingViewChartPage extends StatefulWidget {
  String type;
  String theme;

  @override
  TradingViewChartPage({super.key, required this.type, required this.theme});

  @override
  State<TradingViewChartPage> createState() => _TradingViewChartPageState();
  static Widget builder(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => BtcProvider(),
      child: TradingViewChartPage(type: args['type'], theme: args['theme']),
    );
  }
}

class _TradingViewChartPageState extends State<TradingViewChartPage> {
  late final WebViewController _controller;
  late final BtcProvider  provider;

  @override
  void initState() {
    super.initState();
      provider = Provider.of<BtcProvider>(context, listen: false);

    // Initialize the controller with desired settings
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            provider.setIsPageLoading(true);
            debugPrint('Page loading:::::::::::: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page loaded:::::::::::::::::: $url');
            provider.setIsPageLoading(false);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
                'https://www.tradingview.com/widgetembed/?frameElementId=tradingview_12345&symbol=CRYPTO%3A${widget.type}USD&interval=1D&theme=${widget.theme}')) {
              return NavigationDecision.navigate;
            }
            debugPrint('Blocked navigation to: ${request.url}');
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://www.tradingview.com/widgetembed/?frameElementId=tradingview_12345&symbol=CRYPTO%3A${widget.type}USD&interval=1D&theme=${widget.theme}'));
  }

  @override
  Widget build(BuildContext context) {
    // provider = Provider.of<BtcProvider>(context, listen: true);
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
          'Market History (${widget.type})',
          style: CustomTextStyles.headlineMediumRegular,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Consumer<BtcProvider>(
            builder: (context, provider, child) {
            return Stack(
              children: [
                (provider.isPageLoading)?Center(child: CircularProgressIndicator(color: appTheme.white, strokeWidth: 5,))
              :WebViewWidget(controller: _controller),
                Positioned(
                    bottom: 37,
                    left: 8,
                    child: Container(
                      decoration: BoxDecoration(
                          color: appTheme.white1,
                          borderRadius: BorderRadius.circular(50)),
                      child: CustomImageView(
                        height: 50,
                        width: 50,
                        imagePath: ImageConstant.logo,
                        color: Colors.blue,
                      ),
                    ))
              ],
            );
          }
        ),
      ),
    );
  }
}
