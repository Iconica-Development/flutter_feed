import "package:dart_feed_utilities/dart_feed_utilities.dart";
import "package:dart_feed_utilities/src/dart_feed_utilities_base.dart";
import "package:test/expect.dart";
import "package:test/scaffolding.dart";

void main() {
  group(
    "Filter serialization",
    () {
      BaseFilterModel createBaseFilterModel(String key, String type) =>
          BaseFilterModel(
            id: "",
            name: "",
            key: key,
            imageUrl: Uri.base,
            type: type,
            metadata: {},
          );

      test(
        "Should serialize queryStrings properly for all filter types",
        () {
          var filterWithValue = [
            FilterWithValue(
              value: const FilterValue(
                filterId: "",
                value: false,
              ),
              filterModel: BooleanSelectFilter(
                filterModel: createBaseFilterModel(
                  "bool",
                  BooleanSelectFilter.filterType,
                ),
              ),
            ),
            FilterWithValue(
              value: const FilterValue(
                filterId: "",
                value: (1, 2),
              ),
              filterModel: MinMaxIntFilter(
                filterModel: createBaseFilterModel(
                  "range",
                  MinMaxIntFilter.filterType,
                ),
              ),
            ),
            FilterWithValue(
              value: const FilterValue(
                filterId: "",
                value: ["a", "b"],
              ),
              filterModel: DataSourceMultiSelectFilter(
                filterModel: createBaseFilterModel(
                  "multi",
                  BooleanSelectFilter.filterType,
                ),
              ),
            ),
          ];

          var actual = filterWithValue.toQueryParameters();

          expect(actual, equals("bool=false&range=1&range=2&multi=a&multi=b"));
        },
      );
    },
  );
}
