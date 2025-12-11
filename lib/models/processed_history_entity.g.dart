// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'processed_history_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProcessedHistoryCollection on Isar {
  IsarCollection<ProcessedHistory> get processedHistorys => this.collection();
}

const ProcessedHistorySchema = CollectionSchema(
  name: r'ProcessedHistory',
  id: -6560316888108291871,
  properties: {
    r'fileHash': PropertySchema(
      id: 0,
      name: r'fileHash',
      type: IsarType.string,
    ),
    r'fileName': PropertySchema(
      id: 1,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'processedAt': PropertySchema(
      id: 2,
      name: r'processedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _processedHistoryEstimateSize,
  serialize: _processedHistorySerialize,
  deserialize: _processedHistoryDeserialize,
  deserializeProp: _processedHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'fileHash': IndexSchema(
      id: -5944002318434853925,
      name: r'fileHash',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'fileHash',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _processedHistoryGetId,
  getLinks: _processedHistoryGetLinks,
  attach: _processedHistoryAttach,
  version: '3.3.0',
);

int _processedHistoryEstimateSize(
  ProcessedHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fileHash.length * 3;
  bytesCount += 3 + object.fileName.length * 3;
  return bytesCount;
}

void _processedHistorySerialize(
  ProcessedHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.fileHash);
  writer.writeString(offsets[1], object.fileName);
  writer.writeDateTime(offsets[2], object.processedAt);
}

ProcessedHistory _processedHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProcessedHistory();
  object.fileHash = reader.readString(offsets[0]);
  object.fileName = reader.readString(offsets[1]);
  object.id = id;
  object.processedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _processedHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _processedHistoryGetId(ProcessedHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _processedHistoryGetLinks(ProcessedHistory object) {
  return [];
}

void _processedHistoryAttach(
  IsarCollection<dynamic> col,
  Id id,
  ProcessedHistory object,
) {
  object.id = id;
}

extension ProcessedHistoryByIndex on IsarCollection<ProcessedHistory> {
  Future<ProcessedHistory?> getByFileHash(String fileHash) {
    return getByIndex(r'fileHash', [fileHash]);
  }

  ProcessedHistory? getByFileHashSync(String fileHash) {
    return getByIndexSync(r'fileHash', [fileHash]);
  }

  Future<bool> deleteByFileHash(String fileHash) {
    return deleteByIndex(r'fileHash', [fileHash]);
  }

  bool deleteByFileHashSync(String fileHash) {
    return deleteByIndexSync(r'fileHash', [fileHash]);
  }

  Future<List<ProcessedHistory?>> getAllByFileHash(
    List<String> fileHashValues,
  ) {
    final values = fileHashValues.map((e) => [e]).toList();
    return getAllByIndex(r'fileHash', values);
  }

  List<ProcessedHistory?> getAllByFileHashSync(List<String> fileHashValues) {
    final values = fileHashValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'fileHash', values);
  }

  Future<int> deleteAllByFileHash(List<String> fileHashValues) {
    final values = fileHashValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'fileHash', values);
  }

  int deleteAllByFileHashSync(List<String> fileHashValues) {
    final values = fileHashValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'fileHash', values);
  }

  Future<Id> putByFileHash(ProcessedHistory object) {
    return putByIndex(r'fileHash', object);
  }

  Id putByFileHashSync(ProcessedHistory object, {bool saveLinks = true}) {
    return putByIndexSync(r'fileHash', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByFileHash(List<ProcessedHistory> objects) {
    return putAllByIndex(r'fileHash', objects);
  }

  List<Id> putAllByFileHashSync(
    List<ProcessedHistory> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'fileHash', objects, saveLinks: saveLinks);
  }
}

extension ProcessedHistoryQueryWhereSort
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QWhere> {
  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProcessedHistoryQueryWhere
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QWhereClause> {
  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterWhereClause>
  fileHashEqualTo(String fileHash) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'fileHash', value: [fileHash]),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterWhereClause>
  fileHashNotEqualTo(String fileHash) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'fileHash',
                lower: [],
                upper: [fileHash],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'fileHash',
                lower: [fileHash],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'fileHash',
                lower: [fileHash],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'fileHash',
                lower: [],
                upper: [fileHash],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ProcessedHistoryQueryFilter
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QFilterCondition> {
  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fileHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fileHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fileHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fileHash',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fileHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fileHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fileHash',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fileHash',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fileHash', value: ''),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fileHash', value: ''),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fileName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fileName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fileName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fileName', value: ''),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fileName', value: ''),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  processedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'processedAt', value: value),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  processedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'processedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  processedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'processedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterFilterCondition>
  processedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'processedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ProcessedHistoryQueryObject
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QFilterCondition> {}

extension ProcessedHistoryQueryLinks
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QFilterCondition> {}

extension ProcessedHistoryQuerySortBy
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QSortBy> {
  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  sortByFileHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileHash', Sort.asc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  sortByFileHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileHash', Sort.desc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  sortByProcessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedAt', Sort.asc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  sortByProcessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedAt', Sort.desc);
    });
  }
}

extension ProcessedHistoryQuerySortThenBy
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QSortThenBy> {
  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  thenByFileHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileHash', Sort.asc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  thenByFileHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileHash', Sort.desc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  thenByProcessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedAt', Sort.asc);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QAfterSortBy>
  thenByProcessedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'processedAt', Sort.desc);
    });
  }
}

extension ProcessedHistoryQueryWhereDistinct
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QDistinct> {
  QueryBuilder<ProcessedHistory, ProcessedHistory, QDistinct>
  distinctByFileHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileHash', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QDistinct>
  distinctByFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProcessedHistory, ProcessedHistory, QDistinct>
  distinctByProcessedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'processedAt');
    });
  }
}

extension ProcessedHistoryQueryProperty
    on QueryBuilder<ProcessedHistory, ProcessedHistory, QQueryProperty> {
  QueryBuilder<ProcessedHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProcessedHistory, String, QQueryOperations> fileHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileHash');
    });
  }

  QueryBuilder<ProcessedHistory, String, QQueryOperations> fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<ProcessedHistory, DateTime, QQueryOperations>
  processedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'processedAt');
    });
  }
}
