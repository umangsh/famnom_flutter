import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';

class BrandDetails extends StatelessWidget {
  const BrandDetails({Key? key, required this.brand}) : super(key: key);

  final Brand brand;

  List<Widget> brandItem(String label, String text) {
    return <Widget>[
      Text.rich(
        TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          children: <TextSpan>[
            TextSpan(
              text: text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            )
          ],
        ),
      ),
      const SizedBox(height: 8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (brand.brandName?.isNotEmpty ?? false)
          ...brandItem('Brand Name: ', brand.brandName!),
        if (brand.subBrandName?.isNotEmpty ?? false)
          ...brandItem('Sub Brand Name: ', brand.subBrandName!),
        if (brand.brandOwner?.isNotEmpty ?? false)
          ...brandItem('Brand Owner: ', brand.brandOwner!),
        if (brand.gtinUpc?.isNotEmpty ?? false)
          ...brandItem('GTIN/UPC: ', brand.gtinUpc!),
        if (brand.ingredients?.isNotEmpty ?? false)
          ...brandItem('Ingredients: ', brand.ingredients!),
        if (brand.notASignificantSourceOf?.isNotEmpty ?? false)
          ...brandItem(
            'Not a significant source of: ',
            brand.notASignificantSourceOf!,
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
