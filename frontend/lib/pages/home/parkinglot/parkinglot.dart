import 'dart:async';

import 'package:flutter/services.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ParkingLot extends StatefulWidget {
  const ParkingLot({Key? key}) : super(key: key);

  @override
  _ParkingLotState createState() => _ParkingLotState();
}

class _ParkingLotState extends State<ParkingLot> {
  Completer<GoogleMapController> _controller = Completer();
  Location location = new Location();
  static const LatLng _center = const LatLng(20.5937, 78.9629);
  Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  static const platform = const MethodChannel("razorpay_flutter");

  late Razorpay _razorpay;
  bool isloading=false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Book a Parking Lot'),
          backgroundColor: Colors.orange,
        ),
        body: isloading?Center(child:CircularProgressIndicator()):
          Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 6.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                compassEnabled: true,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.map, size: 36.0),
                        tooltip: 'Change map style',
                      ),
                      SizedBox(height: 16.0),
                      if(_markers.length==0)
                        FloatingActionButton(
                          onPressed: _onAddMarkerButtonPressed,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.orange,
                          child: const Icon(Icons.add_location, size: 36.0),
                          tooltip: 'Book a parking lot',
                        ),
                      if(_markers.length!=0)
                        FloatingActionButton(
                          onPressed: _removemarker,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Colors.orange,
                          child: const Icon(Icons.cancel, size: 36.0),
                          tooltip: 'Delete marker',
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),


        floatingActionButton: _markers.length!=0?FloatingActionButton(
          onPressed: openCheckout,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          backgroundColor: Colors.orange,
          child: const Icon(Icons.check, size: 36.0),
          tooltip: 'Book parking lot',
        ):null,
      ),
    );
  }
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    if (_markers.length == 0) {
      setState(() {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: 'Parking Lot',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }
  }

  void _removemarker() {
    setState(() {
      _markers = {};
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  } //tDs20OLyMkx04vjELSm3EasV
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_EgyLssKk9HUPEx',
      'amount': 2000,
      'name': 'Smart City Management',
      'description': 'Book a parking lot',
      'prefill': {'contact': '9432352622', 'email': 'souamdipdas18@yahoo.com'},
      'external': {
        'wallets': ['paytm', '']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      isloading=true;
    });

    CoolAlert.show(
      context: context,
      type: CoolAlertType.success,
      showCancelBtn: false,
      text: "SUCCESS: " + response.paymentId!,
      confirmBtnText: 'Next!',
      confirmBtnColor: Colors.orange,

    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      showCancelBtn: false,
      confirmBtnText: 'Try again!',
      text:  "ERROR: " + response.code.toString() + " - " + response.message!,
      confirmBtnColor: Colors.orange,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      showCancelBtn: false,
      confirmBtnText: 'Try again!',
      text: "EXTERNAL_WALLET: " + response.walletName!,
      confirmBtnColor: Colors.orange,
    );
  }
}
