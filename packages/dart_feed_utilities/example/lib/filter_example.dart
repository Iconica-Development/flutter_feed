import 'dart:io';

import 'package:dart_feed_utilities/filters.dart';

var filterService = FilterService();

void runFilterExample() async {
  filterService.getFiltersWithValues().listen((event) {
    stdout.writeln(
      "Current Values: ${event.where((filter) => filter.value != null).map((e) => "${e.value?.filterId}: ${e.value?.value}").join(", ")}",
    );
    stdout.writeln(event.toQueryParameters());
  });
  await _runFilterExample();
  stdout.writeln("=-=-=-=-=-=-=-=-=-=-=-=-=");
  await _runFilterExample();
}

Future<void> _runFilterExample() async {
  // Retrieve all filters with their values, if any
  var filters = await filterService.getFiltersWithValues().first;

  for (var filterWithValue in filters) {
    var filter = filterWithValue.filterModel;
    var currentValue = filterWithValue.value?.value;

    var displayCurrentValue =
        currentValue == null ? "" : "(${filter.serializeValue(currentValue)})";
    stdout.writeln(
      "Please provide a value for ${filterWithValue.filterModel.name} "
      "$displayCurrentValue",
    );

    bool pickedResponseIsValid = false;
    dynamic parsedResponse;
    do {
      switch (filter) {
        case MinMaxIntFilter filter:
          var rangeText = "";
          if (filter.isRange) {
            rangeText = "lower and upper(comma separated e.g: 1,2) ";
          }
          stdout.writeln(
            "Provide a ${rangeText}value between ${filter.min} and ${filter.max}",
          );
        case DataSourceMultiSelectFilter filter:
          await handleDataSourceFilter(filter, filterService);
        case BooleanSelectFilter _:
          stdout.writeln(
            "Reply with (true, 1, y or yes) or (false, 0, n or no)",
          );
      }

      var pickedResponse = stdin.readLineSync() ?? "";
      parsedResponse = switch (filter) {
        MinMaxIntFilter _ => switch (pickedResponse.split(",")) {
            [String first] => (int.tryParse(first), null),
            [String first, String second] => (
                int.tryParse(first),
                int.tryParse(second)
              ),
            _ => null,
          },
        DataSourceMultiSelectFilter _ => pickedResponse.split(","),
        BooleanSelectFilter _ => switch (pickedResponse.toLowerCase()) {
            "true" || "y" || "yes" || "1" => true,
            "false" || "n" || "no" || "0" => false,
            _ => null,
          },
        _ => pickedResponse,
      };

      // You can validate the value you received with the filter, except for
      // dynamic datasource values, as those are not defined on the filter.
      // For those, simply check with the corresponding datasource
      pickedResponseIsValid = filter.validateValue(
        parsedResponse,
      );

      // An example on how to validate the DataSourceMultiSelectFilter
      if (filter is DataSourceMultiSelectFilter && pickedResponseIsValid) {
        var data = await filterService.getDataForDatasource(filter.dataSource);
        pickedResponseIsValid = filter.validateAnswers(parsedResponse, data);
      }

      if (!pickedResponseIsValid) {
        stdout.writeln("The provided input was not correct");
        continue;
      }
    } while (!pickedResponseIsValid);

    await filterService.setFilterValue(filter, parsedResponse);
  }
}

/// This simply displays all data source filters
Future<void> handleDataSourceFilter(
    DataSourceMultiSelectFilter filter, FilterService service) async {
  var data = await service.getDataForDatasource(filter.dataSource);

  void printData(LinkedFilterDataTreeNode treeNode, [int index = 0]) {
    stdout.write("\t" * index);
    if (index != 0) {
      stdout.write("\\ ");
    }

    stdout.writeln("${treeNode.current.name}(${treeNode.current.key})");
    for (var child in treeNode.children) {
      printData(child, index + 1);
    }
  }

  var selectKeyword = filter.isMultiSelect ? "any" : "one";

  stdout.writeln("Select $selectKeyword of the following options");

  if (filter.isNested) {
    var nestedData = data.getDataAsTree();
    nestedData.forEach(printData);
  } else {
    stdout
        .writeln(data.map((entry) => "${entry.name}(${entry.key})").join(","));
  }
}
