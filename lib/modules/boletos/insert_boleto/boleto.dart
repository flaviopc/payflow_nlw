import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:payflow/shared/utils/boleto/boleto_utils.dart';

class Boleto {
  bool eBoletoNormal = true;
  late String _codigoBoleto;
  final formKey = GlobalKey<FormState>();
  BoletoModel model = BoletoModel();
  List<bool> _campoVisivel = [false, false, false, false];

  bool isVisivel(int index) => _campoVisivel[index];
  set campoVisivel(int index) => _campoVisivel[index] = true;
  void allCampoVisivel() =>
      _campoVisivel = _campoVisivel.map((e) => e = true).toList();
  String get codigoBoleto => _codigoBoleto;

  set codigoBoleto(String v) {
    _codigoBoleto = v.replaceAll(".", "").replaceAll("-", "");
    eBoletoNormal =
        codigoBoleto.startsWith(BoletoUtils.E_CONCESSIONARIA) ? false : true;
    _campoVisivel =
        eBoletoNormal ? [false, false, false, false] : [false, false, false];
  }

  String? validaCampo1(String? value) {
    if (value!.isEmpty)
      return "O código não pode ser vazio";
    else if (value.length < 11)
      return "O código está incompleto";
    else
      return null;
  }

  String? validaCampo2e3(String? value) {
    if (value!.isEmpty)
      return "O código não pode ser vazio";
    else if (value.length < 12)
      return "O código está incompleto";
    else
      return null;
  }

  String? validaCampo4(String? value) =>
      value!.isEmpty ? "O código não pode ser vazio" : null;

  String? validaCampo5(String? value) {
    if (value!.isEmpty)
      return "O código não pode ser vazio";
    else if (value.length < 14)
      return "O código está incompleto";
    else
      return null;
  }

  String? validaCampo(String? value) {
    if (value!.isEmpty)
      return "O código não pode ser vazio";
    else if (value.length < 12)
      return "O código está incompleto";
    else
      return null;
  }

  String getValor() {
    return eBoletoNormal ? getValorBoleto() : getValorConcessionaria();
  }

  String getValorBoleto() {
    String codigo =
        codigoBoleto.length == 47 ? divideCodigo()[4] : divideCodigo()[1];
    String valor = codigo.substring(4);
    return NumberFormat(BoletoUtils.FORMAT_VALOR).format(int.parse(valor));
  }

  String getValorConcessionaria() {
    String codigo = codigoBoleto.length == 44
        ? codigoBoleto.substring(4, 15)
        : codigoBoleto.substring(0, 11) + codigoBoleto.substring(13, 17);
    String valor = codigo;
    return NumberFormat(BoletoUtils.FORMAT_VALOR).format(int.parse(valor));
  }

  String getDataVencimento() {
    String codigo = "";
    if (codigoBoleto.length < 48 && codigoBoleto.length > 44)
      codigo = divideCodigo()[4];
    else
      codigo = divideCodigo()[1];
    if (codigo.length >= 4) {
      String dias = codigo.substring(0, 4);
      DateTime vencimento = DateUtils.addDaysToDate(
          DateTime.parse(BoletoUtils.DATA_BASE), int.parse(dias));
      return DateFormat(BoletoUtils.FORMAT_DATA).format(vencimento);
    } else {
      return codigo;
    }
  }

  List<String> divideCodigo() {
    var codigo = List<String>.generate(5, (i) => "");

    if (codigoBoleto.length == 48) {
      codigo[0] = codigoBoleto.substring(0, 12);
      codigo[1] = codigoBoleto.substring(12, 24);
      codigo[2] = codigoBoleto.substring(24, 36);
      codigo[3] = codigoBoleto.substring(36, 48);
    } else if (codigoBoleto.length == 47) {
      codigo[0] = codigoBoleto.substring(0, 10);
      codigo[1] = codigoBoleto.substring(10, 21);
      codigo[2] = codigoBoleto.substring(21, 32);
      codigo[3] = codigoBoleto.substring(32, 33);
      codigo[4] = codigoBoleto.substring(33);
    } else {
      codigo[0] = codigoBoleto.substring(0, 5);
      codigo[1] = codigoBoleto.substring(5, 19);
      codigo[2] = codigoBoleto.substring(19, 24);
      codigo[3] = codigoBoleto.substring(24, 30);
      codigo[4] = codigoBoleto.substring(30);
    }
    return codigo;
  }
}
