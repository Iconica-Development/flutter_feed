import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

enum OverviewLayoutOption {
  list,
  grid;
}

class OverviewLayout extends StatelessWidget {
  const OverviewLayout._({
    required OverviewLayoutOption activeLayout,
    required this.items,
    this.columnCount = 1,
  }) : _activeLayout = activeLayout;

  factory OverviewLayout.list({required List<Widget> children}) =>
      OverviewLayout._(
        activeLayout: OverviewLayoutOption.list,
        items: children,
      );

  factory OverviewLayout.grid({
    required int columnCount,
    required List<Widget> children,
  }) =>
      OverviewLayout._(
        activeLayout: OverviewLayoutOption.grid,
        columnCount: columnCount,
        items: children,
      );

  final List<Widget> items;
  final OverviewLayoutOption _activeLayout;
  final int columnCount;

  @override
  Widget build(BuildContext context) => switch (_activeLayout) {
        OverviewLayoutOption.list => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: items,
              ),
            ),
          ),
        OverviewLayoutOption.grid => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  // We use a manual column + wrap approach rather than a
                  // gridview as this way we can wrap when the screen becomes
                  // too small
                  for (var i = 0; i < items.length; i += columnCount) ...[
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          for (var x = 0; x < columnCount; x++) ...[
                            if (i + x < items.length) ...[
                              items[i + x],
                            ],
                          ],
                        ],
                      ),
                    ),
                    if (i + columnCount < items.length) ...[
                      const SizedBox(height: 8.0),
                    ],
                  ],
                ],
              ),
            ),
          ),
      };
}
