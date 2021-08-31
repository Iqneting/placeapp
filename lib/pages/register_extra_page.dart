import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:places_app/components/blur_container.dart';
import 'package:places_app/helpers/alerts_helper.dart';
import 'package:places_app/models/usuario_model.dart';
import 'package:places_app/models/vehiculo_model.dart';
import 'package:places_app/routes/constantes.dart';
import 'package:places_app/services/user_service.dart';
import 'package:places_app/services/vehiculo_service.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';
import '../const/const.dart';
class RegisterExtraPage extends StatefulWidget {
  final String emailArg;
  final bool isNew;
  final String placa;
  const RegisterExtraPage(this.emailArg, this.isNew,{this.placa});
  @override
  _RegisterExtraPageState createState() => _RegisterExtraPageState();
}

class _RegisterExtraPageState extends State<RegisterExtraPage> {
  //Global Key
  final _formKey = GlobalKey<FormState>();
  //Size Screen
  MediaQueryData mq;
  //SharePrefenrence
  UserPreferences preferences = new UserPreferences();
  //Services
  VehiculoService vehiculoService = VehiculoService();
  //TextEditControllers
  TextEditingController _licenciaController = TextEditingController();
  TextEditingController _telefonoSeguroController = TextEditingController();
  TextEditingController _numeroPolizaSeguroController = TextEditingController();
  TextEditingController _placaController = TextEditingController();
  TextEditingController _fechaVencimientoLicenciaController = TextEditingController();
  TextEditingController _fechaVencimientoPolizaController = TextEditingController();
  TextEditingController _vencimientoVerificacioController = TextEditingController();
  TextEditingController _fechaPagoTenenciaController = TextEditingController();
  //Datetimes
  DateTime _dateLicencia;
  DateTime _dateSeguro;
  DateTime _datePagoTendencia;
  DateTime _dateVencimientoVerificacion;
  //Otros
  //bool isAfiliado = false;
  bool isSubmitting = false;
  bool isFirstLoad = true;
  AppState _appState;
  UserService userService = UserService();
  //Vehiculo
  VehiculoModel vehiculoModel = VehiculoModel(
    correo: '', 
    fechaPagoTenencia: '', 
    fechaVencimientoLicencia: '', 
    fechaVencimientoPoliza: '', 
    licencia: '', 
    placa: '', 
    seguro: '', 
    telefonoSeguro: '', 
    vencimientoVerificacio: ''
  );
  String idVehiculo;
  Future<QuerySnapshot> futureVehiculo;

  @override
  void initState() {
    futureVehiculo = vehiculoService.getVehiculo(widget.emailArg, widget.placa);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context);
    _appState = Provider.of<AppState>(context);
    return WillPopScope(
      onWillPop: () async => widget.isNew?false:true,
        child: Scaffold(
        body: widget.isNew?formulario():formularioLleno()
      ),
    );
  }
  //__________________________________________________Widgets
  Widget formulario(){
    return Form(
      key: _formKey,
      child: BlurContainer(
        isLoading: isSubmitting,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 36.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logo(),
                  titulo(),
                  campos(),
                  bottom(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget formularioLleno(){
    return FutureBuilder(
      future: futureVehiculo,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (isFirstLoad) {
            idVehiculo = snapshot.data.docs.first.id;
            vehiculoModel = VehiculoModel.fromJson(snapshot.data.docs.first.data());
            isFirstLoad=false;
            _placaController.text = vehiculoModel.placa;
            _telefonoSeguroController.text = vehiculoModel.telefonoSeguro;
            _numeroPolizaSeguroController.text = vehiculoModel.seguro;
            _fechaVencimientoPolizaController.text = vehiculoModel.fechaVencimientoPoliza;
            _licenciaController.text = vehiculoModel.licencia;
            _fechaVencimientoLicenciaController.text = vehiculoModel.fechaVencimientoLicencia;
            _vencimientoVerificacioController.text = vehiculoModel.vencimientoVerificacio;
            _fechaPagoTenenciaController.text = vehiculoModel.fechaPagoTenencia;
          }
          return formulario();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget logo(){
    return Image.asset("assets/images/logo.png",height: (mq.size.height / 8),);
  }

  Widget titulo(){
    return Text(
      "Registro de Vehículo",
      style: TextStyle(color: Colors.black87,fontSize: 20.0,fontWeight: FontWeight.w500),
    );
  }

  Widget campos(){
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          campoTexto(_placaController, TextInputType.text, 'Placa', 'Placa', 'Ingrese su placa',true),
          campoTexto(_telefonoSeguroController, TextInputType.phone, "Teléfono", "Teléfono para emergencia de tu seguro", 'Teléfono es requerido',true),
          campoTexto(_numeroPolizaSeguroController, TextInputType.datetime, "Número", "Número póliza de seguro", 'Número es requerido',true),
          campoTexto(_fechaVencimientoPolizaController, TextInputType.datetime, "Ingrese la vigencia de su póliza de seguro", "Fecha vencimiento póliza de seguro", 'Ingrese la vigencia de su póliza de seguro', false),
          botonCalendario("Seleccione la fecha de vencimiento",_dateSeguro ,vehiculoModel.fechaVencimientoPoliza,_fechaVencimientoPolizaController),
          campoTexto(_licenciaController, TextInputType.text, "Número", "Número licencia", 'Número es requerido', true),
          campoTexto(_fechaVencimientoLicenciaController, TextInputType.text, "Vigencia de tu licencia", "Fecha vencimiento licencia", 'Ingrese la vigencia de su licencia', false),
          botonCalendario('Seleccione la fecha de vencimiento', _dateLicencia, vehiculoModel.fechaVencimientoLicencia, _fechaVencimientoLicenciaController),
          campoTexto(_vencimientoVerificacioController, TextInputType.text, "Introduce vencimiento de verificación", "Fecha vencimiento verificación", 'Ingrese la vigencia de su licencia', false),
          botonCalendario('Seleccione la fecha de vencimiento', _dateVencimientoVerificacion, vehiculoModel.vencimientoVerificacio, _vencimientoVerificacioController),
          campoTexto(_fechaPagoTenenciaController, TextInputType.datetime, "Ingrese fecha pago tenencia", "Fecha pago tenencia", 'Ingrese fecha pago tenencia', false),
          botonCalendario('Seleccione la fecha de pago', _datePagoTendencia, vehiculoModel.fechaPagoTenencia, _fechaPagoTenenciaController)
        ],
      ),
    );
  }

  Widget campoTexto(TextEditingController controller,TextInputType typeText,String hint,String label,String validatorText,bool isEnable){
    return TextFormField(
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      keyboardType: typeText,
      enabled: isEnable,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red,)),
        hintText: hint,
        labelText: label,
        hintStyle: TextStyle(color: kBaseColor)
      ),
      validator: (String value) {
        //if(widget.isNew==false){return null;}
        if (value.isEmpty) {
          return validatorText;
        }
        return null;
      },
      onSaved: (String value) {
        controller.text = value;
      }
    );
  }

  Widget botonCalendario(String texto,DateTime fechaAsignar,String fechaEvaluar,TextEditingController controller){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text(texto,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white)
          ),
          color: kBaseColor,
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate:widget.isNew?fechaAsignar == null ? DateTime.now() : fechaAsignar:DateTime.parse(fechaEvaluar+' 00:00:00.000')
                        ,
                    firstDate:widget.isNew?fechaAsignar == null ? DateTime.now() : fechaAsignar:DateTime.parse(fechaEvaluar+' 00:00:00.000'),
                    lastDate: DateTime(2050),
                    cancelText: 'Cancelar')
                .then((date) {
              setState(() {
                fechaAsignar = date;
                var dateAux = date.toIso8601String().split("T")[0];
                controller.text = dateAux;
              });
            });
          },
        )
      ],
    );
  }

  Widget bottom(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(25.0),
          color: kBaseColor,
          child: MaterialButton(
            minWidth: mq.size.width / 1.2,
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            child: Text(
              "Continuar",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: handleRegister,
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  //__________________________________________________Functions
  void handleRegister() async {
    try {
      setState(() {isSubmitting = true;});
      if (!_formKey.currentState.validate()) {
        setState(() {isSubmitting = false;});
        return;
      } else {
        VehiculoModel vehiculo;
        bool bandera = false;
        if (widget.emailArg != null) {
          //Ingresar vehiculo
          vehiculo = VehiculoModel(
            correo: widget.emailArg,
            fechaPagoTenencia: _fechaPagoTenenciaController.text,
            fechaVencimientoLicencia: _fechaVencimientoLicenciaController.text, 
            fechaVencimientoPoliza: _fechaVencimientoPolizaController.text, 
            licencia: _licenciaController.text, 
            placa: _placaController.text, 
            seguro: _numeroPolizaSeguroController.text, 
            telefonoSeguro: _telefonoSeguroController.text, 
            vencimientoVerificacio: _vencimientoVerificacioController.text
          );
          if (widget.isNew) {//Ingreso
            bandera = await vehiculoService.crearVehiculo(vehiculo);
          } else { //Edicion
            bandera = await vehiculoService.updateVehiculo(vehiculo,idVehiculo);
          }
        }
        _formKey.currentState.save();
        setState(() {isSubmitting = false;});
        if (bandera) {
          _appState.isInvitado = false;
          success(context, "Perfil Completado", "Su registro ha sido exitoso",false,
              f: () {
            setState(() {
              isSubmitting = false;
            });
            Navigator.pushNamedAndRemoveUntil(context, homeRoute, (Route<dynamic> route) => false);

            //Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (Route<dynamic> route) => false);
            //Navigator.of(context).popUntil(ModalRoute.withName(homeRoute));
          });
        }
      }
    } catch (e) {
      setState(() {isSubmitting = false;});
      print('error $e');
    }
  }
}
