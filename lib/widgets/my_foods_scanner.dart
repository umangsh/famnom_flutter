import 'package:code_scan/code_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/browse/browse.dart';

class MyFoodsScanner extends StatefulWidget {
  const MyFoodsScanner({Key? key}) : super(key: key);

  @override
  State<MyFoodsScanner> createState() => _MyFoodsScannerState();
}

class _MyFoodsScannerState extends State<MyFoodsScanner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CodeScanner(
      onScan: (code, details, controller) {
        BlocProvider.of<BrowseMyFoodsCubit>(context)
            .getResultsWithQuery(code ?? '');
      },
      onAccessDenied: (error, controller) {
        BlocProvider.of<BrowseMyFoodsCubit>(context).clearSearchBar();
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
