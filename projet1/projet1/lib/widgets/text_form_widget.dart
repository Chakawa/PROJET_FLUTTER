import 'package:flutter/material.dart';

class TextFormWidget extends StatefulWidget {
  final TextEditingController controller;
  final String myText;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final bool? enabled;
  final double minWidth;
  const TextFormWidget({super.key, required this.controller,required this.myText,this.onChanged, this.onEditingComplete, this.onSubmitted, this.prefixIcon, this.enabled,required this.minWidth});

  @override
  State<TextFormWidget> createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
          hintText: widget.myText,
          fillColor: Colors.white,
          filled: true,
          enabled:widget.enabled ?? true,
          prefixIcon:widget.prefixIcon,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none
          ),
          constraints:BoxConstraints(
              minHeight: 50,
              maxHeight: 50,
              minWidth: widget.minWidth
          )
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
    );
  }
}
