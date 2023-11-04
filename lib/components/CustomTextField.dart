import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextField({required this.controller, this.label = ""});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  void checkValue() {
    int value = int.tryParse(widget.controller.text) ?? 0;

    if (value > 50) {
      Fluttertoast.showToast(
        msg: "Value should not exceed 50",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      widget.controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFocused = true;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Stack(
          children: [
            TextFormField(
              controller: widget.controller,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.number,
              enabled: _isFocused,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "00.00",
                hintStyle: TextStyle(color: Colors.grey.shade800),
              ),
              onEditingComplete: () {
                int value = int.tryParse(widget.controller.text) ?? 0;
                if (value <= 50) {
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                }
                checkValue();
              },
            ),
          ],
        ),
      ),
    );
  }
}
