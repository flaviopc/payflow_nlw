class BoletoUtils {
  static const FORMAT_BOLETO =
      "00000.00000 00000.000000\n00000.000000 0 00000000000000";
  static const FORMAT_CONCESSIONARIA =
      "00000000000-0 00000000000-0\n00000000000-0 00000000000-0";
  static const DATA_BASE = "1997-10-07";
  static const FORMAT_DATA = "dd/MM/yyyy";
  static const MASK_DATA = "00/00/0000";
  static const FORMAT_VALOR = "########,##";
  static const REGEXP_BARCODE = "[0-9]{44}";
  static const REGEXP_BOLETO = "[0-9]{47}";
  static const REGEXP_CONCESSIONARIA = "[0-9]{48}";
}
