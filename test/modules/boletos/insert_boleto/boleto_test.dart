import 'package:flutter_test/flutter_test.dart';
import 'package:payflow/modules/boletos/insert_boleto/boleto.dart';

void main() {
  group("Testes para boleto normal 47 dígitos =>", () {
    Boleto boletoNormal = Boleto();
    //boleto normal 47 digitos
    String linhaDigitavel = "00190000090326891900228945194174186510000007973";
    boletoNormal.codigoBoleto = linhaDigitavel;
    test('Deve retornar TRUE para boleto normal', () {
      expect(boletoNormal.eBoletoNormal, isTrue);
    });
    test('Deve retornar 47 dígitos', () {
      expect(boletoNormal.codigoBoleto.length, 47);
    });
    test('Deve retornar o valor 79,73', () {
      expect(boletoNormal.getValor(), "79,73");
    });
    test('Deve retornar a data de vencimento do boleto', () {
      expect(boletoNormal.getDataVencimento(), "14/06/2021");
    });
    test('Deve retornar a quantidade de campos 5', () {
      expect(boletoNormal.divideCodigo().length, 5);
    });
  });

  group("Testes para boleto normal 44 dígitos =>", () {
    Boleto boletoNormal = Boleto();
    //boleto normal 44
    String codigoBarras = "00191865100000079730000003268919002894519417";
    codigoBarras = "00192861900000072010000003268919002809282017";
    boletoNormal.codigoBoleto = codigoBarras;
    test('Deve retornar TRUE para boleto normal', () {
      expect(boletoNormal.eBoletoNormal, isTrue);
    });
    test('Deve retornar 44 dígitos', () {
      boletoNormal.codigoBoleto = codigoBarras;
      expect(boletoNormal.codigoBoleto.length, 44);
    });
    test('Deve retornar o valor 72,01', () {
      expect(boletoNormal.getValor(), "72,01");
    });
    test('Deve retornar a data de vencimento do boleto', () {
      expect(boletoNormal.getDataVencimento(), "13/05/2021");
    });
    test('Deve retornar a quantidade de campos 5', () {
      expect(boletoNormal.divideCodigo().length, 5);
    });
  });

  group("Testes para boleto concessionaria 48 dígitos =>", () {
    Boleto boletoConcessionaria = Boleto();
    //boleto normal 44
    String codigoBarras = "826000000008397600418206745959907205211745959919";

    boletoConcessionaria.codigoBoleto = codigoBarras;
    test('Deve retornar FALSE para boleto normal', () {
      expect(boletoConcessionaria.eBoletoNormal, isFalse);
    });
    test('Deve retornar 48 dígitos', () {
      boletoConcessionaria.codigoBoleto = codigoBarras;
      expect(boletoConcessionaria.codigoBoleto.length, 48);
    });
    test('Deve retornar o valor 39,76', () {
      expect(boletoConcessionaria.getValor(), "39,76");
    });
    test('Deve retornar a data de vencimento vazia', () {
      expect(boletoConcessionaria.getDataVencimento(), isEmpty);
    });
    test('Deve retornar a quantidade de campos 4', () {
      expect(boletoConcessionaria.divideCodigo().length, 4);
    });
  });

  group("Testes para boleto concessionaria 44 dígitos =>", () {
    Boleto boletoConcessionaria = Boleto();
    //boleto normal 44
    String codigoBarras = "82600000000397600418207459599072021174595991";

    boletoConcessionaria.codigoBoleto = codigoBarras;
    test('Deve retornar FALSE para boleto normal', () {
      expect(boletoConcessionaria.eBoletoNormal, isFalse);
    });
    test('Deve retornar 44 dígitos', () {
      boletoConcessionaria.codigoBoleto = codigoBarras;
      expect(boletoConcessionaria.codigoBoleto.length, 44);
    });
    test('Deve retornar o valor 39,76', () {
      expect(boletoConcessionaria.getValor(), "39,76");
    });
    test('Deve retornar a data de vencimento vazia', () {
      expect(boletoConcessionaria.getDataVencimento(), isEmpty);
    });
    test('Deve retornar a quantidade de campos 4', () {
      expect(boletoConcessionaria.divideCodigo().length, 4);
    });
  });
}
