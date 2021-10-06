import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'helpers.dart';

// ignore: must_be_immutable
class BankScreen extends StatelessWidget {
  BankScreen({Key? key}) : super(key: key);

  final depositKey = GlobalKey<FormState>();
  final withdrawKey = GlobalKey<FormState>();

  final depositInputController = TextEditingController(text: '1');
  final withdrawInputController = TextEditingController(text: '1');

  Contract? _bankContract;
  final _bankAddress = '0xC4CF2D8BF521846a18C5992f100f10C65C968078';
  final _bankAbi =
      '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Deposit","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Withdraw","type":"event"},{"inputs":[],"name":"balance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"deposit","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"}]';

  void connect() {
    _bankContract = Contract(
      _bankAddress,
      Interface(_bankAbi),
      provider!.getSigner(),
    );

    _bankContract!.on('Deposit', (owner, amount, event) {
      // ignore: avoid_print
      print('Deposit: $owner = $amount');
    });

    _bankContract!.on('Withdraw', (owner, amount, event) {
      // ignore: avoid_print
      print('Withdraw: $owner = $amount');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: const Color(0xff15294a),
        shadowColor: Colors.grey,
        borderOnForeground: true,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 30, left: 10, right: 10),
          child: Column(
            children: [
              TextButton(
                onPressed: () => html.window.open('$explorerAddressUrl/$_bankAddress', '_blank'), //TODO: open smart contract explorer
                child: const Text(
                  'Bank',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xfffbbd5c),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildButton(
                    text: 'Deposit',
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Deposit (ETH)'),
                          content: Form(
                            key: depositKey,
                            child: TextFormField(
                              controller: depositInputController,
                              keyboardType: TextInputType.number,
                              validator: (value) => value == null || value.isEmpty ? "required" : null,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                if (!(depositKey.currentState?.validate() ?? false)) return;

                                //TODO: deposit action
                                final amount = double.parse(depositInputController.text) * pow(10, 18);
                                depositInputController.text = '1';
                                Navigator.of(context).pop();

                                try {
                                  final tx = await _bankContract!.send('deposit', [], TransactionOverride(value: BigInt.from(amount)));
                                  html.window.open('$explorerTxUrl/${tx.hash}', '_blank');
                                } catch (ex) {
                                  await showDialogError(context: context, message: ethereumException(ex));
                                }
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                depositInputController.text = '1';
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  buildButton(
                    text: 'Withdraw',
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Withdraw (ETH)'),
                          content: Form(
                            key: withdrawKey,
                            child: TextFormField(
                              controller: withdrawInputController,
                              keyboardType: TextInputType.number,
                              validator: (value) => value == null || value.isEmpty ? "required" : null,
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                if (!(withdrawKey.currentState?.validate() ?? false)) return;

                                //TODO: withdraw action
                                final amount = double.parse(withdrawInputController.text) * pow(10, 18);
                                withdrawInputController.text = '1';
                                Navigator.of(context).pop();

                                try {
                                  final tx = await _bankContract!.send('withdraw', [amount.toString()]);
                                  html.window.open('$explorerTxUrl/${tx.hash}', '_blank');
                                } catch (ex) {
                                  await showDialogError(context: context, message: ethereumException(ex));
                                }
                              },
                            ),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                withdrawInputController.text = '1';
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  buildButton(
                    text: 'Balance',
                    onPressed: () async {
                      //TODO: check balance action
                      var bankBalanceEth = '';
                      var bankBalanceUsd = '';
                      try {
                        final bankBalance = await _bankContract!.call<BigInt>('balance');
                        bankBalanceEth = weiToEth(bankBalance);
                        bankBalanceUsd = weiToUsd(bankBalance);
                      } catch (ex) {
                        await showDialogError(context: context, message: ethereumException(ex));
                        return;
                      }

                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(
                            '$bankBalanceEth ETH',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'Eq: \$$bankBalanceUsd',
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
