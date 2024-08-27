import 'package:flutter/services.dart';

abstract class Zahlensystemen {
  static int binToDezimal(String bin) {
    int dezimal = 0;
    int potenz = 0;

    for (int i = bin.length - 1; i >= 0; i--) {
      if (bin[i] == '1') {
        dezimal += 1 << potenz; //equivalent to pow(2, potenz).toInt()
      }
      potenz++;
    }
    return dezimal;
  }

  static String dezimalToBin(int dezimal) {
    String bin = '';
    while (dezimal > 0) {
      bin = (dezimal % 2).toString() + bin;
      dezimal ~/= 2;
    }
    return bin.isEmpty ? '0' : bin;
  }

  static String dezimalToHex(int dezimal) {
    String hex = "";
    String hexDigits = "0123456789ABCDEF";

    while (dezimal > 0) {
      int rest = dezimal % 16;
      hex = hexDigits[rest] + hex;
      dezimal ~/= 16;
    }
    return hex.isEmpty ? "0" : hex;
  }

  static int hexToDezimal(String hex) {
    int dezimal = 0;
    int potenz = 0;
    String hexDigits = "0123456789ABCDEF";

    for (int i = hex.length - 1; i >= 0; i--) {
      int ziffer = hexDigits.indexOf(hex[i]);
      dezimal += ziffer << (potenz * 4); //equivalent to ziffer * pow(16, potenz).toInt()
      potenz++;
    }
    return dezimal;
  }

  static String binToHex(String bin) {
    return dezimalToHex(binToDezimal(bin));
  }

  static String hexToBin(String hex) {
    return dezimalToBin(hexToDezimal(hex));
  }

  static String convert(String input, ConversionType type) {
    if (input.isEmpty) {
      return '';
    }
    switch (type) {
      case ConversionType.binToDezimal:
        return binToDezimal(input).toString();
      case ConversionType.dezimalToBin:
        return dezimalToBin(int.tryParse(input) ?? 0);
      case ConversionType.dezimalToHex:
        return dezimalToHex(int.tryParse(input) ?? 0);
      case ConversionType.hexToDezimal:
        return hexToDezimal(input).toString();
      case ConversionType.binToHex:
        return binToHex(input);
      case ConversionType.hexToBin:
        return hexToBin(input);
    }
  }
}

enum ConversionType {
  binToDezimal,
  dezimalToBin,
  dezimalToHex,
  hexToDezimal,
  binToHex,
  hexToBin,
}

class ConversionInfo {
  final String name;
  final String inputPattern;
  final TextInputFormatter inputFormatter;

  ConversionInfo({
    required this.name,
    required this.inputPattern,
    required this.inputFormatter,
  });

  static final Map<ConversionType, ConversionInfo> conversionDetails = {
    ConversionType.binToDezimal: ConversionInfo(
      name: 'Binär zu Dezimal',
      inputPattern: '[0-1]',
      inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'[0-1]')),
    ),
    ConversionType.dezimalToBin: ConversionInfo(
      name: 'Dezimal zu Binär',
      inputPattern: '[0-9]',
      inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ),
    ConversionType.dezimalToHex: ConversionInfo(
      name: 'Dezimal zu Hexadezimal',
      inputPattern: '[0-9]',
      inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ),
    ConversionType.hexToDezimal: ConversionInfo(
      name: 'Hexadezimal zu Dezimal',
      inputPattern: '[0-9, A-F]',
      inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
    ),
    ConversionType.binToHex: ConversionInfo(
      name: 'Binär zu Hexadezimal',
      inputPattern: '[0-1]',
      inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'[0-1]')),
    ),
    ConversionType.hexToBin: ConversionInfo(
      name: 'Hexadezimal zu Binär',
      inputPattern: '[0-9, A-F]',
      inputFormatter: FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
    ),
  };

  static ConversionInfo getInfo(ConversionType type) {
    return conversionDetails[type]!;
  }
}
