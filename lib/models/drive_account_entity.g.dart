// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_account_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDriveAccountCollection on Isar {
  IsarCollection<DriveAccount> get driveAccounts => this.collection();
}

const DriveAccountSchema = CollectionSchema(
  name: r'DriveAccount',
  id: 3682974859911872772,
  properties: {
    r'credentialsJson': PropertySchema(
      id: 0,
      name: r'credentialsJson',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 1,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'email': PropertySchema(id: 2, name: r'email', type: IsarType.string),
    r'isActive': PropertySchema(id: 3, name: r'isActive', type: IsarType.bool),
    r'lastUploadDate': PropertySchema(
      id: 4,
      name: r'lastUploadDate',
      type: IsarType.dateTime,
    ),
    r'photoUrl': PropertySchema(
      id: 5,
      name: r'photoUrl',
      type: IsarType.string,
    ),
    r'rootFolderId': PropertySchema(
      id: 6,
      name: r'rootFolderId',
      type: IsarType.string,
    ),
    r'uploadedBytesToday': PropertySchema(
      id: 7,
      name: r'uploadedBytesToday',
      type: IsarType.double,
    ),
  },

  estimateSize: _driveAccountEstimateSize,
  serialize: _driveAccountSerialize,
  deserialize: _driveAccountDeserialize,
  deserializeProp: _driveAccountDeserializeProp,
  idName: r'id',
  indexes: {
    r'email': IndexSchema(
      id: -26095440403582047,
      name: r'email',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'email',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _driveAccountGetId,
  getLinks: _driveAccountGetLinks,
  attach: _driveAccountAttach,
  version: '3.3.0',
);

int _driveAccountEstimateSize(
  DriveAccount object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.credentialsJson.length * 3;
  {
    final value = object.displayName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.email.length * 3;
  {
    final value = object.photoUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rootFolderId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _driveAccountSerialize(
  DriveAccount object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.credentialsJson);
  writer.writeString(offsets[1], object.displayName);
  writer.writeString(offsets[2], object.email);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeDateTime(offsets[4], object.lastUploadDate);
  writer.writeString(offsets[5], object.photoUrl);
  writer.writeString(offsets[6], object.rootFolderId);
  writer.writeDouble(offsets[7], object.uploadedBytesToday);
}

DriveAccount _driveAccountDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DriveAccount();
  object.credentialsJson = reader.readString(offsets[0]);
  object.displayName = reader.readStringOrNull(offsets[1]);
  object.email = reader.readString(offsets[2]);
  object.id = id;
  object.isActive = reader.readBool(offsets[3]);
  object.lastUploadDate = reader.readDateTime(offsets[4]);
  object.photoUrl = reader.readStringOrNull(offsets[5]);
  object.rootFolderId = reader.readStringOrNull(offsets[6]);
  object.uploadedBytesToday = reader.readDouble(offsets[7]);
  return object;
}

P _driveAccountDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _driveAccountGetId(DriveAccount object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _driveAccountGetLinks(DriveAccount object) {
  return [];
}

void _driveAccountAttach(
  IsarCollection<dynamic> col,
  Id id,
  DriveAccount object,
) {
  object.id = id;
}

extension DriveAccountByIndex on IsarCollection<DriveAccount> {
  Future<DriveAccount?> getByEmail(String email) {
    return getByIndex(r'email', [email]);
  }

  DriveAccount? getByEmailSync(String email) {
    return getByIndexSync(r'email', [email]);
  }

  Future<bool> deleteByEmail(String email) {
    return deleteByIndex(r'email', [email]);
  }

  bool deleteByEmailSync(String email) {
    return deleteByIndexSync(r'email', [email]);
  }

  Future<List<DriveAccount?>> getAllByEmail(List<String> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return getAllByIndex(r'email', values);
  }

  List<DriveAccount?> getAllByEmailSync(List<String> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'email', values);
  }

  Future<int> deleteAllByEmail(List<String> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'email', values);
  }

  int deleteAllByEmailSync(List<String> emailValues) {
    final values = emailValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'email', values);
  }

  Future<Id> putByEmail(DriveAccount object) {
    return putByIndex(r'email', object);
  }

  Id putByEmailSync(DriveAccount object, {bool saveLinks = true}) {
    return putByIndexSync(r'email', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByEmail(List<DriveAccount> objects) {
    return putAllByIndex(r'email', objects);
  }

  List<Id> putAllByEmailSync(
    List<DriveAccount> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'email', objects, saveLinks: saveLinks);
  }
}

extension DriveAccountQueryWhereSort
    on QueryBuilder<DriveAccount, DriveAccount, QWhere> {
  QueryBuilder<DriveAccount, DriveAccount, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DriveAccountQueryWhere
    on QueryBuilder<DriveAccount, DriveAccount, QWhereClause> {
  QueryBuilder<DriveAccount, DriveAccount, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<DriveAccount, DriveAccount, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterWhereClause> idBetween(
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

  QueryBuilder<DriveAccount, DriveAccount, QAfterWhereClause> emailEqualTo(
    String email,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'email', value: [email]),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterWhereClause> emailNotEqualTo(
    String email,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'email',
                lower: [],
                upper: [email],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'email',
                lower: [email],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'email',
                lower: [email],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'email',
                lower: [],
                upper: [email],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DriveAccountQueryFilter
    on QueryBuilder<DriveAccount, DriveAccount, QFilterCondition> {
  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'credentialsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'credentialsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'credentialsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'credentialsJson', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  credentialsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'credentialsJson', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'displayName'),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'displayName'),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'displayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'displayName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'displayName', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'email',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  emailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> emailContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> emailMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'email',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  lastUploadDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastUploadDate', value: value),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  lastUploadDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastUploadDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  lastUploadDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastUploadDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  lastUploadDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastUploadDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'photoUrl'),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'photoUrl'),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'photoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'photoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'photoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'photoUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'photoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'photoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'photoUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'photoUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'photoUrl', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  photoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'photoUrl', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rootFolderId'),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rootFolderId'),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rootFolderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rootFolderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rootFolderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rootFolderId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rootFolderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rootFolderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rootFolderId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rootFolderId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rootFolderId', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  rootFolderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rootFolderId', value: ''),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  uploadedBytesTodayEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uploadedBytesToday',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  uploadedBytesTodayGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uploadedBytesToday',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  uploadedBytesTodayLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uploadedBytesToday',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterFilterCondition>
  uploadedBytesTodayBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uploadedBytesToday',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension DriveAccountQueryObject
    on QueryBuilder<DriveAccount, DriveAccount, QFilterCondition> {}

extension DriveAccountQueryLinks
    on QueryBuilder<DriveAccount, DriveAccount, QFilterCondition> {}

extension DriveAccountQuerySortBy
    on QueryBuilder<DriveAccount, DriveAccount, QSortBy> {
  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  sortByCredentialsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credentialsJson', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  sortByCredentialsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credentialsJson', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  sortByLastUploadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUploadDate', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  sortByLastUploadDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUploadDate', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> sortByPhotoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoUrl', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> sortByPhotoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoUrl', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> sortByRootFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootFolderId', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  sortByRootFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootFolderId', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  sortByUploadedBytesToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadedBytesToday', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  sortByUploadedBytesTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadedBytesToday', Sort.desc);
    });
  }
}

extension DriveAccountQuerySortThenBy
    on QueryBuilder<DriveAccount, DriveAccount, QSortThenBy> {
  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  thenByCredentialsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credentialsJson', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  thenByCredentialsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'credentialsJson', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  thenByLastUploadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUploadDate', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  thenByLastUploadDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUploadDate', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByPhotoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoUrl', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByPhotoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoUrl', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy> thenByRootFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootFolderId', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  thenByRootFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootFolderId', Sort.desc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  thenByUploadedBytesToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadedBytesToday', Sort.asc);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QAfterSortBy>
  thenByUploadedBytesTodayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadedBytesToday', Sort.desc);
    });
  }
}

extension DriveAccountQueryWhereDistinct
    on QueryBuilder<DriveAccount, DriveAccount, QDistinct> {
  QueryBuilder<DriveAccount, DriveAccount, QDistinct>
  distinctByCredentialsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'credentialsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QDistinct> distinctByDisplayName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QDistinct> distinctByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QDistinct>
  distinctByLastUploadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUploadDate');
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QDistinct> distinctByPhotoUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QDistinct> distinctByRootFolderId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rootFolderId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DriveAccount, DriveAccount, QDistinct>
  distinctByUploadedBytesToday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uploadedBytesToday');
    });
  }
}

extension DriveAccountQueryProperty
    on QueryBuilder<DriveAccount, DriveAccount, QQueryProperty> {
  QueryBuilder<DriveAccount, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DriveAccount, String, QQueryOperations>
  credentialsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'credentialsJson');
    });
  }

  QueryBuilder<DriveAccount, String?, QQueryOperations> displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<DriveAccount, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<DriveAccount, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<DriveAccount, DateTime, QQueryOperations>
  lastUploadDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUploadDate');
    });
  }

  QueryBuilder<DriveAccount, String?, QQueryOperations> photoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoUrl');
    });
  }

  QueryBuilder<DriveAccount, String?, QQueryOperations> rootFolderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rootFolderId');
    });
  }

  QueryBuilder<DriveAccount, double, QQueryOperations>
  uploadedBytesTodayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uploadedBytesToday');
    });
  }
}
