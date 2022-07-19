import 'package:flutter/material.dart';

class EmptyResults extends StatelessWidget {
  const EmptyResults({
    Key? key,
    required this.firstLine,
    required this.secondLine,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  final String firstLine;
  final String secondLine;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 225,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstLine,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      secondLine,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        primary: const Color(0xFF007BFF),
                      ),
                      onPressed: onPressed,
                      child: Text(buttonText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
