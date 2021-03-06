import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

Future<T?> showPopup<T>({
  required BuildContext context,
  required Widget popup,
  Anchor anchor = const Anchor(
    source: Alignment.topLeft,
    target: Alignment.bottomLeft,
    offset: Offset.zero,
  ),
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color color = Colors.transparent,
  bool useRootNavigator = false,
}) {
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final targetBox = context.findRenderObject() as RenderBox;

  final overlayBox =
      Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

  final targetRect = _rectRelativeToParent(
    parent: overlayBox,
    child: targetBox,
  );

  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_PopupMenuRoute<T>(
    popup: DimensionAwarePopup(child: popup),
    targetRect: targetRect,
    anchor: anchor,
    elevation: elevation,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    shape: shape,
    color: color,
    capturedThemes:
        InheritedTheme.capture(from: context, to: navigator.context),
  ));
}

Rect _rectRelativeToParent({
  required RenderBox child,
  required RenderBox parent,
}) {
  final parentRect = Offset.zero & parent.size;

  final childGlobalRect = Rect.fromPoints(
    child.localToGlobal(Offset.zero, ancestor: parent),
    child.localToGlobal(
      child.size.bottomRight(Offset.zero),
      ancestor: parent,
    ),
  );

  return Rect.fromLTRB(
    childGlobalRect.left - parentRect.left,
    childGlobalRect.top - parentRect.top,
    childGlobalRect.left - parentRect.left + childGlobalRect.size.width,
    childGlobalRect.top - parentRect.top + childGlobalRect.size.height,
  );
}

class Anchor {
  const Anchor({
    required this.source,
    required this.target,
    this.offset = Offset.zero,
    this.matchWidth = false,
    this.backup,
  });

  final Alignment source;
  final Alignment target;
  final Offset offset;
  final bool matchWidth;

  final Anchor? backup;

  BoxConstraints getSourceConstraints(
    BoxConstraints constraints,
    Rect targetRect,
  ) {
    constraints = constraints.loosen();
    if (matchWidth) constraints = constraints.tighten(width: targetRect.width);
    return constraints;
  }

  Offset getSourceOffset({
    required Size sourceSize,
    required Rect targetRect,
    required Rect overlayRect,
  }) {
    final alignmentOffset =
        target.alongSize(targetRect.size) - source.alongSize(sourceSize);

    final sourceOffset =
        Offset(targetRect.left, targetRect.top) + alignmentOffset + offset;
    final sourceRect = sourceOffset & sourceSize;

    final backup = this.backup;

    if (!_fullyContains(overlayRect, sourceRect) && backup != null) {
      return backup.getSourceOffset(
          sourceSize: sourceSize,
          targetRect: targetRect,
          overlayRect: overlayRect);
    }

    return sourceOffset;
  }

  bool _fullyContains(Rect container, Rect child) {
    return container.contains(child.topLeft) &&
        container.contains(child.bottomRight);
  }

  @override
  bool operator ==(o) {
    if (identical(this, o)) return true;
    if (!(o is Anchor)) return false;
    return source == o.source &&
        target == o.target &&
        offset == o.offset &&
        backup == o.backup;
  }

  @override
  int get hashCode => source.hashCode ^ target.hashCode ^ offset.hashCode;
}

class _PopupMenuRoute<T> extends RawDialogRoute<T> {
  _PopupMenuRoute({
    required this.popup,
    required this.targetRect,
    required this.anchor,
    this.elevation,
    required this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.color,
    required this.capturedThemes,
  }) : super(pageBuilder: (context, _, __) {
          return popup;
        });

  final Widget popup;
  final Rect targetRect;
  final Anchor anchor;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final CapturedThemes capturedThemes;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 80);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final menu = _PopupMenu<T>(
      route: this,
      semanticLabel: semanticLabel,
    );

    return SafeArea(
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              targetRect: targetRect,
              anchor: anchor,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    Key? key,
    required this.route,
    required this.semanticLabel,
  }) : super(key: key);

  final _PopupMenuRoute<T> route;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);

    return Material(
      shape: route.shape ?? popupMenuTheme.shape,
      color: route.color ?? popupMenuTheme.color,
      type: MaterialType.card,
      elevation: route.elevation ?? popupMenuTheme.elevation ?? 8.0,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: semanticLabel,
        child: route.popup,
      ),
    );
  }
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout({required this.targetRect, required this.anchor});

  final Rect targetRect;
  final Anchor anchor;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return anchor.getSourceConstraints(constraints, targetRect);
  }

  @override
  Offset getPositionForChild(Size overlaySize, Size popupSize) {
    return anchor.getSourceOffset(
      sourceSize: popupSize,
      targetRect: targetRect,
      overlayRect: Offset.zero & overlaySize,
    );
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return targetRect != oldDelegate.targetRect || anchor != oldDelegate.anchor;
  }
}

class DimensionAwarePopup extends StatefulWidget {
  const DimensionAwarePopup({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  _DimensionAwarePopupState createState() => _DimensionAwarePopupState();
}

class _DimensionAwarePopupState extends State<DimensionAwarePopup>
    with WidgetsBindingObserver {
  bool hasPopped = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    if (!hasPopped) {
      Navigator.of(context).pop();
    }
    hasPopped = true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
