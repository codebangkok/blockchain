import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:wallet/bank_screen.dart';
import 'package:wallet/election_screen.dart';
import 'package:wallet/helpers.dart';
import 'package:wallet/will_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bankScreen = BankScreen();
  final willScreen = WillScreen();
  final electionScreen = ElectionScreen();

  var _account = '';
  var _balanceEth = '';
  var _balanceUsd = '';
  var _isConnected = false;

  Future checkBalance() async {
    final balance = await provider!.getSigner().getBalance();
    setState(() {
      _balanceEth = weiToEth(balance);
      _balanceUsd = weiToUsd(balance);
    });
  }

  Future connect() async {
    if (ethereum == null) {
      await showDialogError(context: context, message: 'No MetaMask extension');
      return;
    }
    try {
      final accounts = await ethereum!.requestAccount();
      setState(() {
        _account = accounts[0];
        _isConnected = true;
      });
    } catch (ex) {
      await showDialogError(context: context, message: ethereumException(ex));
      return;
    }

    await checkBalance();

    ethereum!.onAccountsChanged((accounts) async {
      final account = await provider!.getSigner().getAddress();
      final balance = await provider!.getSigner().getBalance();
      setState(() {
        _account = account;
        _balanceEth = weiToEth(balance);
        _balanceUsd = weiToUsd(balance);
      });
    });

    ethereum!.onChainChanged((chainId) async {
      await checkBalance();
    });

    bankScreen.connect();
    willScreen.connect();
    electionScreen.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF000D36),
        title: const Text('INFINITAS'),
      ),
      body: ListView(
        children: [
          buildWallet(),
          const SizedBox(height: 20),
          bankScreen,
          const SizedBox(height: 20),
          willScreen,
          const SizedBox(height: 20),
          electionScreen,
        ],
      ),
    );
  }

  Widget buildWallet() {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(40)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .35,
          color: const Color(0xff15294a),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _account, //TODO: show account address
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff6d7f99)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _balanceEth, //TODO: balance ETH
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Color(0xffe7ad03),
                            ),
                          ),
                          Text(
                            ' ETH',
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500, color: const Color(0xfffbbd5c).withAlpha(200)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Eq:',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff6d7f99)),
                          ),
                          Text(
                            ' \$$_balanceUsd', //TODO: balance USD
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.link,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              child: Text(
                                _isConnected ? "refresh" : "connect", //TODO: connect or refresh text
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_isConnected) {
                                  await checkBalance();
                                } else {
                                  await connect();
                                }
                              }, //TODO: connect or refresh action
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                left: -170,
                top: -170,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Color(0xff3554d3),
                ),
              ),
              const Positioned(
                left: -160,
                top: -190,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Color(0xff375efd),
                ),
              ),
              const Positioned(
                right: -170,
                bottom: -170,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Color(0xffe7ad03),
                ),
              ),
              const Positioned(
                right: -160,
                bottom: -190,
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Color(0xfffbbd5c),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
