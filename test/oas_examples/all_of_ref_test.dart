import 'dart:io';
import 'package:openapi_spec/openapi_spec.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

// Playground for working on improving all_of support
void main() async {
  final schemaDir = Directory(p.join('test', 'oas_examples', 'v3.0'));
  final schemaFile = File(p.join(schemaDir.path, 'petstore-expanded.yaml'));
  final generatedClientDir =
      Directory(p.join('test', 'oas_examples', 'all_of_ref_output'));

  setUpAll(() {
    if (!schemaDir.existsSync()) {
      fail('test schema directory not found');
    }
    if (!generatedClientDir.existsSync()) {
      generatedClientDir.createSync(recursive: true);
    }
  });

  test('generate schema', () async {
    final spec = OpenApi.fromFile(source: schemaFile.absolute.path);

    await spec.generate(
      package: 'all_of_ref',
      destination: generatedClientDir.path,
      replace: true,
      schemaOptions: SchemaGeneratorOptions(singleFile: true),
    );

    // run build_runner
    await Process.run(
      'dart',
      ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
    );
  });
}
