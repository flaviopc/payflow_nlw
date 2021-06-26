import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/boletos/insert_boleto/insert_boleto_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:payflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class ConfirmacaoBoletoPage extends StatefulWidget {
  final String? barcode;

  const ConfirmacaoBoletoPage({Key? key, this.barcode}) : super(key: key);

  @override
  _ConfirmacaoBoletoPageState createState() => _ConfirmacaoBoletoPageState();
}

class _ConfirmacaoBoletoPageState extends State<ConfirmacaoBoletoPage> {
  final controller = InsertBoletoController();
  final moneyInputTextController = MoneyMaskedTextController(leftSymbol: "R\$");
  final dueDateInputTextController = MaskedTextController(mask: "00/00/0000");
  final barcodeInputTextController = MaskedTextController(
      mask: "00000.00000 00000.000000\n00000.000000 0 00000000000000");

  void setDadosBoleto() {
    String data = controller.getDataVencimento();
    String valor = controller.getValor();
    barcodeInputTextController.text = controller.codigoBoleto;
    moneyInputTextController.text = valor;
    dueDateInputTextController.text = data;
  }

  @override
  void initState() {
    if (widget.barcode != null) {
      controller.codigoBoleto = widget.barcode!;
      setDadosBoleto();
    }

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
                  "Verifique os dados do boleto",
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
                      controller: barcodeInputTextController,
                      label: "Código",
                      icon: FontAwesomeIcons.barcode,
                      onChanged: (v) => controller.onChange(barcode: v),
                      validator: controller.validateCodigo,
                    ),
                    InputTextWidget(
                      controller: dueDateInputTextController,
                      label: "Vencimento",
                      icon: FontAwesomeIcons.calendarCheck,
                      onChanged: (v) => controller.onChange(dueDate: v),
                      validator: controller.validateVencimento,
                    ),
                    InputTextWidget(
                      controller: moneyInputTextController,
                      label: "Valor",
                      icon: FontAwesomeIcons.wallet,
                      onChanged: (v) => controller.onChange(
                          value: moneyInputTextController.numberValue),
                      validator: (_) => controller
                          .validateValor(moneyInputTextController.numberValue),
                    ),
                    InputTextWidget(
                      label: "Descrição do boleto (opcional)",
                      icon: Icons.description_outlined,
                      onChanged: (v) => controller.onChange(name: v),
                      validator: controller.validateName,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SetLabelButtons(
          primaryLabel: "Voltar",
          primaryOnPressed: () {
            Navigator.pop(context);
          },
          secondaryLabel: "Cadastrar",
          secondaryOnPressed: () async {
            await controller.cadastrarBoleto();
            Navigator.pop(context);
          }),
    );
  }
}
