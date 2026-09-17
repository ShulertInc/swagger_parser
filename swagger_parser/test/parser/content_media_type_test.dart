import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:swagger_parser/swagger_parser.dart';
import 'package:test/test.dart';

void main() {
  Future<String> generatedClient({required bool useMultipartFile}) async {
    final root = await Directory.systemTemp.createTemp('swagger-parser-test-');
    addTearDown(() => root.delete(recursive: true));

    final schema = File(p.join(root.path, 'openapi.json'))
      ..writeAsStringSync(r'''
{
  "openapi": "3.1.0",
  "info": {"title": "Uploads", "version": "1.0.0"},
  "paths": {
    "/images": {
      "post": {
        "tags": ["images"],
        "operationId": "upload_image",
        "requestBody": {
          "required": true,
          "content": {
            "multipart/form-data": {
              "schema": {"$ref": "#/components/schemas/Body_upload_image"}
            }
          }
        },
        "responses": {"200": {"description": "OK"}}
      }
    }
  },
  "components": {
    "schemas": {
      "Body_upload_image": {
        "type": "object",
        "required": ["file"],
        "properties": {
          "file": {
            "type": "string",
            "contentMediaType": "application/octet-stream"
          },
          "encoded": {
            "anyOf": [
              {"type": "string", "contentMediaType": "image/png", "contentEncoding": "base64"},
              {"type": "null"}
            ]
          },
          "caption": {"anyOf": [{"type": "string"}, {"type": "null"}]}
        }
      }
    }
  }
}
''');

    await GenProcessor(
      SWPConfig(
        schemaPath: schema.path,
        outputDirectory: p.join(root.path, 'generated'),
        putClientsInFolder: true,
        useMultipartFile: useMultipartFile,
      ),
    ).generateFiles();

    return File(
      p.join(root.path, 'generated', 'clients', 'images_client.dart'),
    ).readAsStringSync();
  }

  test('an OpenAPI 3.1 raw content media type uploads as a file', () async {
    final client = await generatedClient(useMultipartFile: true);

    expect(client, contains("@Part(name: 'file') required MultipartFile file"));
    expect(client, contains("@Part(name: 'encoded') String? encoded"));
    expect(client, contains("@Part(name: 'caption') String? caption"));
  });

  test('a raw content media type is a File without multipart files', () async {
    final client = await generatedClient(useMultipartFile: false);

    expect(client, contains("@Part(name: 'file') required File file"));
  });
}
