library fit_image;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

/// use dart:ui.Image display image
///
/// Follow the apache 2.0 agreement
///
/// you can copy and edit my code
///
/// but you need reservation my statement
///
/// create by caijinglong 2018-05-11
class FitImage extends StatelessWidget {
  final BoxFit fit;
  final Image child;

  /// Creates a widget that displays an image.
  ///
  /// The [child]
  ///
  /// must not be null.
  ///
  /// the [fit] is use [BoxFit]
  const FitImage({
    Key key,
    @required this.child,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new _Image(fit, child);
  }
}

class _Image extends StatefulWidget {
  final BoxFit fit;

  final Image image;

  _Image(this.fit, this.image);

  @override
  __ImageState createState() => new __ImageState();
}

class __ImageState extends State<_Image> {
  ui.Image _image;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_image == null) {
      return new CustomPaint();
    }

    return new CustomPaint(
      painter: new _Paint(_image, widget.fit),
      child: new Container(),
    );
  }

  Future init() async {
    Uint8List list;
    // from widget Image
    var provider = widget.image?.image;
    var config = new ImageConfiguration();

    assert(provider != null);

    if (provider is AssetImage) {
      AssetBundleImageKey key = await provider.obtainKey(config);
      final ByteData data = await key.bundle.load(key.name);
      list = data.buffer.asUint8List();
    } else if (provider is ExactAssetImage) {
      AssetBundleImageKey key = await provider.obtainKey(config);
      final ByteData data = await key.bundle.load(key.name);
      list = data.buffer.asUint8List();
    } else if (provider is NetworkImage) {
      NetworkImage key = await provider.obtainKey(config);
      list = await _loadNetImage(key);
    } else if (provider is FileImage) {
      list = await provider.file.readAsBytes();
    } else if (provider is MemoryImage) {
      list = provider.bytes;
    }

    if (list != null) {
      ui.decodeImageFromList(list, (ui.Image img) {
        setState(() {
          if (_image != null) {
            _image?.dispose();
          }
          _image = img;
        });
      });
    } else {
      // todo other image provider should be support
      print("no support image");
    }
  }

  static final HttpClient _httpClient = new HttpClient();
  final Map<String, String> headers = {};

  Future<Uint8List> _loadNetImage(NetworkImage key) async {
    final Uri resolved = Uri.base.resolve(key.url);
    final HttpClientRequest request = await _httpClient.getUrl(resolved);
    headers?.forEach((String name, String value) {
      request.headers.add(name, value);
    });
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.OK) throw new Exception('HTTP request failed, statusCode: ${response?.statusCode}, $resolved');

    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    if (bytes.lengthInBytes == 0) throw new Exception('NetworkImage is an empty file: $resolved');

    return bytes;
  }
}

class _Paint extends CustomPainter {
  final ui.Image image;
  final BoxFit boxFit;

  _Paint(this.image, this.boxFit);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paintImage(image, new Rect.fromLTRB(0.0, 0.0, size.width, size.height), canvas, paint, boxFit);
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      var rect = Offset.zero & size;
      var width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(new Size(width, width), rect);
      return [
        new CustomPainterSemantics(
          rect: rect,
          properties: new SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(_Paint oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(_Paint oldDelegate) => false;
}

/// Draw the canvas from the ui.Image. copy from flutter.io's
void paintImage(ui.Image image, Rect outputRect, Canvas canvas, Paint paint, BoxFit fit) {
  final Size imageSize = new Size(image.width.toDouble(), image.height.toDouble());
  final FittedSizes sizes = applyBoxFit(fit, imageSize, outputRect.size);
  final Rect inputSubrect = Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
  final Rect outputSubrect = Alignment.center.inscribe(sizes.destination, outputRect);
  canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
}
