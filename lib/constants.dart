import 'package:flutter/material.dart';

double mainSquareSize(BuildContext context) =>
    MediaQuery.of(context).size.height / 2;

double topMargin(BuildContext context) =>
    MediaQuery.of(context).size.height > 700 ? 128 : 64;
double dotsTopMargin(BuildContext context) =>
    topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;
double bottom(BuildContext context) =>
    MediaQuery.of(context).size.height - dotsTopMargin(context) - 8;
EdgeInsets mediaPadding(BuildContext context) => MediaQuery.of(context).padding;
double endTop(context) => topMargin(context) + 32 + 16 + 8;
double startTop(context) =>
    topMargin(context) + mainSquareSize(context) + 32 + 16 + 32 + 4;
double oneThird(context) => (startTop(context) - endTop(context)) / 3;
