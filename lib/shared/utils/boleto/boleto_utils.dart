import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class BoletoUtils {
  static const FORMAT_BOLETO =
      "00000.00000 00000.000000\n00000.000000 0 00000000000000";
  static const FORMAT_BOLETO_C1 = "00000.00000";
  static const FORMAT_BOLETO_C23 = "00000.000000";
  static const FORMAT_BOLETO_C4 = "0";
  static const FORMAT_BOLETO_C5 = "00000000000000";

  static const FORMAT_CONCESSIONARIA_D =
      "00000000000-0 00000000000-0\n00000000000-0 00000000000-0";
  static const FORMAT_CONCESSIONARIA =
      "00000000000 00000000000\n00000000000 00000000000";
  static const FORMAT_CONCESSIONARIA_C = "00000000000-0";

  static const DATA_BASE = "1997-10-07";
  static const FORMAT_DATA = "dd/MM/yyyy";
  static const MASK_DATA = "00/00/0000";

  static const FORMAT_VALOR = "########,##";

  static const REGEXP_BARCODE = "[0-9]{44}";
  static const REGEXP_BOLETO = "[0-9]{47}";
  static const REGEXP_CONCESSIONARIA = "[0-9]{48}";
  static const E_CONCESSIONARIA = "8";

  static List<MaskedTextController> maskBarcode(int index) {
    return index == 0
        ? [
            MaskedTextController(mask: BoletoUtils.FORMAT_BOLETO_C1),
            MaskedTextController(mask: BoletoUtils.FORMAT_BOLETO_C23),
            MaskedTextController(mask: BoletoUtils.FORMAT_BOLETO_C23),
            MaskedTextController(mask: BoletoUtils.FORMAT_BOLETO_C4),
            MaskedTextController(mask: BoletoUtils.FORMAT_BOLETO_C5)
          ]
        : [
            MaskedTextController(mask: BoletoUtils.FORMAT_CONCESSIONARIA_C),
            MaskedTextController(mask: BoletoUtils.FORMAT_CONCESSIONARIA_C),
            MaskedTextController(mask: BoletoUtils.FORMAT_CONCESSIONARIA_C),
            MaskedTextController(mask: BoletoUtils.FORMAT_CONCESSIONARIA_C),
            MaskedTextController(mask: BoletoUtils.FORMAT_CONCESSIONARIA_C),
          ];
  }
}
