import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:places_app/components/blur_container.dart';
import 'package:places_app/helpers/alerts_helper.dart';
import 'package:places_app/models/usuario_model.dart';

import 'package:places_app/routes/routes.dart';
import 'package:places_app/services/user_service.dart';
import 'package:places_app/shared/user_preferences.dart';
import 'package:places_app/storage/App.dart';
import 'package:provider/provider.dart';

import '../const/const.dart';

class RegisterExtraPage extends StatefulWidget {
  //RegisterExtraPage({Key key}) : super(key: key);
  final String emailArg;

  const RegisterExtraPage(this.emailArg);
  @override
  _RegisterExtraPageState createState() => _RegisterExtraPageState();
}

class _RegisterExtraPageState extends State<RegisterExtraPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _licenciaController = TextEditingController();
  TextEditingController _telefonoSeguroController = TextEditingController();
  TextEditingController _numeroPolizaSeguroController = TextEditingController();
  TextEditingController _placaController = TextEditingController();

  TextEditingController _fechaVencimientoLicenciaController =
      TextEditingController();
  TextEditingController _fechaVencimientoPolizaController =
      TextEditingController();
  TextEditingController _vencimientoVerificacioController =
      TextEditingController();
  TextEditingController _fechaPagoTenenciaController = TextEditingController();

  MediaQueryData mq;
  bool isAfiliado = false;
  UserPreferences preferences = new UserPreferences();
  bool isSubmitting = false;
  AppState _appState;

  //String emailArg = null;
  UserService userService = UserService();
  void handleRegister() async {
    try {
      setState(() {
        isSubmitting = true;
      });
      if (!_formKey.currentState.validate()) {
        setState(() {
          isSubmitting = false;
        });
        return;
      } else {
        //TODO: continuar registro 2
        _formKey.currentState.save();
        setState(() {
          isSubmitting = false;
        });
        Usuario user;
        bool bandera = false;
        if (widget.emailArg != null) {
          user = await userService.getUsuario(widget.emailArg);
          user.licencia = _licenciaController.text;
          user.seguro = _numeroPolizaSeguroController.text;
          user.placa = _placaController.text;
          user.telefonoSeguro = _telefonoSeguroController.text;
          user.fechaPagoTenencia = _fechaPagoTenenciaController.text;
          user.fechaVencimientoLicencia = _fechaVencimientoLicenciaController.text;
          user.fechaVencimientoPoliza = _fechaVencimientoPolizaController.text;
          bandera = await userService.updateUser(user, user.id);
          preferences.email = user.correo;
          preferences.numeroPoliza = user.seguro;
          preferences.telefonoPoliza = user.telefonoSeguro;
          preferences.tipoUsuario = user.tipoUsuario;
          preferences.telefonoPoliza = _telefonoSeguroController.text;
          preferences.numeroPoliza = _numeroPolizaSeguroController.text;
        }

        if (bandera) {
          _appState.isInvitado = false;
          success(context, "Perfil Completado", "Su registro ha sido exitoso",
              f: () {
            setState(() {
              isSubmitting = false;
            });
            Navigator.of(context).pushNamedAndRemoveUntil(home, (Route<dynamic> route) => false);
          });
        }
      }
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });
      print('error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context);
    _appState = Provider.of<AppState>(context);
    //emailArg = ModalRoute.of(context).settings.arguments;
    DateTime _dateLicencia;
    DateTime _dateSeguro;
    DateTime _datePagoTendencia;
    DateTime _dateVencimientoVerificacion;

    final logo = Image.asset(
      "assets/images/logo.png",
      height: isAfiliado ? (mq.size.height / 16) : (mq.size.height / 8),
    );

    final placaField = TextFormField(
        textCapitalization: TextCapitalization.characters,
        controller: _placaController,
        keyboardType: TextInputType.text,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            hintText: "Placa",
            labelText: "Placa",
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Ingrese su placa';
          }

          return null;
        },
        onSaved: (String value) {
          _placaController.text = value;
        });

    final licenciaField = TextFormField(
        controller: _licenciaController,
        keyboardType: TextInputType.text,
        enabled: true,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            hintText: "Número",
            labelText: "Número licencia",
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Número es requerido';
          }

          return null;
        },
        onSaved: (String value) {
          _licenciaController.text = value;
        });

    final fechaVencimientolicenciaField = TextFormField(
        controller: _fechaVencimientoLicenciaController,
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            hintText: "Introduce la vigencia de tu licencia",
            labelText: "Fecha vencimiento licencia",
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Ingrese la vigencia de su licencia';
          }
          return null;
        },
        onSaved: (String value) {
          _fechaVencimientoLicenciaController.text = value;
        });

    final fechaVencimientoVerificacionField = TextFormField(
        controller: _vencimientoVerificacioController,
        keyboardType: TextInputType.text,
        enabled: false,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            hintText: "Introduce vencimeinto de verificacion",
            labelText: "Fecha vencimiento verificacion",
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Ingrese la vigencia de su licencia';
          }

          return null;
        },
        onSaved: (String value) {
          _vencimientoVerificacioController.text = value;
        });

    final numeroPolizaSeguroField = TextFormField(
        controller: _numeroPolizaSeguroController,
        keyboardType: TextInputType.datetime,
        enabled: true,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            hintText: "Número",
            labelText: "Número póliza de seguro",
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Número es requerido';
          }

          return null;
        },
        onSaved: (String value) {
          _numeroPolizaSeguroController.text = value;
        });

    final vechaVencimientoPolizaField = TextFormField(
        controller: _fechaVencimientoPolizaController,
        keyboardType: TextInputType.datetime,
        enabled: false,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            hintText: "Ingrese la vigencia de su póliza de seguro",
            labelText: "Fecha vencimiento póliza de seguro",
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Ingrese la vigencia de su póliza de seguro';
          }

          return null;
        },
        onSaved: (String value) {
          _fechaVencimientoPolizaController.text = value;
        });

    final fechaPagoTeneciaField = TextFormField(
        controller: _fechaPagoTenenciaController,
        keyboardType: TextInputType.datetime,
        enabled: false,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            hintText: "Ingrese fecha pago tenencia",
            labelText: "Fecha pago tenencia",
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Ingrese fecha pago tenencia';
          }

          return null;
        },
        onSaved: (String value) {
          _fechaPagoTenenciaController.text = value;
        });

    final telefonoSeguroField = TextFormField(
        controller: _telefonoSeguroController,
        keyboardType: TextInputType.phone,
        enabled: true,
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
<<<<<<< HEAD
            hintText: "Teléfono",
            labelText: "Teléfono para emergencia de tu seguro",
=======
            hintText: "Telefono",
            labelText: "Telefono de emergencia del Seguro",
>>>>>>> 7dee3d03e716c05b002b9499e53e9b612547ae8a
            hintStyle: TextStyle(color: kBaseColor)),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Teléfono es requerido';
          }

          return null;
        },
        onSaved: (String value) {
          _telefonoSeguroController.text = value;
        });

    final calendarLicencia = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('Seleccione la fecha de vencimiento',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
          color: kBaseColor,
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate:
                  _dateLicencia == null ? DateTime.now() : _dateLicencia,
              firstDate: _dateLicencia == null ? DateTime.now() : _dateLicencia,
              lastDate: DateTime(2050),
              cancelText: 'Cancelar',
            ).then((date) {
              setState(() {
                _dateLicencia = date;
                var dateAux = date.toIso8601String().split("T")[0];
                _fechaVencimientoLicenciaController.text = dateAux;
              });
            });
          },
        )
      ],
    );

    final calendarSeguro = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text("Seleccione la fecha de vencimiento",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
          color: kBaseColor,
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate:
                        _dateSeguro == null ? DateTime.now() : _dateSeguro,
                    firstDate:
                        _dateSeguro == null ? DateTime.now() : _dateSeguro,
                    lastDate: DateTime(2050),
                    cancelText: 'Cancelar')
                .then((date) {
              setState(() {
                _dateSeguro = date;
                var dateAux = date.toIso8601String().split("T")[0];
                print(dateAux);
                _fechaVencimientoPolizaController.text = dateAux;
              });
            });
          },
        )
      ],
    );

    final calendarVencimientoVerificacion = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('Seleccione la fecha de vencimiento',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
          color: kBaseColor,
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: _dateVencimientoVerificacion == null
                  ? DateTime.now()
                  : _dateVencimientoVerificacion,
              firstDate: _dateVencimientoVerificacion == null
                  ? DateTime.now()
                  : _dateVencimientoVerificacion,
              lastDate: DateTime(2050),
              cancelText: 'Cancelar',
            ).then((date) {
              setState(() {
                _dateVencimientoVerificacion = date;
                var dateAux = date.toIso8601String().split("T")[0];
                _vencimientoVerificacioController.text = dateAux;
              });
            });
          },
        )
      ],
    );
    final calendarFechaPagoTendencia = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          child: Text('Seleccione la fecha de pago',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white)),
          color: kBaseColor,
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: _datePagoTendencia == null
                  ? DateTime.now()
                  : _datePagoTendencia,
              firstDate: _datePagoTendencia == null
                  ? DateTime.now()
                  : _datePagoTendencia,
              lastDate: DateTime(2050),
              cancelText: 'Cancelar',
            ).then((date) {
              setState(() {
                _datePagoTendencia = date;
                var dateAux = date.toIso8601String().split("T")[0];
                _fechaPagoTenenciaController.text = dateAux;
              });
            });
          },
        )
      ],
    );
    final fields = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          placaField,
          telefonoSeguroField,
          numeroPolizaSeguroField,
          vechaVencimientoPolizaField,
          calendarSeguro,
          licenciaField,
          fechaVencimientolicenciaField,
          calendarLicencia,
          fechaVencimientoVerificacionField,
          calendarVencimientoVerificacion,
          fechaPagoTeneciaField,
          calendarFechaPagoTendencia,
          SizedBox(
            height: 15,
          )
        ],
      ),
    );

    final registerButton = Material(
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
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        registerButton,
        SizedBox(height: 10.0),
      ],
    );

    return WillPopScope(
      onWillPop: () async => false,
        child: Scaffold(
        body: Form(
          key: _formKey,
          child: BlurContainer(
            isLoading: isSubmitting,
            text: "Registrando usuario",
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 36.0),
                child: Container(
                  //height: mq.size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      logo,
                      !isAfiliado
                          ? Text(
                              "Registro de Usuario",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Column(
                              children: [
                                Text(
                                  "Paso 1",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  "Registro de usuario afiliado",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                      fields,
                      bottom,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlert(BuildContext context, String title, String error) {
    var messageError;

    switch (error) {
      case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        messageError =
            'El correo electrónico ya se encuentra vinculado a una cuenta registrada, por favor inicie sesión';
        break;
      default:
        messageError = 'Verifique su correo y contraseña';
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text(title),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text(messageError)]),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('register', (route) => false),
                  child: Text('OK',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: kBaseColor)))
            ],
          );
        });
  }
}
