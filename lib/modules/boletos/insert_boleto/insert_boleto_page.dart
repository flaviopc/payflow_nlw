import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/boletos/insert_boleto/boleto.dart';
import 'package:payflow/modules/boletos/insert_boleto/insert_boleto_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/utils/boleto/boleto_utils.dart';
import 'package:payflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class InsertBoletoPage extends StatefulWidget {
  static const String routeName = "/insert_boleto";
  const InsertBoletoPage({Key? key}) : super(key: key);

  @override
  _InsertBoletoPageState createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final controller = InsertBoletoController();
  Boleto boleto = Boleto();
  List<MaskedTextController> barcodeInputTextController =
      BoletoUtils.maskBarcode(0);

  var _focusNodes = List.generate(5, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
    _focusNodes[0].requestFocus();
  }

  Future<String> _getClipBoardText() async {
    ClipboardData? dados = await Clipboard.getData(Clipboard.kTextPlain);
    String texto = dados != null ? dados.text.toString() : "";
    return texto;
  }

  void _colarCodigo() async {
    String dados = await _getClipBoardText();
    if (RegExp(BoletoUtils.REGEXP_BOLETO).hasMatch(dados) ||
        RegExp(BoletoUtils.REGEXP_BARCODE).hasMatch(dados) ||
        RegExp(BoletoUtils.REGEXP_CONCESSIONARIA).hasMatch(dados)) {
      controller.boleto.codigoBoleto = dados;
      barcodeInputTextController = controller.boleto.escolheMaskCampos();
      var codigoDividido = controller.boleto.divideCodigo();
      controller.boleto.allCampoVisivel();
      setCodigos(codigoDividido);
      // goToConfirmacao(context);
    } else {
      controller.msgErroBoleto(context);
    }
    setState(() {});
  }

  void goToConfirmacao(BuildContext context) async {
    if (controller.formKey.currentState!.validate()) {
      Navigator.pushNamed(context, "/confirma_boleto",
          arguments: controller.boleto.codigoBoleto);
    } else {
      controller.msgErroBoleto(context);
    }
  }

  void setCodigos(List<String> codigoDividido) {
    barcodeInputTextController[0].text = codigoDividido[0];
    barcodeInputTextController[1].text = codigoDividido[1];
    barcodeInputTextController[2].text = codigoDividido[2];
    barcodeInputTextController[3].text = codigoDividido[3];
    if (controller.boleto.eBoletoNormal)
      barcodeInputTextController[4].text = codigoDividido[4];
  }

  void _proxCampo(int index) {
    controller.boleto.campoVisivel = index;
    setState(() {});
    _focusNodes[index + 1].requestFocus();
  }

  void _campo1(String v) {
    String txt = "";
    if (v.length == 2) {
      txt = barcodeInputTextController[0].text;
      if (v.startsWith(BoletoUtils.E_CONCESSIONARIA)) {
        barcodeInputTextController = BoletoUtils.maskBarcode(1);
      } else {
        barcodeInputTextController = BoletoUtils.maskBarcode(0);
      }
      setState(() {});
      barcodeInputTextController[0].text = txt;
    }

    if (!v.startsWith(BoletoUtils.E_CONCESSIONARIA)) {
      if (v.length == 11) {
        _proxCampo(0);
      }
    } else {
      if (v.length == 12) {
        _proxCampo(0);
      }
    }
  }

  void _campo2(String v) {
    if (v.length == 12) {
      _proxCampo(1);
    }
  }

  void _campo3(String v) {
    if (v.length == 12) {
      _proxCampo(2);
    }
  }

  void _campo4(String v) {
    if (controller.boleto.eBoletoNormal) {
      if (v.length == 1) {
        _proxCampo(3);
      }
    } else {
      if (v.length == 12) {
        _juntaCodigos();
        //goToConfirmacao(context);
      }
    }
  }

  void _campo5(String v) {
    if (v.length == 14) {
      _juntaCodigos();
      //goToConfirmacao(context);
    }
  }

  void _juntaCodigos() {
    String codigo = barcodeInputTextController[0].text +
        barcodeInputTextController[1].text +
        barcodeInputTextController[2].text +
        barcodeInputTextController[3].text;

    if (codigo.startsWith(BoletoUtils.E_CONCESSIONARIA))
      codigo += barcodeInputTextController[4].text;

    controller.boleto.codigoBoleto = codigo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(
          color: AppColors.input,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  "Informe o c??digo do boleto",
                  style: TextStyles.titleBoldHeading,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextButton.icon(
                    onPressed: _colarCodigo,
                    icon: Icon(
                      Icons.paste,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      "colar c??digo",
                      style: TextStyles.buttonPrimary,
                    )),
              ),
              SizedBox(
                height: 24,
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    InputTextWidget(
                      focusNode: _focusNodes[0],
                      typeNumeric: true,
                      controller: barcodeInputTextController[0],
                      label: "1?? parte do C??digo",
                      icon: FontAwesomeIcons.barcode,
                      onChanged: (v) {
                        _campo1(v);
                      },
                      validator: (v) => controller.boleto.validacaoBoleto(v)[0],
                    ),
                    Visibility(
                      visible: controller.boleto.isVisivel(0),
                      child: InputTextWidget(
                        focusNode: _focusNodes[1],
                        typeNumeric: true,
                        controller: barcodeInputTextController[1],
                        label: "2?? parte",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo2(v);
                        },
                        validator: (v) =>
                            controller.boleto.validacaoBoleto(v)[1],
                      ),
                    ),
                    Visibility(
                      visible: controller.boleto.isVisivel(1),
                      child: InputTextWidget(
                        focusNode: _focusNodes[2],
                        typeNumeric: true,
                        controller: barcodeInputTextController[2],
                        label: "3?? parte",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo3(v);
                        },
                        validator: (v) =>
                            controller.boleto.validacaoBoleto(v)[2],
                      ),
                    ),
                    Visibility(
                      visible: controller.boleto.isVisivel(2),
                      child: InputTextWidget(
                        focusNode: _focusNodes[3],
                        typeNumeric: true,
                        controller: barcodeInputTextController[3],
                        label: "4?? parte",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo4(v);
                        },
                        validator: (v) =>
                            controller.boleto.validacaoBoleto(v)[3],
                      ),
                    ),
                    if (controller.boleto.eBoletoNormal)
                      Visibility(
                        visible: controller.boleto.isVisivel(3),
                        child: InputTextWidget(
                          focusNode: _focusNodes[4],
                          typeNumeric: true,
                          controller: barcodeInputTextController[4],
                          label: "5?? parte",
                          icon: FontAwesomeIcons.barcode,
                          onChanged: (v) {
                            _campo5(v);
                          },
                          validator: (v) =>
                              controller.boleto.validacaoBoleto(v)[4],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SetLabelButtons(
        enableSecondaryColor: true,
        primaryLabel: "Cancelar",
        primaryOnPressed: () {
          Navigator.pop(context);
        },
        secondaryLabel: "Pr??ximo",
        secondaryOnPressed: () {
          if (controller.formKey.currentState!.validate()) {
            goToConfirmacao(context);
          } else {
            print("erro no form");
          }
        },
      ),
    );
  }
}
