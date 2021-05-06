import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle googleFont({
  double size = 14,
  Color color = Colors.white,
  FontWeight fw = FontWeight.w700,
}) {
  return GoogleFonts.montserrat(fontSize: size, color: color, fontWeight: fw);
}
