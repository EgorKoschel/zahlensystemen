import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zahlensystemen/zahlensystemen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zahlensystemen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Zahlensystemen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  late ConversionType conversionType = ConversionType.binToDezimal;
  late ConversionInfo conversionInfo;
  String result = '';

  @override
  Widget build(BuildContext context) {
    conversionInfo = ConversionInfo.getInfo(conversionType);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(conversionInfo.name, style: Theme.of(context).textTheme.headlineSmall),
                PopupMenuButton(
                    itemBuilder: (context) {
                      return ConversionType.values.map((type) {
                        return PopupMenuItem(
                          value: type,
                          child: Text(ConversionInfo.getInfo(type).name),
                        );
                      }).toList();
                    },
                    onSelected: (ConversionType value) {
                      setState(() {
                        conversionType = value;
                        controller.clear();
                        result = '';
                      });
                    },
                    icon: const Icon(Icons.arrow_drop_down)),
              ],
            ),
            SizedBox(
              width: 400,
              child: TextFormField(
                maxLength: conversionType == ConversionType.binToDezimal || conversionType == ConversionType.binToHex
                    ? 32
                    : 12,
                controller: controller,
                inputFormatters: [
                  conversionInfo.inputFormatter,
                  UpperCaseTextFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: 'Eingabe ${conversionInfo.inputPattern}',
                ),
                onChanged: (value) {
                  setState(() {
                    result = Zahlensystemen.convert(value, conversionType);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text('Ergebnis: ${result.isEmpty ? 'Keine' : result}', style: Theme.of(context).textTheme.labelLarge),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            conversionType = _switchConversion(conversionType);
            if (result.length > 32 &&
                (conversionType == ConversionType.binToDezimal || conversionType == ConversionType.binToHex)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Eingabe zu lang. Wurde auf 32 Zeichen gekürzt.')),
              );
            } else if (result.length > 12 &&
                !(conversionType == ConversionType.binToDezimal || conversionType == ConversionType.binToHex)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Eingabe zu lang. Wurde auf 12 Zeichen gekürzt.')),
              );
            }
            controller.text = conversionType == ConversionType.binToDezimal || conversionType == ConversionType.binToHex
                ? result.substring(0, result.length > 32 ? 32 : result.length)
                : result.substring(0, result.length > 12 ? 12 : result.length);
            result = Zahlensystemen.convert(controller.text, conversionType);
          });
        },
        tooltip: 'Wechseln',
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}

ConversionType _switchConversion(ConversionType type) {
  switch (type) {
    case ConversionType.binToDezimal:
      return ConversionType.dezimalToBin;
    case ConversionType.dezimalToBin:
      return ConversionType.binToDezimal;
    case ConversionType.dezimalToHex:
      return ConversionType.hexToDezimal;
    case ConversionType.hexToDezimal:
      return ConversionType.dezimalToHex;
    case ConversionType.binToHex:
      return ConversionType.hexToBin;
    case ConversionType.hexToBin:
      return ConversionType.binToHex;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
