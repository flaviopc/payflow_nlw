import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/boletos/insert_boleto/insert_boleto_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class InsertBoletoPage extends StatefulWidget {
  final String? barcode;
  const InsertBoletoPage({Key? key, this.barcode}) : super(key: key);

  @override
  _InsertBoletoPageState createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  final controller = InsertBoletoController();
  // final moneyInputTextController =
  //     MoneyMaskedTextController(leftSymbol: "R\$", decimalSeparator: ",");
  // final dueDateInputTextController = MaskedTextController(mask: "00/00/0000");
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
    // if (widget.barcode != null) {
    //   barcodeInputTextController.text = widget.barcode!;
    // }

    // barcodeInputTextController.addListener(_campo1);
    // barcodeInputTextController2.addListener(_campo2);
    // barcodeInputTextController3.addListener(_campo3);
    // barcodeInputTextController4.addListener(_campo4);
    // barcodeInputTextController5.addListener(_campo5);

    super.initState();
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        if (v.length == 11) {
                          controller.visivel[0] = true;
                          setState(() {});
                          _focusNodes[0].requestFocus();
                        }
                      }, //(v) => controller.onChange(barcode: v),
                      validator: controller.validateCodigo,
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
                          if (v.length == 12) {
                            controller.visivel[1] = true;
                            setState(() {});
                            _focusNodes[1].requestFocus();
                          }
                        },
                        validator: controller.validateCodigo,
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
                          if (v.length == 12) {
                            controller.visivel[2] = true;
                            setState(() {});
                            _focusNodes[2].requestFocus();
                          }
                        },
                        validator: controller.validateCodigo,
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
                          if (v.length == 1) {
                            controller.visivel[3] = true;
                            setState(() {});
                            _focusNodes[3].requestFocus();
                          }
                        },
                        validator: controller.validateCodigo,
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
                        onChanged: (v) => controller.onChange(barcode: v),
                        validator: controller.validateCodigo,
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
        secondaryLabel: "Cadastrar",
        secondaryOnPressed: () async {
          await controller.cadastrarBoleto();
          Navigator.pop(context);
        },
      ),
    );
  }
}
