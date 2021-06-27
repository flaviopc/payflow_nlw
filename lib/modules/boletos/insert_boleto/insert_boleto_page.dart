import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/boletos/insert_boleto/insert_boleto_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class InsertBoletoPage extends StatefulWidget {
  const InsertBoletoPage({Key? key}) : super(key: key);

  @override
  _InsertBoletoPageState createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final controller = InsertBoletoController();

  final barcodeInputTextController = MaskedTextController(mask: "00000.00000");
  final barcodeInputTextController2 =
      MaskedTextController(mask: "00000.000000");
  final barcodeInputTextController3 =
      MaskedTextController(mask: "00000.000000");
  final barcodeInputTextController4 = MaskedTextController(mask: "0");
  final barcodeInputTextController5 =
      MaskedTextController(mask: "00000000000000");

  var _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _getClipBoardText() async {
    ClipboardData? dados = await Clipboard.getData(Clipboard.kTextPlain);
    return dados?.text;
  }

  void _colarCodigo() async {
    String? dados = await _getClipBoardText();
    if (dados!.isNotEmpty) {
      if (dados.length == 47 || dados.length == 44) {
        controller.codigoBoleto = dados;
        var codigoDividido = controller.divideCodigo();
        controller.getDataVencimento();
        setState(() {
          controller.visivel[0] = true;
          controller.visivel[1] = true;
          controller.visivel[2] = true;
          controller.visivel[3] = true;

          setCodigos(codigoDividido);
        });
      } else {
        msgErroBoleto();
      }
    } else {
      print("Boleto inválido");
    }
  }

  void goToConfirmacao(BuildContext context) {
    if (controller.codigoBoleto.isNotEmpty) {
      Navigator.pushNamed(context, "/confirma_boleto",
          arguments: controller.codigoBoleto);
    } else {
      msgErroBoleto();
    }
  }

  void msgErroBoleto() {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          elevation: 4,
          content: Text("Código do boleto é inválido"),
        ),
      );
  }

  void setCodigos(List<String> codigoDividido) {
    barcodeInputTextController.text = codigoDividido[0];
    barcodeInputTextController2.text = codigoDividido[1];
    barcodeInputTextController3.text = codigoDividido[2];
    barcodeInputTextController4.text = codigoDividido[3];
    barcodeInputTextController5.text = codigoDividido[4];
  }

  void _campo1(String v) {
    if (v.length == 11) {
      controller.visivel[0] = true;
      setState(() {});
      _focusNodes[0].requestFocus();
    }
  }

  void _campo2(String v) {
    if (v.length == 12) {
      controller.visivel[1] = true;
      setState(() {});
      _focusNodes[1].requestFocus();
    }
  }

  void _campo3(String v) {
    if (v.length == 12) {
      controller.visivel[2] = true;
      setState(() {});
      _focusNodes[2].requestFocus();
    }
  }

  void _campo4(String v) {
    if (v.length == 1) {
      controller.visivel[3] = true;
      setState(() {});
      _focusNodes[3].requestFocus();
    }
  }

  void _campo5(String v) {
    if (v.length == 14) {
      controller.codigoBoleto = barcodeInputTextController.text +
          barcodeInputTextController2.text +
          barcodeInputTextController3.text +
          barcodeInputTextController4.text +
          barcodeInputTextController5.text;
      if (controller.formKey.currentState!.validate()) {
        goToConfirmacao(context);
      } else {
        print("erro no form");
      }
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
              GestureDetector(
                onTap: () {
                  _colarCodigo();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.paste,
                        color: AppColors.primary,
                      ),
                      Text(
                        "colar código",
                        style: TextStyles.buttonPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    InputTextWidget(
                      typeNumeric: true,
                      controller: barcodeInputTextController,
                      label: "1ª parte do Código",
                      icon: FontAwesomeIcons.barcode,
                      onChanged: (v) {
                        _campo1(v);
                      },
                      validator: controller.validaCampo1,
                    ),
                    Visibility(
                      visible: controller.visivel[0],
                      child: InputTextWidget(
                        focusNode: _focusNodes[0],
                        typeNumeric: true,
                        controller: barcodeInputTextController2,
                        label: "2ª parte",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo2(v);
                        },
                        validator: controller.validaCampo2e3,
                      ),
                    ),
                    Visibility(
                      visible: controller.visivel[1],
                      child: InputTextWidget(
                        focusNode: _focusNodes[1],
                        typeNumeric: true,
                        controller: barcodeInputTextController3,
                        label: "3ª parte",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo3(v);
                        },
                        validator: controller.validaCampo2e3,
                      ),
                    ),
                    Visibility(
                      visible: controller.visivel[2],
                      child: InputTextWidget(
                        focusNode: _focusNodes[2],
                        typeNumeric: true,
                        controller: barcodeInputTextController4,
                        label: "4ª parte (Dígito Verificador)",
                        icon: FontAwesomeIcons.barcode,
                        onChanged: (v) {
                          _campo4(v);
                        },
                        validator: controller.validaCampo4,
                      ),
                    ),
                    Visibility(
                      visible: controller.visivel[3],
                      child: InputTextWidget(
                        focusNode: _focusNodes[3],
                        typeNumeric: true,
                        controller: barcodeInputTextController5,
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
