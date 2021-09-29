import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _ethUsdRate = 3000.00;
const chainId = 4;
const explorerAddressUrl = 'https://rinkeby.etherscan.io/address';
const explorerTxUrl = 'https://rinkeby.etherscan.io/tx';

String weiToEth(BigInt wei) {
  final result = wei / BigInt.from(pow(10, 18));
  var f = NumberFormat("#,###.#####");
  return f.format(result);
}

String weiToUsd(BigInt wei) {
  final result = wei / BigInt.from(pow(10, 18));
  var f = NumberFormat("#,###.##");
  return f.format(result * _ethUsdRate);
}

String ethereumException(ex) {
  final str = ex.toString();
  if (str == "[object Object]") return 'User Rejected';
  final index = str.indexOf("\"message\"") + 11 + 20;
  final index2 = str.indexOf("\"", index);
  return str.substring(index, index2);
}

Future showDialogError({required BuildContext context, required String message}) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text(
        'ERROR',
        textAlign: TextAlign.start,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        message,
        textAlign: TextAlign.start,
      ),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}

SizedBox buildButton({required String text, Function()? onPressed}) {
  return SizedBox(
    width: 120,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff3554d3),
        onPrimary: Colors.white,
        textStyle: const TextStyle(
          fontSize: 20,
        ),
      ),
    ),
  );
}
