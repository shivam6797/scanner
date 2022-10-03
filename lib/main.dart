import 'dart:developer';
import 'dart:io';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrscanner/widget/grabbing_widget.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

void main() => runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Demo Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QRViewExample(),
            ));
          },
          child: const Text('qrView'),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  String resultStr = "";
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          leading: const Icon(
            FontAwesomeIcons.bars,
            color: Colors.white,
            size: 18,
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                FontAwesomeIcons.bowlFood,
                color: Colors.white,
                size: 18,
              ),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            _buildQrView(context),
            Positioned(
              child: resultStr != "" ? bottomNavigationBar() : SizedBox(),
            )
          ],
        ),
        // bottomNavigationBar: resultStr != ""?bottomNavigationBar():SizedBox(),
        // bottomSheet: resultStr != "" ? bottomNavigationBar() : SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: resultStr == ""
            ? Container(
                color: Colors.transparent,
                height: MediaQuery.of(context).size.height / 4.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(239, 239, 239, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.black87,
                        size: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      " Data: ${result?.code}",
                      style: const TextStyle(
                          color: Color.fromRGBO(239, 239, 239, 1),
                          fontSize: 13,
                          fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(239, 239, 239, 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 70,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(80),
                                  topRight: Radius.circular(100),
                                  bottomLeft: Radius.circular(80),
                                  bottomRight: Radius.circular(100),
                                )),
                            child: Image.asset("assets/images/cbimage.png"),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  FontAwesomeIcons.cartShopping,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '\$30.2',
                                  style: TextStyle(
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox());
  }

  bottomNavigationBar() {
    final ScrollController listViewController = ScrollController();
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setter) => SnappingSheet(
        child:Container(color: Colors.transparent),
        lockOverflowDrag: true,
        snappingPositions:const [
          SnappingPosition.factor(
            positionFactor: 0.8,
            snappingCurve: Curves.easeOutExpo,
            snappingDuration: Duration(seconds: 1),
            grabbingContentOffset: GrabbingContentOffset.top,
          ),
          SnappingPosition.factor(
            snappingCurve: Curves.elasticOut,
            snappingDuration: Duration(milliseconds: 1750),
            positionFactor: 0.5,
          ),
          SnappingPosition.factor(
            grabbingContentOffset: GrabbingContentOffset.bottom,
            snappingCurve: Curves.easeInExpo,
            snappingDuration: Duration(seconds: 1),
            positionFactor: 0.8,
          ),
        ],
        grabbing: const GrabbingWidget(),
        grabbingHeight: 65,
        sheetAbove: null,
        sheetBelow: SnappingSheetContent(
          draggable: false,
          childScrollController: listViewController,
          child: Container(
            color: Colors.white,
            child: Stack(
              // shrinkWrap: true,
              children: [
                ListView.builder(
                    controller: listViewController,
                    itemCount: 8,
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            height: 60,
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "1",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Red Bull",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      Text("160z",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                      Text("\$2.50",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  )
                                ],
                              ),
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Icon(
                                              FontAwesomeIcons.ticketSimple,
                                              color: Colors.amber[200],
                                              size: 15,
                                            ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Deal",
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("\$2.50",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  ), // icon-2
                                ],
                              ),
                            )),
                      );
                    }),
                // Positioned(
                //   top: 400,
                  
                //   child: Container(
                //     color: Colors.black,
                //     height: MediaQuery.of(context).size.height / 4.0,
                //     width: MediaQuery.of(context).size.width,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Container(
                //           height: 60,
                //           margin: const EdgeInsets.symmetric(
                //               horizontal: 40, vertical: 35),
                //           decoration: BoxDecoration(
                //             color: const Color.fromRGBO(239, 239, 239, 1),
                //             borderRadius: BorderRadius.circular(30),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               Material(
                //                 shape: const RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.only(
                //                     topLeft: Radius.circular(80),
                //                     topRight: Radius.circular(100),
                //                     bottomLeft: Radius.circular(80),
                //                     bottomRight: Radius.circular(100),
                //                   ),
                //                 ),
                //                 elevation: 2,
                //                 child: Container(
                //                   width: MediaQuery.of(context).size.width / 2.3,
                //                   height: 70,
                //                   decoration: const BoxDecoration(
                //                     color: Colors.white,
                //                     borderRadius: BorderRadius.only(
                //                       topLeft: Radius.circular(80),
                //                       topRight: Radius.circular(100),
                //                       bottomLeft: Radius.circular(80),
                //                       bottomRight: Radius.circular(100),
                //                     ),
                //                     // boxShadow: [
                //                     //   BoxShadow(
                //                     //     color: Colors.white,
                //                     //     offset:
                //                     //         const Offset(20.0, 10.0),
                //                     //     blurRadius: 20.0,
                //                     //     spreadRadius: 10.0,
                //                     //   ), //BoxShadow
                //                     // ],
                //                   ),
                //                   child:
                //                   Image.asset("assets/images/cbimage.png"),
                //                 ),
                //               ),
                //               Container(
                //                 padding: const EdgeInsets.only(left: 15),
                //                 child: Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceEvenly,
                //                   children: const [
                //                     Icon(
                //                       FontAwesomeIcons.cartShopping,
                //                       color: Colors.black,
                //                       size: 25,
                //                     ),
                //                     SizedBox(
                //                       width: 10,
                //                     ),
                //                     Text(
                //                       '\$30.2',
                //                       style: TextStyle(
                //                           color: Colors.black,
                //                           overflow: TextOverflow.ellipsis,
                //                           fontSize: 15,
                //                           fontWeight: FontWeight.bold),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 300)
        ? 260.0
        : 120.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.white,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 5,
        cutOutBottomOffset: 120,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        resultStr = result!.code.toString();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
