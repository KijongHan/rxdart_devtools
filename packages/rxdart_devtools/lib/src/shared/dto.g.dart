// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortRequestDto _$SortRequestDtoFromJson(Map<String, dynamic> json) =>
    SortRequestDto(
      sortField: $enumDecode(_$SortFieldEnumMap, json['sortField']),
      sortDirection: SortDirection.fromJson(json['sortDirection'] as String),
    );

Map<String, dynamic> _$SortRequestDtoToJson(SortRequestDto instance) =>
    <String, dynamic>{
      'sortField': _$SortFieldEnumMap[instance.sortField]!,
      'sortDirection': _$SortDirectionEnumMap[instance.sortDirection]!,
    };

const _$SortFieldEnumMap = {
  SortField.timestamp: 'timestamp',
  SortField.streamId: 'streamId',
  SortField.lastUpdated: 'lastUpdated',
};

const _$SortDirectionEnumMap = {
  SortDirection.ascending: 'ascending',
  SortDirection.descending: 'descending',
};
