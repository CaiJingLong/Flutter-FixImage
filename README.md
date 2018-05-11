# fit_image

A Image Widget that can be used with BoxFit.

## Getting Started

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

For help on editing package code, view the [documentation](https://flutter.io/developing-packages/).

## use

```dart
import fit_image;

import 'package:flutter/widgets.dart';

Widget image = new FixImage(
  child: new Image.asset("img/flutter-mark-square-100.png"), // your Image
  fit: BoxFit.cover, 
);

```

## install

1. Depend on it
Add this to your package's pubspec.yaml file:
    
    
    dependencies:
      cupertino_icons: "^0.1.0"

2. Install it
You can install packages from the command line:

with Flutter:

    $ flutter packages get

Alternatively, your editor might support flutter packages get. Check the docs for your editor to learn more.