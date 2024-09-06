import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto_app/presentation/home_screen_page/provider/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

class WalletPage extends StatefulWidget {
  @override
  State<WalletPage> createState() => _WalletPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WalletProvider(),
      child: WalletPage(),
    );
  }

}

class _WalletPageState extends State<WalletPage> {

  @override
  void initState() {
    super.initState();
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.initializeWallet('https://deep-index.moralis.io/api/v2.2/nft/0x524cab2ec69124574082676e6f654a18df49a048/7603'); // Replace with your Moralis RPC URL
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    print(walletProvider.address);
    return Scaffold(
      appBar: AppBar(
        title: Text('Moralis Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(walletProvider.address != null)
            Column(
              children: [
                const Text('Wallet Address'),
                Text('${walletProvider.address}'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await walletProvider.createWallet();
                print('Wallet Created: ${walletProvider.address}');
              },
              child: const Text('Create Wallet', style: TextStyle(color: Colors.white),),
            ),
            ElevatedButton(
              onPressed: () async {
                await walletProvider.getEthBalance().then((balance) {
                  print('ETH Balance: $balance');
                }).catchError((error) {
                  print('Error fetching ETH balance: $error');
                });
              },
              child: Text('Get ETH Balance', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                try {
                  await walletProvider.sendEth(
                    '0x14862e4fb263aa9ae3d73f6ca4e62c410c937495', // Replace with actual address
                    0.01
                    // BigInt.from(1000000000000000000), // 1 ETH in Wei
                  );
                } catch (e) {
                  print('Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to send ETH: $e')),
                  );
                }
                // String recipient = '0x14862e4fb263aa9ae3d73f6ca4e62c410c937495';
                // BigInt bigIntValue = BigInt.from(1000000000000000000);
                // print('===========bigIntValue=============>$bigIntValue');
                // EtherAmount ethAmount =
                // EtherAmount.fromBigInt(EtherUnit.wei, bigIntValue);
                // print('............ethAmount..........$ethAmount');
                // // Convert the amount to EtherAmount
                // sendTransaction(recipient, ethAmount);

              },
              child: const Text('Send 1 ETH', style: TextStyle(color: Colors.white),),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                await walletProvider.getUsdtBalance('0xdac17f958d2ee523a2206206994597c13d831ec7').then((balance) {
                  print('USDT Balance: $balance');
                }).catchError((error) {
                  print('Error fetching USDT balance: $error');
                });
              },
              child: const Text('Get USDT Balance', style: TextStyle(color: Colors.white),),
            ),
            ElevatedButton(
              onPressed: () async {
                await walletProvider.transferUSDT(
                    EthereumAddress.fromHex('TO_ADDRESS'), // Replace with actual address
                    BigInt.from(1000000), // 1 USDT in smallest unit
                    '0xdac17f958d2ee523a2206206994597c13d831ec7' // Replace with actual contract address
                );
              },
              child: const Text('Send 1 USDT', style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  void sendTransaction(String receiver, EtherAmount txValue) async {
    var apiUrl = "https://deep-index.moralis.io/api/v2.2/nft/0x524cab2ec69124574082676e6f654a18df49a048/7603"; // Replace with your API
    // Replace with your API
    var httpClient = http.Client();
    var ethClient = Web3Client(apiUrl, httpClient);

    EthPrivateKey credentials = EthPrivateKey.fromHex('0x5dfa1d664e0c7fef9cebbc7650950a244d96a210');

    print('.................credentials...........>${credentials.address}');

    EtherAmount etherAmount = await ethClient.getBalance(credentials.address);
    EtherAmount gasPrice = await ethClient.getGasPrice();

    print('............................>$etherAmount');

    await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(receiver),
        gasPrice: gasPrice,
        maxGas: 100000,
        value: txValue,
      ),
      chainId: 11155111,
    );
    print('..............crfcfc..............>');

  }


}
