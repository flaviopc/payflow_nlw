import 'package:flutter_test/flutter_test.dart';
import 'package:payflow/modules/boletos/insert_boleto/boleto.dart';

void main() {
  group("Testes para boleto normal 47 dígitos =>", () {
    Boleto boletoNormal = Boleto();
    //boleto normal 47 digitos
    String linhaDigitavel = "00190000090326891900228945194174186510000007973";
    boletoNormal.codigoBoleto = linhaDigitavel;
    test('Verifica se a linha digitavel do boleto é válido', () {
      expect(boletoNormal.codigoBoleto.length, 47);
    });
    test('Deve retornar o valor do boleto', () {
      expect(boletoNormal.getValor(), "79,73");
    });
    test('Deve retornar a data de vencimento do boleto', () {
      expect(boletoNormal.getDataVencimento(), "14/06/2021");
    });
    test('Deve retornar a quantidade de campos do boleto', () {
      expect(boletoNormal.divideCodigo().length, 5);
    });
  });

  group("Testes para boleto normal 44 dígitos =>", () {
    Boleto boletoNormal = Boleto();
    //boleto normal 44
    String codigoBarras = "00191865100000079730000003268919002894519417";
    codigoBarras = "00192861900000072010000003268919002809282017";
    boletoNormal.codigoBoleto = codigoBarras;
    test('Verifica se o código do boleto é válido', () {
      boletoNormal.codigoBoleto = codigoBarras;
      expect(boletoNormal.codigoBoleto.length, 44);
    });

    test('Deve retornar o valor do boleto', () {
      expect(boletoNormal.getValor(), "72,01");
    });
    test('Deve retornar a data de vencimento do boleto', () {
      expect(boletoNormal.getDataVencimento(), "13/05/2021");
    });
    test('Deve retornar a quantidade de campos do boleto', () {
      expect(boletoNormal.divideCodigo().length, 5);
    });
  });
}
