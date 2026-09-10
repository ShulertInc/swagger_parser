import 'package:collection/collection.dart';
import 'package:swagger_parser/src/generator/model/programming_language.dart';
import 'package:swagger_parser/src/generator/templates/dart_validation_template.dart';
import 'package:swagger_parser/src/parser/model/normalized_identifier.dart';
import 'package:swagger_parser/src/parser/swagger_parser_core.dart';
import 'package:swagger_parser/src/utils/base_utils.dart';
import 'package:swagger_parser/src/utils/type_utils.dart';

/// Provides template for generating dart DTO using freezed
String dartFreezedDtoTemplate(
  UniversalComponentClass dataClass, {
  required bool useMultipartFile,
  required bool includeIfNull,
  bool generateValidator = false,
  bool isV3 = false,
  bool useFlutterCompute = false,
  String? fallbackUnion,
}) {
  final className = dataClass.name;
  final discriminator = dataClass.discriminator;
  final isUndiscriminatedUnion =
      dataClass.undiscriminatedUnionVariants?.isNotEmpty ?? false;
  final isUnion = discriminator != null || isUndiscriminatedUnion;
  final serializerClass =
      useFlutterCompute ? _generateFlutterComputeSerializer(className) : '';
  final asyncImport = useFlutterCompute ? "import 'dart:async';\n\n" : '';

  return '''
$asyncImport${ioImport(dataClass.parameters, useMultipartFile: useMultipartFile)}import 'package:freezed_annotation/freezed_annotation.dart';
${isUndiscriminatedUnion ? "import 'package:json_annotation/json_annotation.dart';\n" : ''}${dartImports(imports: _filterUnionImportsForFreezed(dataClass))}
part '${dataClass.name.toSnake}.freezed.dart';
part '${dataClass.name.toSnake}.g.dart';

${descriptionComment(dataClass.description)}@Freezed(${[
    if (discriminator != null) "unionKey: '${discriminator.propertyName}'",
    if (discriminator != null &&
        fallbackUnion != null &&
        fallbackUnion.isNotEmpty)
      "fallbackUnion: '$fallbackUnion'",
  ].join(', ')})
${_classModifier(isUnion: isUnion, isV3: isV3)}class $className with _\$$className {
${_factories(dataClass, className, useMultipartFile, includeIfNull, fallbackUnion, isUnion: isUnion)}
${_jsonFactories(className, dataClass.undiscriminatedUnionVariants)}
${generateValidator ? dataClass.parameters.map(dartValidationConstants).nonNulls.join() : ''}}
${generateValidator ? dartValidateExtension(className, dataClass.parameters) : ''}$serializerClass''';
}

String _classModifier({required bool isUnion, required bool isV3}) {
  return switch ((isUnion, isV3)) {
    (true, _) => 'sealed ',
    (false, true) => 'abstract ',
    _ => '',
  };
}

String _factories(UniversalComponentClass dataClass, String className,
    bool useMultipartFile, bool includeIfNull, String? fallbackUnion,
    {required bool isUnion}) {
  if (!isUnion) {
    return '''
  const factory $className(${dataClass.parameters.isNotEmpty ? '{' : ''}${_parametersToString(dataClass.parameters, useMultipartFile, includeIfNull)}${dataClass.parameters.isNotEmpty ? '\n  }' : ''}) = _$className;''';
  }

  if (dataClass.undiscriminatedUnionVariants case final variants?
      when variants.isNotEmpty) {
    return _createFactoriesForUndiscriminatedUnion(
      className,
      variants,
      useMultipartFile,
      includeIfNull,
    );
  }

  final factories = <String>[];
  for (final discriminatorValue
      in dataClass.discriminator!.discriminatorValueToRefMapping.keys) {
    final (protectedName, _) = protectName(discriminatorValue, isMethod: true);
    final factoryName = protectedName!.toCamel;
    final discriminatorRef = dataClass
        .discriminator!.discriminatorValueToRefMapping[discriminatorValue]!;
    final factoryParameters =
        dataClass.discriminator!.refProperties[discriminatorRef]!;
    final unionItemClassName = className + discriminatorValue.toPascal;

    factories.add('''
  @FreezedUnionValue('$discriminatorValue')
  const factory $className.$factoryName(${factoryParameters.isNotEmpty ? '{' : ''}${_parametersToString(factoryParameters, useMultipartFile, includeIfNull)}${factoryParameters.isNotEmpty ? '\n  }' : ''}) = $unionItemClassName;
''');
  }

  if (fallbackUnion != null && fallbackUnion.isNotEmpty) {
    final (protectedFallbackName, _) =
        protectName(fallbackUnion, isMethod: true);
    final fallbackFactoryName = protectedFallbackName!.toCamel;
    final unionItemClassName = className + fallbackUnion.toPascal;
    factories.add('''
  const factory $className.$fallbackFactoryName() = $unionItemClassName;
''');
  }

  return factories.join('\n');
}

String _createFactoriesForUndiscriminatedUnion(
    String className,
    Map<String, Set<UniversalType>> variants,
    bool useMultipartFile,
    bool includeIfNull) {
  final factories = <String>[];
  for (final MapEntry(key: variantName, value: factoryParameters)
      in variants.entries) {
    final (protectedName, _) = protectName(variantName, isMethod: true);
    final factoryName = protectedName!.toCamel;
    final unionItemClassName = className + variantName.toPascal;
    factories.add('''
  @JsonSerializable()
  const factory $className.$factoryName(${factoryParameters.isNotEmpty ? '{' : ''}${_parametersToString(factoryParameters, useMultipartFile, includeIfNull)}${factoryParameters.isNotEmpty ? '\n  }' : ''}) = $unionItemClassName;
  ''');
  }
  return factories.join('\n');
}

String _jsonFactories(String className,
    Map<String, Set<UniversalType>>? undiscriminatedUnionVariants) {
  if (undiscriminatedUnionVariants case final unionVariants?
      when unionVariants.isNotEmpty) {
    return _fromJsonUndiscriminatedUnion(className);
  }

  return '  \n  factory $className.fromJson(Map<String, Object?> json) => _\$${className}FromJson(json);';
}

String _fromJsonUndiscriminatedUnion(String className) => '''

  factory $className.fromJson(Map<String, Object?> json) =>
      // TODO: No discriminator in OpenAPI spec - you must implement this manually.
      //
      // Inspect the JSON and return the matching variant. Each variant has a fromJson:
      //   ${className}VariantName.fromJson(json)
      //
      // Example pattern (check for unique fields):
      //   json.containsKey('uniqueFieldA') ? ${className}TypeA.fromJson(json) :
      //   json.containsKey('uniqueFieldB') ? ${className}TypeB.fromJson(json) :
      //   ${className}Default.fromJson(json);
      //
      // IMPORTANT: Keep the => arrow syntax. Converting to a { } body will cause
      // freezed to skip generating toJson/fromJson for this class.
      throw UnimplementedError();
''';

String _parametersToString(
    Set<UniversalType> parameters, bool useMultipartFile, bool includeIfNull) {
  final sortedByRequired = Set<UniversalType>.from(
    parameters.sorted((a, b) => a.compareTo(b)),
  );
  return sortedByRequired
      .mapIndexed(
        (i, e) =>
            '\n${i != 0 && (e.description?.isNotEmpty ?? false) ? '\n' : ''}${descriptionComment(e.description, tab: '    ')}'
            '${_jsonKey(e, includeIfNull)}    ${_required(e)}'
            '${e.toSuitableType(ProgrammingLanguage.dart, useMultipartFile: useMultipartFile)} ${e.name},',
      )
      .join();
}

String _jsonKey(UniversalType t, bool includeIfNull) {
  final sb = StringBuffer();
  final jsonKeyParams = <String, String?>{};

  if (includeIfNull) {
    if (t.isRequired && (t.nullable || t.referencedNullable)) {
      jsonKeyParams['includeIfNull'] = 'true';
    } else if (!t.isRequired && (t.nullable || t.referencedNullable)) {
      jsonKeyParams['includeIfNull'] = 'false';
    }
  }

  if (t.jsonKey != null && t.name != t.jsonKey) {
    jsonKeyParams['name'] = "'${protectJsonKey(t.jsonKey)}'";
  }

  if (jsonKeyParams.isNotEmpty) {
    sb.write(
        "    @JsonKey(${jsonKeyParams.entries.map((e) => '${e.key}: ${e.value}').join(',')})\n");
  }

  if (t.defaultValue != null) {
    sb.write('    @Default(${_defaultValue(t)})\n');
  }

  if (t.deprecated) {
    sb.write("    @Deprecated('This is marked as deprecated')\n");
  }

  return sb.toString();
}

/// return required if isRequired
String _required(UniversalType t) =>
    t.isRequired && t.defaultValue == null ? 'required ' : '';

/// return defaultValue if have
String _defaultValue(UniversalType t) =>
    '${t.enumType != null ? '${t.type}.${protectDefaultEnum(t.defaultValue)?.toCamel}' : protectDefaultValue(t.defaultValue, type: t.type)}';

/// Generates top-level serialization functions for Flutter compute isolate support.
/// These functions follow Retrofit's naming convention for Parser.FlutterCompute.
String _generateFlutterComputeSerializer(String className) {
  return '''

// Flutter compute serialization functions for $className
FutureOr<$className> deserialize$className(Map<String, dynamic> json) =>
    $className.fromJson(json);

FutureOr<List<$className>> deserialize${className}List(List<Map<String, dynamic>> json) =>
    json.map((e) => $className.fromJson(e)).toList();

FutureOr<Map<String, dynamic>> serialize$className($className? object) =>
    object?.toJson() ?? <String, dynamic>{};

FutureOr<List<Map<String, dynamic>>> serialize${className}List(List<$className>? objects) =>
    objects?.map((e) => e.toJson()).toList() ?? [];
''';
}

/// Filters out the parent-union back-import for freezed union variants.
///
/// A discriminated-union *variant* (`discriminatorValue != null`) is inlined
/// into its parent union file, so the parent union gets injected into this
/// class's `imports` even though the variant never references that type. That
/// back-import must be dropped (it is a dependency cycle and is unused).
///
/// However, a variant may have its own `oneOf`-typed properties whose generated
/// union files it genuinely references and MUST import — otherwise the property
/// types are undefined and the file fails to compile. We tell the two apart by
/// keeping only the union imports that correspond to a type actually used by
/// one of this class's properties.
Set<String> _filterUnionImportsForFreezed(UniversalComponentClass dataClass) {
  // Only variants risk the parent-union back-import; every other class keeps
  // all of its imports untouched.
  if (dataClass.discriminatorValue == null) {
    return dataClass.imports;
  }

  final referencedTypes = <String>{
    for (final p in dataClass.parameters) p.type,
    ...?dataClass.allOf?.properties.map((p) => p.type),
  };

  final filteredImports = <String>{};

  for (final import in dataClass.imports) {
    final isUnionImport = import.toLowerCase().contains('union');
    // Keep non-union imports, and union imports that this class references
    // through its own properties (its inline `oneOf` fields). Drop the rest
    // (the parent union this variant belongs to).
    if (!isUnionImport || referencedTypes.contains(import)) {
      filteredImports.add(import);
    }
  }

  return filteredImports;
}
