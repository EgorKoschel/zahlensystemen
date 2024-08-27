import 'package:flutter_test/flutter_test.dart';

import 'package:zahlensystemen/zahlensystemen.dart';

void main() {
  test('Zahlensystemen, BinToDezimal ', () {
    expect(Zahlensystemen.binToDezimal('101001001'), 329);
  });

  test('Zahlensystemen, DezimalToBin ', () {
    expect(Zahlensystemen.dezimalToBin(1329), '10100110001');
  });

  test('Zahlensystemen, DezimalToHex ', () {
    expect(Zahlensystemen.dezimalToHex(15869), '3DFD');
  });

  test('Zahlensystemen, HexToDezimal ', () {
    expect(Zahlensystemen.hexToDezimal('13AF1B'), 1290011);
  });

  test('Zahlensystemen, BinToHex ', () {
    expect(Zahlensystemen.binToHex('101001001'), '149');
  });

  test('Zahlensystemen, HexToBin ', () {
    expect(Zahlensystemen.hexToBin('13AF1B'), '100111010111100011011');
  });
}
