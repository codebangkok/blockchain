import 'package:flutter/material.dart';
import 'package:wallet/bank_screen.dart';
import 'package:wallet/election_screen.dart';
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
                      // ignore: prefer_const_constructors
                      Text(
                        '', //TODO: show account address
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff6d7f99)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ignore: prefer_const_constructors
                          Text(
                            '', //TODO: balance ETH
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
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const Text(
                            'Eq:',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xff6d7f99)),
                          ),
                          // ignore: prefer_const_constructors
                          Text(
                            ' \$', //TODO: balance USD
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
                              // ignore: prefer_const_constructors
                              child: Text(
                                '', //TODO: connect or refresh text
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {}, //TODO: connect or refresh action
                            )
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
