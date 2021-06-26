import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsertBoletoController {
  final formKey = GlobalKey<FormState>();
  BoletoModel model = BoletoModel();
  //visibilidade dos campos
  var visivel = [false, false, false, false];
  late String codigoBoleto;
  var codigoDividido = List<String>.generate(5, (i) => "");
  final dataBase = "1997-10-07";
  final formatoData = "dd/MM/yyyy";
  final formatoMoeda = "########,##";

  String? validateName(String? value) =>
      value?.isEmpty ?? true ? "O nome não pode ser vazio" : null;
  String? validateVencimento(String? value) =>
      value?.isEmpty ?? true ? "A data de vencimento não pode ser vazia" : null;
  String? validateValor(double? value) =>
      value == 0 ? "Insira um valor maior que R\$ 0,00" : null;

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

  void alteraVisibilidade(int n) {
    visivel[n] = !visivel[n];
  }

  String getDataVencimento() {
    String codigo =
        codigoBoleto.length == 47 ? divideCodigo()[4] : divideCodigo()[1];
    String dias = codigo.substring(0, 4);
    DateTime vencimento =
        DateUtils.addDaysToDate(DateTime.parse(dataBase), int.parse(dias));

    return DateFormat(formatoData).format(vencimento);
  }

  String getValor() {
    String codigo =
        codigoBoleto.length == 47 ? divideCodigo()[4] : divideCodigo()[1];
    String valor = codigo.substring(4);
    return NumberFormat(formatoMoeda).format(int.parse(valor));
  }

  List<String> divideCodigo() {
    var codigo = List<String>.generate(5, (i) => "");

    if (codigoBoleto.length == 47) {
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

  Future<void> cadastrarBoleto() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      return;
      // await saveBoleto();
    }
  }

  Future<void> saveBoleto() async {
    final instance = await SharedPreferences.getInstance();
    final boletos = instance.getStringList("boletos") ?? <String>[];
    boletos.add(model.toJson());
    await instance.setStringList("boletos", boletos);
    return;
  }

  void onChange(
      {String? name, String? dueDate, double? value, String? barcode}) {
    model = model.copyWith(
        name: name, dueDate: dueDate, value: value, barcode: barcode);
  }
}
