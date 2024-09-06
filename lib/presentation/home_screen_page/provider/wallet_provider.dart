import 'dart:convert';
import 'dart:math';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import '../../../services/moralisApiService.dart';
import 'dart:typed_data';

class WalletProvider with ChangeNotifier {
  final _storage = FlutterSecureStorage();
  EthPrivateKey? _credentials;
  EthereumAddress? _address;
  Web3Client? _ethClient;
  MoralisApiService moralisService = MoralisApiService();

  EthPrivateKey? get credentials => _credentials;
  EthereumAddress? get address => _address;

  Future<void> initializeWallet(String rpcUrl) async {
    _ethClient = Web3Client(rpcUrl, http.Client());
    String? privateKey = await _storage.read(key: 'privateKey');
    if (privateKey == null) {
      await createWallet();
    } else {
      _credentials = EthPrivateKey.fromHex(privateKey);
      _address = _credentials?.address;
      notifyListeners();
    }
  }

  Future<void> createWallet() async {
    var rng = Random.secure();
    _credentials = EthPrivateKey.createRandom(rng);
    _address = _credentials?.address;

    // await _storage.write(key: 'privateKey'
    //     '', value: hex.encode(_credentials!.privateKey));
    await _storage.write(key: 'privateKey'
        '', value: _credentials!.privateKey.toString());
    notifyListeners();
  }

  // String toHexString(Uint8List bytes) {
  //   return hex.encode(bytes);
  // }

  String toHexString(List<int> numbers) {
    final bytes = Uint8List.fromList(numbers);
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
  }

  Future<void> sendEth(String toAddress, amount) async {
    if (_credentials == null || _address == null) {
      throw Exception('Wallet is not initialized');
    }


    print('Transaction Hash:::::::::::_credentials!.privateKey::::::::::::::::::::::::::: ${_credentials!.privateKey}');

    try {
      final response = await moralisService.sendEth(
        _address!.hex,
        toAddress,
        toHexString(_credentials!.privateKey),
        amount,
      );
      print('Transaction Hash:::::::::::::::::::::::::::::::::::::: ${response['transaction_hash']}');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Successfully sent ETH: ${response['transaction_hash']}')),
      // );
    } catch (e) {
      print('Error sending ETH::::::::::::::::::::::: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to send ETH: $e')),
      // );
    }
  }

  Future<BigInt> getEthBalance() async {
    if (_address == null) return BigInt.zero;
    try {
      final balance = await moralisService.getEthBalance(_address!.hex);
      return BigInt.parse(balance['balance']);
    } catch (e) {
      print('Error fetching ETH balance: $e');
      return BigInt.zero;
    }
  }


  Future<void> transferETH(EthereumAddress to, BigInt amount) async {
    if (_credentials == null) return;

    final result = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction(
        to: to,
        value: EtherAmount.inWei(amount),
      ),
      chainId: 1,
    );
    print('Transaction Hash: $result');
  }

  Future<BigInt> getUsdtBalance(String usdtContractAddress) async {
    if (_address == null) return BigInt.zero;

    try {
      final balance = await moralisService.getUsdtBalance(_address!.hex, usdtContractAddress);
      return BigInt.parse(balance['balance']);
    } catch (e) {
      print('Error fetching USDT balance: $e');
      return BigInt.zero;
    }
  }

  Future<void> transferUSDT(EthereumAddress to, BigInt amount, String usdtContractAddress) async {
    if (_credentials == null) return;

    final contract = DeployedContract(
      ContractAbi.fromJson('YOUR_USDT_CONTRACT_ABI', 'USDT'),
      EthereumAddress.fromHex(usdtContractAddress),
    );

    final transferFunction = contract.function('transfer');
    final result = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: contract,
        function: transferFunction,
        parameters: [to, amount],
      ),
      chainId: 1,
    );
    print('USDT Transaction Hash: $result');
  }
}
