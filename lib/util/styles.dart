import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const absoluteBlack = Colors.black;
const absoluteWhite = Colors.white;

final TextStyle heading = GoogleFonts.nunitoSans(
  color: absoluteBlack,
  fontSize: 36,
  fontWeight: FontWeight.bold,
);

final TextStyle hintText = GoogleFonts.nunitoSans(
  color: Colors.black26,
  fontSize: 14,
);

final InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.grey.withOpacity(0.2),
  border: InputBorder.none,
  errorBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  focusedErrorBorder: InputBorder.none,
);

final BoxDecoration cameraPreview = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 12,
      spreadRadius: 2,
      offset: Offset(4, 4),
    ),
  ],
);

final BoxDecoration volumeContainer = BoxDecoration(
  color: Colors.grey.withOpacity(0.2),
  borderRadius: BorderRadius.circular(16),
);
