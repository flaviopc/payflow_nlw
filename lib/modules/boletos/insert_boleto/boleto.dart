import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:payflow/shared/models/boleto_model.dart';
import 'package:payflow/shared/utils/boleto/boleto_utils.dart';

class Boleto {
  bool eBoletoNormal = true;
  late String _codigoBoleto;
  final formKey = GlobalKey<FormState>();
  BoletoModel model = BoletoModel();
  List<bool> _campoVisivel = [false, false, false, false];
  String maskCodigo = BoletoUtils.FORMATS_BOLETO[0];

  bool isVisivel(int index) => _campoVisivel[index];
  set campoVisivel(int index) => _campoVisivel[index] = true;
  void allCampoVisivel() =>
      _campoVisivel = _campoVisivel.map((e) => e = true).toList();
  String get codigoBoleto => _codigoBoleto;

  set codigoBoleto(String v) {
    _codigoBoleto = v.replaceAll(".", "").replaceAll("-", "");
    escolheMask(codigoBoleto);
    //_campoVisivel =eBoletoNormal ? [false, false, false, false] : [false, false, false];
  }

  List<MaskedTextController> escolheMaskCampos() {
    if (codigoBoleto.length == 47) return BoletoUtils.maskBarcode(0);
    return BoletoUtils.maskBarcode(1);
  }

  void escolheMask(String codigo) {
    if (codigo.startsWith(BoletoUtils.E_CONCESSIONARIA)) {
      eBoletoNormal = false;
      if (codigo.length == 48)
        maskCodigo = BoletoUtils.FORMATS_BOLETO[2];
      else
        maskCodigo = BoletoUtils.FORMATS_BOLETO[3];
    } else {
      eBoletoNormal = true;
      if (codigo.length == 47)
        maskCodigo = BoletoUtils.FORMATS_BOLETO[0];
      else
        maskCodigo = BoletoUtils.FORMATS_BOLETO[1];
    }
  }

  List<String?> validacaoBoleto(String? value) {
    return eBoletoNormal
        ? [
            validaCampo1(value),
            validaCampo2e3(value),
            validaCampo2e3(value),
            validaCampo4(value),
            validaCampo5(value),
          ]
        : List.generate(4, (index) => validaCampo(value));
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
    else if (value.length < 13)
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
        : codigoBoleto.substring(4, 11) + codigoBoleto.substring(12, 16);
    String valor = codigo;
    return NumberFormat(BoletoUtils.FORMAT_VALOR).format(int.parse(valor));
  }

  String getDataVencimento() {
    String codigo = "";
    if (codigoBoleto.length == 47) codigo = divideCodigo()[4];
    if (codigoBoleto.length == 44) codigo = divideCodigo()[1];
    if (codigoBoleto.length == 48) return codigo;

    if (eBoletoNormal) {
      if (codigo.length >= 4) {
        String dias = codigo.substring(0, 4);
        DateTime vencimento = DateUtils.addDaysToDate(
            DateTime.parse(BoletoUtils.DATA_BASE), int.parse(dias));
        return DateFormat(BoletoUtils.FORMAT_DATA).format(vencimento);
      } else {
        return codigo;
      }
    } else {
      return "";
    }
  }

  List<String> divideCodigo() {
    var codigo = List<String>.generate(5, (i) => "");

    if (codigoBoleto.length == 48) {
      codigo[0] = codigoBoleto.substring(0, 12);
      codigo[1] = codigoBoleto.substring(12, 24);
      codigo[2] = codigoBoleto.substring(24, 36);
      codigo[3] = codigoBoleto.substring(36);
    } else if (codigoBoleto.length == 47) {
      codigo[0] = codigoBoleto.substring(0, 10);
      codigo[1] = codigoBoleto.substring(10, 21);
      codigo[2] = codigoBoleto.substring(21, 32);
      codigo[3] = codigoBoleto.substring(32, 33);
      codigo[4] = codigoBoleto.substring(33);
    } else {
      if (eBoletoNormal) {
        codigo[0] = codigoBoleto.substring(0, 4);
        codigo[1] = codigoBoleto.substring(4, 19);
        codigo[2] = codigoBoleto.substring(19, 24);
        codigo[3] = codigoBoleto.substring(24, 30);
        codigo[4] = codigoBoleto.substring(30);
      } else {
        codigo[0] = codigoBoleto.substring(0, 12);
        codigo[1] = codigoBoleto.substring(12, 24);
        codigo[2] = codigoBoleto.substring(24, 36);
        codigo[3] = codigoBoleto.substring(36);
      }
    }
    return codigo;
  }
}
