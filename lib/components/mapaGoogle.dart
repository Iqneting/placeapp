import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:places_app/models/ubicacion_afiliado_model.dart';

class MapaGoogleComponent extends StatefulWidget {
  final String categoria;

  const MapaGoogleComponent({Key key,@required this.categoria}) : super(key: key);
  @override
  _MapaGoogleComponentState createState() => _MapaGoogleComponentState();
}

class _MapaGoogleComponentState extends State<MapaGoogleComponent> {
  GoogleMapController _controller;
  Location location = new Location();
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool _serviceEnabled;
  bool isLoading = false;
  bool isLoadMarket = false;
  Set<Marker> _markets = HashSet<Marker>();
  List<UbicacionAfiliado> ubicacionAfiliados = [];

  @override
  void initState() {
    initUbicacion();
    init();
    super.initState();
  }
  void initUbicacion() async {
    String categoriaTemporal =widget.categoria.trim();
    this.ubicacionAfiliados = await UbicacionAfiliado.fetchData(categoriaTemporal);
    print("ubicacionAfiliados");
    print(ubicacionAfiliados);
    /*this.ubicacionAfiliados.asMap().entries.map((e) {
      _buildMarker(e.value);
      });*/
      this.ubicacionAfiliados.forEach((element) {
        _buildMarker(element);

       });
    setState(() {
      isLoadMarket = false;
    });
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      isLoading = false;
    });


  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final lat = _locationData.latitude ?? 0.0;
    final long = _locationData.longitude ?? 0.0;
    return Container(
        child: GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(lat, long), zoom: 13.0),
      mapType: MapType.normal,
      onMapCreated: (controller) {
        _controller = controller;
      },
      onTap: (cordinate) {
        _controller.animateCamera(CameraUpdate.newLatLng(cordinate));
      },
       markers: _markets,
    ));
  }
   _buildMarker (UbicacionAfiliado ubicacion) {


     print(ubicacion);
     setState(() {

        _markets.add(Marker(
    markerId: MarkerId(ubicacion.nombre),
    position: LatLng(ubicacion.latitud, ubicacion.longitud),
    infoWindow: InfoWindow(title: ubicacion.nombre),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
   

  ));
       
     });
    
    
  }
}
