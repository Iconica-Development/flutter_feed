/// A class indicating a tree-like data structure for filters
///
/// For example a category with subcategories
class LinkedFilterData {
  /// Create a linked filter data model
  const LinkedFilterData({
    required this.key,
    required this.name,
    this.parent,
  });

  /// The reference to this value
  final String key;

  /// The name that should be displayed
  final String name;

  /// The parent value for
  final String? parent;
}

/// A tree-like representation of filtered data
class LinkedFilterDataTreeNode {
  /// Constructs a tree-like node of linked filter data
  const LinkedFilterDataTreeNode({
    required this.current,
    required this.children,
  });

  /// The current node
  final LinkedFilterData current;

  /// All children of this current node
  final List<LinkedFilterDataTreeNode> children;
}

/// Represents the linked filter data as a tree structure
extension TreeLinkedFilterData on List<LinkedFilterData> {
  /// Retrieves the filter data as a tree
  ///
  /// The currentNode defines the root node, this function will return all data
  /// below the current node
  List<LinkedFilterDataTreeNode> getDataAsTree({
    LinkedFilterData? currentNode,
  }) {
    var dataset = switch (currentNode) {
      LinkedFilterData data => where((entry) => entry.parent == data.key),
      null => where((entry) => entry.parent == null),
    };
    return [
      for (var item in dataset) ...[
        LinkedFilterDataTreeNode(
          current: item,
          children: getDataAsTree(currentNode: item),
        ),
      ],
    ];
  }

  /// Changes the current dataset to an indexed hashmap.
  ///
  /// This assumes that all keys in the dataset are unique.
  Map<String, LinkedFilterData> asKeyedMap() =>
      Map.fromEntries(map((data) => MapEntry(data.key, data)).toList());

  /// Retrieves all parents from this current dataset, in order from closest
  /// to furthest.
  ///
  /// To increase performance, provide a pre-indexed dataset through
  /// [indexedData]
  List<LinkedFilterData> getParents(
    LinkedFilterData data, [
    Map<String, LinkedFilterData>? indexedData,
  ]) {
    var indexed = indexedData ?? asKeyedMap();

    var foundParent = indexed[data.parent];

    if (foundParent == null) {
      return [];
    }

    return [
      foundParent,
      ...getParents(foundParent, indexed),
    ];
  }
}
