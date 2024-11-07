// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class MoralisApiService {
//   final String _appId = '7b547ee0-79ee-492f-a952-ca7159866629';
//   final String apiUrl = "https://deep-index.moralis.io/api/v2.2/erc20";
//   final String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6ImU3NDNhYzg1LTA5ZTctNGQ3Ni05MmNkLWQ1ZDJkMGEwNTg5ZSIsIm9yZ0lkIjoiNDA0Njk2IiwidXNlcklkIjoiNDE1ODM4IiwidHlwZUlkIjoiN2I1NDdlZTAtNzllZS00OTJmLWE5NTItY2E3MTU5ODY2NjI5IiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3MjM2OTYyOTMsImV4cCI6NDg3OTQ1NjI5M30.aTBXhoxJ1PhDWn7UpVwwImqV7_zgbsiJN8Pq62eaBYs";
//
//
//   //*************************************Code Start for get real time price using moralis*****************************************************************//
//   Future<Map<String, dynamic>> getTokenPrice(String tokenAddress) async {
//     final String endpointUrl = "$apiUrl/$tokenAddress/price?chain=eth&include=percent_change";
//     try {
//       final response = await http.get(
//         Uri.parse(endpointUrl),
//         headers: {
//           'accept': 'application/json',
//           'X-API-Key': apiKey,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to load token price');
//       }
//     } catch (e) {
//       print("Error fetching token price: $e");
//       return {};
//     }
//   }
//
//   Future<Map<String, dynamic>> getBtcPrice() async {
//     const String endpointUrl = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd";
//     try {
//       final response = await http.get(Uri.parse(endpointUrl));
//
//       // print('BTC Price Response Status:--------------- ${response.statusCode}');
//       // print('BTC Price Response Body:----------------- ${response.body}');
//
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to load BTC price. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error fetching BTC price: $e");
//       return {};
//     }
//   }
// //*************************************Code End for get real time price*****************************************************************//
//
// //*************************************Code Start for Wallet and send receive *****************************************************************//
//   Future<Map<String, dynamic>> getEthBalance(String address) async {
//     final response = await http.get(
//       // Uri.parse('$apiUrl/balance?chain=eth&address=$address'),
//       Uri.parse('https://deep-index.moralis.io/api/v2.2/balance?chain=eth&address=$address'),
//       headers: {
//         'X-API-Key': apiKey,
//       },
//     );
//
//     // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${response.body}');
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to fetch ETH balance');
//     }
//   }
//
//   // Future<void> getWalletBalance() async {
//   //   // Define the URL and headers
//   //   final url = 'https://deep-index.moralis.io/api/v2.2/0x5dfa1d664e0c7fef9cebbc7650950a244d96a210/balance?chain=eth';
//   //   final headers = {
//   //     'accept': 'application/json',
//   //     'X-API-Key': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6ImU3NDNhYzg1LTA5ZTctNGQ3Ni05MmNkLWQ1ZDJkMGEwNTg5ZSIsIm9yZ0lkIjoiNDA0Njk2IiwidXNlcklkIjoiNDE1ODM4IiwidHlwZUlkIjoiN2I1NDdlZTAtNzllZS00OTJmLWE5NTItY2E3MTU5ODY2NjI5IiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3MjM2OTYyOTMsImV4cCI6NDg3OTQ1NjI5M30.aTBXhoxJ1PhDWn7UpVwwImqV7_zgbsiJN8Pq62eaBYs'
//   //   };
//   //
//   //   try {
//   //     // Send the GET request
//   //     final response = await http.get(Uri.parse(url), headers: headers);
//   //
//   //     // Check if the request was successful
//   //     if (response.statusCode == 200) {
//   //       // Parse the JSON response
//   //       final data = jsonDecode(response.body);
//   //       print('Balance: ${data['balance']}');
//   //     } else {
//   //       print('Failed to load balance: ${response.statusCode}');
//   //     }
//   //   } catch (e) {
//   //     print('Error: $e');
//   //   }
//   // }
//
//
//   Future<Map<String, dynamic>> getUsdtBalance(String address, String contractAddress) async {
//     final response = await http.get(
//       Uri.parse('$apiUrl/balance?chain=eth&address=$address&contract=$contractAddress'),
//       headers: {
//         'X-API-Key': apiKey,
//       },
//     );
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to fetch USDT balance');
//     }
//   }
//
//   Future<Map<String, dynamic>> sendEth(
//       String fromAddress,
//       String toAddress,
//       String privateKey,
//       double amount,
//       ) async {
//     final String apiUrl = 'https://deep-index.moralis.io/api/v2.0/erc20/transfer';
//     // final apiUrl = Uri.parse("https://deep-index.moralis.io/api/v2/transaction/send");
//
//     final url = Uri.parse('$apiUrl');
//     final headers = {
//       'X-API-Key': apiKey,
//       'Content-Type': 'application/json',
//     };
//     final body = jsonEncode({
//       "chain": "eth",
//       'from_address': fromAddress,
//       'to_address': toAddress,
//       // 'amount': amount,
//       'value': (amount * 1e18).toString(),
//       'private_key': privateKey,
//     });
//
//     // print('Request Body::::::::::::::: $body');
//     final response = await http.post(url, headers: headers, body: body);
//
//     // print('Response Status Code:::::::::::::::: ${response.statusCode}');
//     // print('Response Body:::::::::::::: ${response.body}');
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to send ETH. Error: ${response.body}');
//     }
//   }
//
//   // Future<void> sendEth(String fromAddress, String toAddress, String amount) async {
//   //   final response = await http.post(
//   //     Uri.parse('$apiUrl/eth/transfer'),
//   //     headers: {
//   //       'accept': 'application/json',
//   //       'X-API-Key': apiKey,
//   //       // 'X-Parse-Application-Id': _appId,
//   //       // 'X-Parse-REST-API-Key': apiKey,
//   //     },
//   //     body: jsonEncode({
//   //       'from': fromAddress,
//   //       'to': toAddress,
//   //       'amount': amount,
//   //     }),
//   //   );
//   //
//   //   if (response.statusCode == 200) {
//   //     print('Transaction successful: ${response.body}');
//   //   } else {
//   //     throw Exception('Failed to send ETH');
//   //   }
//   // }
//
//   Future<void> sendUsdt(String fromAddress, String toAddress, String amount, String usdtContractAddress) async {
//     final response = await http.post(
//       Uri.parse('$apiUrl/erc20/transfer'),
//       headers: {
//
//         // 'X-Parse-Application-Id': _appId,
//         // 'X-Parse-REST-API-Key': apiKey,
//       },
//       body: jsonEncode({
//         'from': fromAddress,
//         'to': toAddress,
//         'amount': amount,
//         'contract': usdtContractAddress,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       print('USDT Transfer successful: ${response.body}');
//     } else {
//       throw Exception('Failed to send USDT');
//     }
//   }
// //*************************************Code End for Wallet and send receive *****************************************************************//
//
//
// }
