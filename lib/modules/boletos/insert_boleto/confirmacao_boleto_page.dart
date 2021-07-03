import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payflow/modules/boletos/insert_boleto/insert_boleto_controller.dart';
import 'package:payflow/shared/auth/auth_controller.dart';
import 'package:payflow/shared/themes/app_colors.dart';
import 'package:payflow/shared/themes/app_text_styles.dart';
import 'package:payflow/shared/utils/boleto/boleto_utils.dart';
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
  final dueDateInputTextController =
      MaskedTextController(mask: BoletoUtils.MASK_DATA);
  final barcodeInputTextController =
      MaskedTextController(mask: BoletoUtils.FORMAT_BOLETO);

  void setDadosBoleto() {
    String data = controller.boleto.getDataVencimento();
    String valor = controller.boleto.getValor();
    barcodeInputTextController.text = controller.boleto.codigoBoleto;
    moneyInputTextController.text = valor;
    dueDateInputTextController.text = data;
  }

  @override
  void initState() {
    if (widget.barcode != null &&
        (widget.barcode!.length == 44 ||
            widget.barcode!.length == 47 ||
            widget.barcode!.length == 48)) {
      controller.boleto.codigoBoleto = widget.barcode!;

      setState(() {
        setDadosBoleto();
      });

      controller.onChange(
        barcode: barcodeInputTextController.text,
        value: moneyInputTextController.numberValue,
        dueDate: dueDateInputTextController.text,
      );
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      habilitado: false,
                      controller: barcodeInputTextController,
                      label: "Código",
                      icon: FontAwesomeIcons.barcode,
                      onChanged: (v) => controller.onChange(barcode: v),
                      validator: controller.boleto.validaCampo1,
                    ),
                    InputTextWidget(
                      habilitado: controller.boleto.getDataVencimento().isEmpty
                          ? true
                          : false,
                      controller: dueDateInputTextController,
                      label: "Vencimento",
                      icon: FontAwesomeIcons.calendarCheck,
                      onChanged: (v) => controller.onChange(dueDate: v),
                      validator: controller.validateVencimento,
                    ),
                    InputTextWidget(
                      habilitado: false,
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
            if (controller.formKey.currentState!.validate()) {
              await controller.cadastrarBoleto();
              //Não encontrei uma forma de atualizar a home a não ser enviar o
              //o usuario novamente e recarregar
              //Navigator.popUntil(context, ModalRoute.withName("/home"));
              var auth = AuthController();
              await auth.currentUser(context);

              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", ModalRoute.withName("/home"),
                  arguments: auth.user);
            }
          }),
    );
  }
}
