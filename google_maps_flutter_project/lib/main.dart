import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_project/location_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Varaždin',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  TextEditingController _searchController=TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  int _markerCounter =1;


  static final CameraPosition _kVarazdin= CameraPosition(
    target: LatLng(46.3126731,16.3510191),
    zoom: 13,
  );

  static final CameraPosition _kFOI = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(46.3074493,16.3379843),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


  

  

    static final Polygon _kPolygon = Polygon(
      polygonId: PolygonId('_kPolygon'),
      points: [
        LatLng(46.3222016154462,16.358791335775237),
        LatLng(46.3126731,16.3510191),
        LatLng(46.3084143,16.3478216),
        LatLng(46.3074493,16.3379843),
        LatLng(46.310163,16.3338949),
        LatLng(46.3133982,16.3427279),
        LatLng(46.3222016154462,16.358791335775237)

      ],
      strokeWidth: 2,
      fillColor: Colors.transparent,
      strokeColor: Colors.red
      );

  void _setMarker(Map<String, dynamic> place) async{
      final double lat = place['geometry']['location']['lat'];
      final double lng = place['geometry']['location']['lng'];
    
    setState(() {
      _markers.add(
        Marker(markerId: MarkerId("marker"+_markerCounter.toString()),
        position: LatLng(lat,lng),
        infoWindow: InfoWindow(title: _searchController.text)  

      ));
    });
    _markerCounter++;
  }


 

  @override
  Widget build(BuildContext context) {

    _markers.add(
      Marker
      (markerId: MarkerId('_kVarazdin'),
      infoWindow: InfoWindow(title: 'Varaždin'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(46.3126731,16.3510191)
      ),
    );
    _markers.add(
      Marker
      (markerId: MarkerId('_kFOI'),
      infoWindow: InfoWindow(title: 'FOI'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(46.3074493,16.3379843)
      ),
    );

    _markers.add(
      Marker
      (markerId: MarkerId('_kStariGrad'),
      infoWindow: InfoWindow(title: 'StariGrad'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(46.310163,16.3338949)
      ),
    );
    _markers.add(
      Marker
      (markerId: MarkerId('_kMost'),
      infoWindow: InfoWindow(title: 'Most Bana Josipa Jelačića'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(46.3222016154462,16.358791335775237)
      ),
    );

    _markers.add(
      Marker
      (markerId: MarkerId('_kSCVZ'),
      infoWindow: InfoWindow(title: 'SCVZ'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      position: LatLng(46.3084143,16.3478216)
      ),
    );
    _markers.add(
      Marker
      (markerId: MarkerId('_kTTS'),
      infoWindow: InfoWindow(title: 'TTS sportski centar'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: LatLng(46.3133982,16.3427279)
      ),
    );
    return new Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        ),
      body: Column(
        children:[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'Pretraži grad'),
                onChanged: (value){
                  print(value);
                },
              )),
              
              IconButton(onPressed: () async{
                  
                var place = await LocationService().getPlace(_searchController.text);
                _goToThePlace(place);
                _setMarker(place);
                
              }, icon: Icon(Icons.search),),
            ],
          ),
          Expanded(child: 
       GoogleMap(
        mapType: MapType.hybrid,
        markers:  _markers, 
        polygons: {_kPolygon},
        
        initialCameraPosition: _kVarazdin,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        
      ))],
      
    ),
    floatingActionButton:
     Row(
      
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(padding: EdgeInsets.only(left: 30)),
        FloatingActionButton.extended(
        onPressed: _goToFOI,
        label: Text('FOI'),
        icon: Icon(Icons.house)
      ),
      Expanded(child: Container()),
      FloatingActionButton.extended(
        onPressed: _goToVarazdin,
        label: Text('Varaždin'),
        icon: Icon(Icons.location_city),
      ),
      ],
      )
    
      
      
      );
    
  }

  Future<void> _goToThePlace(Map<String, dynamic> place) async {
      final double lat = place['geometry']['location']['lat'];
      final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat,lng),zoom: 12),
    ));
    
  }

  Future<void> _goToFOI() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kFOI));
  }

  Future<void> _goToVarazdin() async {
    
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kVarazdin));
  }
}