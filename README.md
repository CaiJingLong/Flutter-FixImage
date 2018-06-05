# fit_image

A Image Widget that can be used with BoxFit.


## screenshot

![https://raw.githubusercontent.com/CaiJingLong/Flutter-FixImage/master/img/1.gif](https://raw.githubusercontent.com/CaiJingLong/Flutter-FixImage/master/img/1.gif)


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
      fit_image: "^0.1.2"

2. Install it
You can install packages from the command line:

with Flutter:

    $ flutter packages get

Alternatively, your editor might support flutter packages get. Check the docs for your editor to learn more.
