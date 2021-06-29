import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/boletos/insert_boleto/insert_boleto_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/utils/boleto/boleto_utils.dart';
import 'package:payflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class InsertBoletoPage extends StatefulWidget {
  const InsertBoletoPage({Key? key}) : super(key: key);

  @override
  _InsertBoletoPageState createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final controller = InsertBoletoController();

  final List<MaskedTextController> barcodeInputTextController = [
    MaskedTextController(mask: "00000.00000"),
    MaskedTextController(mask: "00000.000000"),
    MaskedTextController(mask: "00000.000000"),
    MaskedTextController(mask: "0"),
    MaskedTextController(mask: "00000000000000")
  ];

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
    if (RegExp(BoletoUtils.REGEXP_BOLETO).hasMatch(dados)) {
      controller.codigoBoleto = dados;
      var codigoDividido = controller.divideCodigo();
      controller.getDataVencimento();
      controller.allCampoVisivel();
      setCodigos(codigoDividido);
      goToConfirmacao(context);
    } else {
      controller.msgErroBoleto(context);
    }
    setState(() {});
  }

  void goToConfirmacao(BuildContext context) {
    if (controller.formKey.currentState!.validate()) {
      Navigator.pushNamed(context, "/confirma_boleto",
          arguments: controller.codigoBoleto);
    } else {
      controller.msgErroBoleto(context);
    }
  }

  void setCodigos(List<String> codigoDividido) {
    barcodeInputTextController[0].text = codigoDividido[0];
    barcodeInputTextController[1].text = codigoDividido[1];
    barcodeInputTextController[2].text = codigoDividido[2];
    barcodeInputTextController[3].text = codigoDividido[3];
    barcodeInputTextController[4].text = codigoDividido[4];
  }

  void _campo1(String v) {
    if (v.length == 11) {
      controller.campoVisivel = 0;
      setState(() {});
      _focusNodes[1].requestFocus();
    }
  }

  void _campo2(String v) {
    if (v.length == 12) {
      controller.campoVisivel = 1;
      setState(() {});
      _focusNodes[2].requestFocus();
    }
  }

  void _campo3(String v) {
    if (v.length == 12) {
      controller.campoVisivel = 2;
      setState(() {});
      _focusNodes[3].requestFocus();
    }
  }

  void _campo4(String v) {
    if (v.length == 1) {
      controller.campoVisivel = 3;
      setState(() {});
      _focusNodes[4].requestFocus();
    }
  }

  void _campo5(String v) {
    if (v.length == 14) {
      controller.codigoBoleto = barcodeInputTextController[0].text +
          barcodeInputTextController[1].text +
          barcodeInputTextController[2].text +
          barcodeInputTextController[3].text +
          barcodeInputTextController[4].text;

      goToConfirmacao(context);
    }
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
                  "Informe o código do boleto",
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
                      "colar código",
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
                      label: "1ª parte do Código",
                      icon: FontAwesomeIcons.barcode,
                      onChanged: (v) {
                        _campo1(v);
                      },
                      validator: controller.validaCampo1,
                    ),
                    Visibility(
                      visible: controller.isVisivel(0),
                      child: InputTextWidget(
                        focusNode: _focusNodes[1],
                        typeNumeric: true,
                        controller: barcodeInputTextController[1],
                        label: "2ª parte",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo2(v);
                        },
                        validator: controller.validaCampo2e3,
                      ),
                    ),
                    Visibility(
                      visible: controller.isVisivel(1),
                      child: InputTextWidget(
                        focusNode: _focusNodes[2],
                        typeNumeric: true,
                        controller: barcodeInputTextController[2],
                        label: "3ª parte",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo3(v);
                        },
                        validator: controller.validaCampo2e3,
                      ),
                    ),
                    Visibility(
                      visible: controller.isVisivel(2),
                      child: InputTextWidget(
                        focusNode: _focusNodes[3],
                        typeNumeric: true,
                        controller: barcodeInputTextController[3],
                        label: "4ª parte (Dígito Verificador)",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo4(v);
                        },
                        validator: controller.validaCampo4,
                      ),
                    ),
                    Visibility(
                      visible: controller.isVisivel(3),
                      child: InputTextWidget(
                        focusNode: _focusNodes[4],
                        typeNumeric: true,
                        controller: barcodeInputTextController[4],
                        label: "5ª e última parte",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo5(v);
                        },
                        validator: controller.validaCampo5,
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
        secondaryLabel: "Próximo",
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
