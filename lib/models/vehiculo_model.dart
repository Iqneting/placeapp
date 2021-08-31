import 'package:meta/meta.dart';
import 'dart:convert';

VehiculoModel vehiculoModelFromJson(String str) => VehiculoModel.fromJson(json.decode(str));

String vehiculoModelToJson(VehiculoModel data) => json.encode(data.toJson());

class VehiculoModel {
    VehiculoModel({
        @required this.correo,
        @required this.fechaPagoTenencia,
        @required this.fechaVencimientoLicencia,
        @required this.fechaVencimientoPoliza,
        @required this.licencia,
        @required this.placa,
        @required this.seguro,
        @required this.telefonoSeguro,
        @required this.vencimientoVerificacio,
    });

    String correo;
    String fechaPagoTenencia;
    String fechaVencimientoLicencia;
    String fechaVencimientoPoliza;
    String licencia;
    String placa;
    String seguro;
    String telefonoSeguro;
    String vencimientoVerificacio;

    factory VehiculoModel.fromJson(Map<String, dynamic> json) => VehiculoModel(
        correo: json["correo"],
        fechaPagoTenencia: json["fechaPagoTenencia"],
        fechaVencimientoLicencia: json["fechaVencimientoLicencia"],
        fechaVencimientoPoliza: json["fechaVencimientoPoliza"],
        licencia: json["licencia"],
        placa: json["placa"],
        seguro: json["seguro"],
        telefonoSeguro: json["telefonoSeguro"],
        vencimientoVerificacio: json["vencimientoVerificacio"],
    );

    Map<String, dynamic> toJson() => {
        "correo": correo,
        "fechaPagoTenencia": fechaPagoTenencia,
        "fechaVencimientoLicencia": fechaVencimientoLicencia,
        "fechaVencimientoPoliza": fechaVencimientoPoliza,
        "licencia": licencia,
        "placa": placa,
        "seguro": seguro,
        "telefonoSeguro": telefonoSeguro,
        "vencimientoVerificacio": vencimientoVerificacio,
    };
}
