import 'package:swagger_parser/src/generator/model/programming_language.dart';
import 'package:swagger_parser/src/parser/swagger_parser_core.dart';
import 'package:swagger_parser/src/utils/type_utils.dart';

String? dartValidationConstants(UniversalType type) {
  final sb = StringBuffer();
  if (type.min != null) {
    final numType = type.type == 'integer' ? int : double;
    final min = numType == int ? type.min?.toInt() : type.min;
    sb.write('  static const $numType ${type.name}Min = $min;\n');
  }

  if (type.max != null) {
    final numType = type.type == 'integer' ? int : double;
    final max = numType == int ? type.max?.toInt() : type.max;
    sb.write('  static const $numType ${type.name}Max = $max;\n');
  }

  if (type.minItems != null) {
    sb.write('  static const int ${type.name}MinItems = ${type.minItems};\n');
  }

  if (type.maxItems != null) {
    sb.write('  static const int ${type.name}MaxItems = ${type.maxItems};\n');
  }

  if (type.minLength != null) {
    sb.write('  static const int ${type.name}MinLength = ${type.minLength};\n');
  }

  if (type.maxLength != null) {
    sb.write('  static const int ${type.name}MaxLength = ${type.maxLength};\n');
  }

  if (type.pattern != null) {
    sb.write(
      '  static const String ${type.name}Pattern = ${_dartString(type.pattern!)};\n',
    );
  }

  if (type.uniqueItems != null) {
    sb.write(
      '  static const bool ${type.name}UniqueItems = ${type.uniqueItems};\n',
    );
  }

  return sb.isEmpty ? null : sb.toString();
}

String dartValidateExtension(String className, Set<UniversalType> types) {
  final conditions = <String>[];

  for (final type in types) {
    final constant = '$className.${type.name}';
    final dartType = type.toSuitableType(
      ProgrammingLanguage.dart,
      useMultipartFile: false,
    );
    final isDynamic = dartType == 'dynamic';
    final isCollection = type.wrappingCollections.isNotEmpty;
    final baseType = dartType.replaceAll('?', '');
    final isText = !isCollection && (baseType == 'String' || isDynamic);
    final isNumber = !isCollection &&
        (const {'int', 'double', 'num'}.contains(baseType) || isDynamic);
    final isList = isCollection || isDynamic;
    final nullable = dartType.endsWith('?') || isDynamic;
    final guard = nullable ? '${type.name} != null && ' : '';
    final value = nullable ? '${type.name}!' : '${type.name}';

    if (isNumber && type.min != null) {
      conditions.add('$guard$value < ${constant}Min');
    }
    if (isNumber && type.max != null) {
      conditions.add('$guard$value > ${constant}Max');
    }
    if (isList && type.minItems != null) {
      conditions.add('$guard$value.length < ${constant}MinItems');
    }
    if (isList && type.maxItems != null) {
      conditions.add('$guard$value.length > ${constant}MaxItems');
    }
    if (isText && type.minLength != null) {
      conditions.add('$guard$value.runes.length < ${constant}MinLength');
    }
    if (isText && type.maxLength != null) {
      conditions.add('$guard$value.runes.length > ${constant}MaxLength');
    }
    if (isText && type.pattern != null) {
      conditions.add(
        '$guard!RegExp(${constant}Pattern, unicode: true).hasMatch($value)',
      );
    }
    if (isList && type.uniqueItems != null) {
      conditions.add(
        '$guard${constant}UniqueItems && $value.toSet().length != $value.length',
      );
    }
  }

  if (conditions.isEmpty) {
    return '';
  }

  final funcBuffer = StringBuffer()
    ..write('extension ${className}ValidationX on $className {\n')
    ..write('bool validate() {\n');
  for (final condition in conditions) {
    funcBuffer
      ..write('try {\n')
      ..write('  if ($condition) {\n')
      ..write('    return false;\n')
      ..write('  }\n')
      ..write('} catch (e) {\n')
      ..write('  return false;\n')
      ..write('}\n');
  }
  funcBuffer
    ..write('  return true;\n}\n')
    ..write('}\n');

  return funcBuffer.toString();
}

String _dartString(String value) {
  final escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$')
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r');
  return "'$escaped'";
}
