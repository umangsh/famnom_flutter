import 'package:code_scan/code_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/edit/edit.dart';

class EditScanner extends StatefulWidget {
  const EditScanner({Key? key}) : super(key: key);

  @override
  State<EditScanner> createState() => _EditScannerState();
}

class _EditScannerState extends State<EditScanner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CodeScanner(
      onScan: (code, details, controller) {
        if (code != null) {
          BlocProvider.of<EditUserIngredientCubit>(context)
              .scanBarcode(barcode: code);
        }
      },
      onAccessDenied: (error, controller) {
        Navigator.of(context).pop();
        return false;
      },
      formats: const [
        BarcodeFormat.upca,
        BarcodeFormat.upce,
        BarcodeFormat.ean8,
        BarcodeFormat.ean13,
      ],
      once: true,
    );
  }
}
