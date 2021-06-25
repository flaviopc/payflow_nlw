import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final moneyInputTextController =
      MoneyMaskedTextController(leftSymbol: "R\$", decimalSeparator: ",");
  final dueDateInputTextController = MaskedTextController(mask: "00/00/0000");
  final barcodeInputTextController = TextEditingController();

  @override
  void initState() {
    if (widget.barcode != null) {
      barcodeInputTextController.text = widget.barcode!;
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Text(
                "Informe os dados do boleto",
                style: TextStyles.titleBoldHeading,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            InputTextWidget(
              label: "Descrição do boleto (opcional)",
              icon: Icons.description_outlined,
              onChanged: (v) {},
            ),
            InputTextWidget(
              controller: dueDateInputTextController,
              label: "Vencimento",
              icon: FontAwesomeIcons.timesCircle,
              onChanged: (v) {},
            ),
            InputTextWidget(
              controller: moneyInputTextController,
              label: "Valor",
              icon: FontAwesomeIcons.wallet,
              onChanged: (v) {},
            ),
            InputTextWidget(
              controller: barcodeInputTextController,
              label: "Código",
              icon: FontAwesomeIcons.barcode,
              onChanged: (v) {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: SetLabelButtons(
          enableSecondaryColor: true,
          primaryLabel: "Cancelar",
          primaryOnPressed: () {
            Navigator.pop(context);
          },
          secondaryLabel: "Cadastrar",
          secondaryOnPressed: () {}),
    );
  }
}
