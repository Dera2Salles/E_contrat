// ignore_for_file: public_member_api_docs, sort_constructors_first, implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_quill_to_pdf/src/extensions/string_extension.dart';

//create just an instance and void duplicate instance
final FontsLoader _instance = FontsLoader._();

///A simple class that charge all fonts available in this example
class FontsLoader {
  late final List<pw.Font> _pdffonts; // save valid pdf type fonts
  late final EmojisFonts emojiFont;
  late final SpecialUnicodeFonts unicodeFont;

  bool _configured = false;

  FontsLoader._() {
    unicodeFont = SpecialUnicodeFonts();
    emojiFont = EmojisFonts();
    _pdffonts = <pw.Font>[];
  }

  factory FontsLoader() {
    return _instance;
  }

  List<pw.Font> allFonts() {
    if (_configured) {
      return _pdffonts;
    }
    throw notConfiguredFonts();
  }

  pw.Font loraFont() {
    if (_configured && _pdffonts.isNotEmpty) {
      return _pdffonts[0];
    }
    return pw.Font.helvetica();
  }

  pw.Font loraBoldFont() {
    if (_configured && _pdffonts.length > 1) return _pdffonts[1];
    return pw.Font.helveticaBold();
  }

  pw.Font loraItalicFont() {
    if (_configured && _pdffonts.length > 2) {
      return _pdffonts[2];
    }
    return pw.Font.helveticaOblique();
  }

  pw.Font loraBoldItalicFont() {
    if (_configured && _pdffonts.length > 3) {
      return _pdffonts[3];
    }
    return pw.Font.helveticaBoldOblique();
  }

  pw.Font courierFont() {
    return pw.Font.courier();
  }

  pw.Font courierBoldFont() {
    return pw.Font.courierBold();
  }

  pw.Font courierItalicFont() {
    return pw.Font.courierOblique();
  }

  pw.Font courierBoldItalicFont() {
    return pw.Font.courierBoldOblique();
  }

  pw.Font arialFont() {
    if (_configured && _pdffonts.length > 36) {
      return _pdffonts[36];
    }
    return pw.Font.helvetica();
  }

  pw.Font arialBoldFont() {
    if (_configured && _pdffonts.length > 37) {
      return _pdffonts[37];
    }
    return pw.Font.helveticaBold();
  }

  pw.Font arialItalicFont() {
    if (_configured && _pdffonts.length > 38) {
      return _pdffonts[38];
    }
    return pw.Font.helveticaOblique();
  }

  pw.Font arialBoldItalicFont() {
    if (_configured && _pdffonts.length > 39) {
      return _pdffonts[39];
    }
    return pw.Font.helveticaBoldOblique();
  }

  Exception notConfiguredFonts() {
    return Exception('The fonts must be initalized before of take it');
  }

  pw.Font getFontByName(
      {String? fontFamily, bool bold = false, bool italic = false}) {
    if (!_configured) return pw.Font.helvetica();
    
    if (fontFamily == null) {
      if (bold && italic) {
        return pw.Font.helveticaBoldOblique();
      }
      if (bold) {
        return pw.Font.helveticaBold();
      }
      if (italic) {
        return pw.Font.helveticaOblique();
      }
      return pw.Font.helvetica();
    }
    
    if (fontFamily.toLowerCase().contains('lora')) {
      if (bold && italic) return loraBoldItalicFont();
      if (bold) return loraBoldFont();
      if (italic) return loraItalicFont();
      return loraFont();
    }
    
    if (fontFamily.toLowerCase().contains('arial')) {
      if (bold && italic) return arialBoldItalicFont();
      if (bold) return arialBoldFont();
      if (italic) return arialItalicFont();
      return arialFont();
    }

    if (fontFamily.equals('monospace')) {
      return pw.Font.courier();
    }
    
    return pw.Font.helvetica();
  }

  Future<void> loadFonts() async {
    if (_configured) return;
    try {
      // LORA
      _pdffonts.add(pw.Font.ttf(
          await rootBundle.load("assets/fonts/Lora/static/Lora-Regular.ttf")));
      _pdffonts.add(
          pw.Font.ttf(await rootBundle.load("assets/fonts/Lora/static/Lora-Bold.ttf")));
      _pdffonts.add(pw.Font.ttf(
          await rootBundle.load("assets/fonts/Lora/static/Lora-Italic.ttf")));
      _pdffonts.add(pw.Font.ttf(
          await rootBundle.load("assets/fonts/Lora/static/Lora-BoldItalic.ttf")));
      
      // NOTO SANS
      _pdffonts.addAll([
        pw.Font.ttf(await rootBundle.load("assets/fonts/Noto_Sans/static/NotoSans-Regular.ttf")),
        pw.Font.ttf(await rootBundle.load("assets/fonts/Noto_Sans/static/NotoSans-Bold.ttf")),
        pw.Font.ttf(await rootBundle.load("assets/fonts/Noto_Sans/static/NotoSans-Italic.ttf")),
        pw.Font.ttf(await rootBundle.load("assets/fonts/Noto_Sans/static/NotoSans-BoldItalic.ttf")),
      ]);
      
    } catch (e) {
      debugPrint("Erreur lors du chargement des polices: $e");
    } finally {
      _configured = true;
    }
  }
}

class EmojisFonts {
  late final pw.Font emojisFonts;
  late final String keyFont;
  EmojisFonts() {
    init();
  }
  void init() async {
    keyFont = "NotoEmojis";
    emojisFonts = pw.Font.ttf(await rootBundle.load("assets/fonts/unicodes/Noto_Emoji/NotoEmoji-VariableFont_wght.ttf"));
  }
}

class SpecialUnicodeFonts {
  late final pw.Font unicode;
  SpecialUnicodeFonts() {
    init();
  }
  void init() async {
    unicode = pw.Font.symbol();
  }
}
