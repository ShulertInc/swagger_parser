import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:swagger_parser/swagger_parser.dart';
import 'package:test/test.dart';

void main() {
  test('keeps a listed schema and its dependencies that no endpoint uses',
      () async {
    final root = await Directory.systemTemp.createTemp('swagger-parser-test-');
    addTearDown(() => root.delete(recursive: true));

    final schema = File(p.join(root.path, 'openapi.yaml'))
      ..writeAsStringSync(r'''
openapi: 3.0.0
info:
  title: Keep schemas
  version: 1.0.0
paths:
  /public:
    get:
      tags: [public]
      responses:
        '200':
          description: OK
  /admin:
    get:
      tags: [admin]
      responses:
        '200':
          description: OK
components:
  schemas:
    Frame:
      type: object
      properties:
        kind:
          $ref: '#/components/schemas/FrameKind'
    FrameKind:
      type: string
      enum: [hello, ping]
    Unused:
      type: object
      properties:
        name:
          type: string
''');

    await GenProcessor(
      SWPConfig(
        schemaPath: schema.path,
        outputDirectory: p.join(root.path, 'generated'),
        excludeTags: ['admin'],
        keepSchemas: ['Frame'],
        putClientsInFolder: true,
      ),
    ).generateFiles();

    bool generated(String file) =>
        File(p.join(root.path, 'generated', 'models', file)).existsSync();
    expect(generated('frame.dart'), isTrue);
    expect(generated('frame_kind.dart'), isTrue);
    expect(generated('unused.dart'), isFalse);
  });
}
