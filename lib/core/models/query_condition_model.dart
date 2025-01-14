class QueryCondition {
  final String field;
  final dynamic value;
  QueryOperator operator;

  QueryCondition({
    required this.field,
    required this.value,
    this.operator = QueryOperator.equalTo,
  });
}

enum QueryOperator {
  equalTo,
  lessThan,
  greaterThan,
  lessThanOrEqualTo,
  greaterThanOrEqualTo,
  isNotEqualTo,
  whereIn,
  whereNotIn,
}
