import 'package:flutter/material.dart';
import 'package:places_app/components/blur_container.dart';
import 'package:places_app/components/search_address_map.dart';
import 'package:places_app/models/afiliado_model.dart';
import 'package:places_app/helpers/alerts_helper.dart' as alerts;
import 'package:places_app/routes/routes.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:places_app/services/afiliados_service.dart';

class EditarAfiliadoPage extends StatefulWidget {
  final Afiliado afiliado;

  const EditarAfiliadoPage({Key key, this.afiliado}) : super(key: key);
  @override
  _EditarAfiliadoPageState createState() => _EditarAfiliadoPageState();
}

class _EditarAfiliadoPageState extends State<EditarAfiliadoPage> {
   Size _size;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isSaving = false;
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController telefonoCtrl = new TextEditingController();
  TextEditingController ubicacionCtrl = new TextEditingController();
  AfiliadosService afiliadosService = new AfiliadosService();


  //TextEditingController rfcCtrl = new TextEditingController();
  //FirebaseDB db = FirebaseDB();
 
  double latitud = 0.0;
  double longitud = 0.0;
  @override
  Widget build(BuildContext context) {

    nombreCtrl.text = widget.afiliado.nombre;
    telefonoCtrl.text = widget.afiliado.telefono;
    ubicacionCtrl.text = widget.afiliado.ubicacion;
    latitud=widget.afiliado.latitud;
    longitud=widget.afiliado.longitud;


    print("editData");
     _size = MediaQuery.of(context).size;
    return Scaffold(
      
      appBar: AppBar(title: Text("Editar"), centerTitle: true),
      body: _formContainer() ,
    );
  }

  Widget _formContainer() {
    return BlurContainer(
        isLoading: isSaving,
        text: "Actualizando",
        children: [
          Container(
      width: _size.width,
      height:_size.height,
          child: Form(
        key: _formKey,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              //color: Colors.white,
              color: Colors.white70,
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            padding: EdgeInsets.all(20.0),
            width: _size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        "Editar",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Edicion Afiliado",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                
                  TextFormField(
                    controller: nombreCtrl,
                    decoration: InputDecoration(
                      labelText: 'Razón social',
                    ),
                  ),
                  TextFormField(
                    controller: telefonoCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Número telefónico',
                    ),
                  ),
                  
                  Container(

                    child: Stack(
                      children: [
                        TextFormField(
                        readOnly: true,
                        controller: ubicacionCtrl,
                        decoration: InputDecoration(
                          labelText: 'Ubicación',
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        //height: double.infinity,
                        child: Column(children: [
                          Row(
                            children: [
                              Expanded(child: Container()),
                              IconButton(icon: Icon(Icons.map), onPressed: (){

                                _buildDireccion();

                              })
                            ],
                          )
                        ],),
                      )
                      ],
                       
                    ),
                  ),
                 
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: FlatButton(
                      minWidth: _size.width * 0.4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: handleEditar,
                      child: Text(
                        "Editar",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    )
        ],
      );
    
    ;
  }

  void handleEditar() async {
    //TODO: Register
    try {
      setIsSaving(true);
     

      Afiliado afiliado = new Afiliado(
        id: widget.afiliado.id,
        nombre: nombreCtrl.text,
        categoria:widget.afiliado.categoria,
        telefono: telefonoCtrl.text,
        latitud: latitud,
        longitud: longitud,
        rfc: widget.afiliado.rfc,
        img: widget.afiliado.img,
        fotos: widget.afiliado.fotos,
        user: widget.afiliado.user,
        ubicacion: ubicacionCtrl.text,
        aprobado: widget.afiliado.aprobado,
        rating: widget.afiliado.rating,
        puntos: widget.afiliado.puntos
        
      );
      //db.crearAfiliado(afiliado);
    await  afiliadosService.updateDocument(afiliado);
      alerts.success(context, "Actualizacion exitosa",
          "Sus datos fueron actualizados con exito.", f: () {
        Navigator.pushReplacementNamed(context, home);
        
      });

      setIsSaving(false);
    } catch (e) {
      print(e.toString());
      alerts.error(
          context, "Error", "Ocurrió un error al registrar la afiliación");
      setIsSaving(false);
    }
  }
void setIsSaving(bool val) {
    setState(() {
      isSaving = val;
    });
  }

   _buildDireccion(){
    return Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        apiKey:
                            "AIzaSyAooU8mIMwUlN7ff68cRS7ppxTuOUY1Vu4", // Put YOUR OWN KEY here.
                        onPlacePicked: (result) {
                          print(result.geometry.location);
                          Navigator.of(context).pop();
                        },
                        initialPosition: SearchAddressMap.kInitialPosition,
                        enableMapTypeButton:false,
                        automaticallyImplyAppBarLeading: true,
                        useCurrentLocation: true,
                        usePinPointingSearch: true,
                        enableMyLocationButton:false,
                        usePlaceDetailSearch: true,
                        autocompleteLanguage: "es",
                        selectedPlaceWidgetBuilder:
                            (_, selectedPlace, state, isSearchBarFocused) {
                          print(
                              "state: $state, isSearchBarFocused: $isSearchBarFocused");
                              String lat = "";
                              String lng = "";

                              if(state != SearchingState.Searching){
                              lat =selectedPlace.geometry.location.lat.toString() ;
                              lng =selectedPlace.geometry.location.lng.toString();
                              }
                          return isSearchBarFocused
                              ? Container()
                              : FloatingCard(
                                  bottomPosition:
                                      0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                  leftPosition: 0.0,
                                  rightPosition: 0.0,
                                  width: 500,
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: state == SearchingState.Searching
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Container(
                                        child: Column(
                                          children: [
                                            Text(selectedPlace.name),
                                            //Text("Lat: $lat Lnt: $lng"),
                                           
                                            RaisedButton(
                                                child: Text("Guardar Direccion"),
                                                onPressed: () {

                                                  latitud = selectedPlace.geometry.location.lat;
                                                  longitud = selectedPlace.geometry.location.lng;
                                                  ubicacionCtrl.text = selectedPlace.name;
                                                  // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                                                  //            this will override default 'Select here' Button.
                                                  print(
                                                      "do something with [selectedPlace] data");
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                          ],
                                        ),
                                      ),
                                );
                        },
                      ),
                    ),
                  );
  }

 

}