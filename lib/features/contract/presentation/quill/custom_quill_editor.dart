import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
// ignore: implementation_imports
import 'package:flutter_quill_to_pdf/src/constants.dart';
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';

class CustomQuillEditor extends StatefulWidget {
  final void Function(Document document) onChange;
  final QuillController controller;
  final FocusNode node;
  final ScrollController scrollController;
  final String? defaultFontFamily;
  const CustomQuillEditor({
    super.key,
    required this.onChange,
    required this.controller,
    required this.node,
    required this.scrollController,
    this.defaultFontFamily = Constant.DEFAULT_FONT_FAMILY,
  });

  @override
  State<CustomQuillEditor> createState() => _CustomQuillEditorState();
}

class _CustomQuillEditorState extends State<CustomQuillEditor> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onChange);
    super.dispose();
  }

  void onChange() {
    widget.onChange(widget.controller.document);
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      focusNode: widget.node,
      scrollController: widget.scrollController,
      controller: widget.controller,
      config: QuillEditorConfig(
        textCapitalization: TextCapitalization.sentences,
        detectWordBoundary: true,
        placeholder: 'Ndao e-contrat',
        padding: const EdgeInsets.only(bottom: 20),
        autoFocus: false,
        enableSelectionToolbar: true,
        enableInteractiveSelection: true,
        textSelectionControls: Platform.isAndroid
            ? MaterialTextSelectionControls()
            : DesktopTextSelectionControls(),
        embedBuilders: FlutterQuillEmbeds.editorBuilders(),
        customStyles: DefaultStyles(
          indent: DefaultTextBlockStyle(
            TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: widget.defaultFontFamily,
              height: 1.15,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(0, 1),
            const VerticalSpacing(0, 0),
            const BoxDecoration(),
          ),
          lists: DefaultListBlockStyle(
            TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: widget.defaultFontFamily,
              height: 1.15,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(5, 0),
            const VerticalSpacing(0, 0),
            null,
            null,
          ),
          leading: DefaultTextBlockStyle(
            TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: widget.defaultFontFamily,
              height: 1.15,
              decoration: TextDecoration.none,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            null,
          ),
          code: DefaultTextBlockStyle(
              TextStyle(
                fontFamily: 'monospace',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const HorizontalSpacing(0, 0),
              const VerticalSpacing(5, 5),
              const VerticalSpacing(5, 5),
              BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Theme.of(context).colorScheme.surfaceContainer)),
          quote: DefaultTextBlockStyle(
            TextStyle(
              height: 1.15,
              fontFamily: widget.defaultFontFamily,
              color: Theme.of(context).colorScheme.outline,
            ),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(0, 1),
            const VerticalSpacing(0, 0),
            BoxDecoration(
              border: BorderDirectional(
                  start: BorderSide(
                      width: 5, color: Theme.of(context).colorScheme.tertiary)),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.1),
            ),
          ),
          align: DefaultTextBlockStyle(
            TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.15,
                fontFamily: widget.defaultFontFamily),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(0, 1),
            const VerticalSpacing(0, 0),
            const BoxDecoration(),
          ),
          paragraph: DefaultTextBlockStyle(
            TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.15,
                fontFamily: widget.defaultFontFamily),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(0, 1),
            const VerticalSpacing(0, 0),
            const BoxDecoration(),
          ),
          link: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        searchConfig: QuillSearchConfig(),
      ),
    );
  }

  double? resolveSize(String size) {
    return size.equals('small')
        ? 12
        : size.equals('large')
            ? 19.5
            : size.equals('huge')
                ? 22.5
                : double.tryParse(size);
  }
}
