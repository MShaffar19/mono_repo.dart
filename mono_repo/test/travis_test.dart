// Doing a copy-paste from JSON – which uses double-quotes
// ignore_for_file: prefer_single_quotes

import 'package:mono_repo/src/travis_config.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart' as y;

import 'package:mono_repo/src/utils.dart';

void main() {
  test('sanity', () {
    var travisYaml = y.loadYaml(_config) as Map<String, dynamic>;

    var config = new TravisConfig.parse('test', travisYaml);

    expect(config.package, 'test');
    expect(config.sdks, unorderedEquals(['dev', 'stable', '1.23.0']));

    var jobs = config.travisJobs.toList();

    expect(jobs, hasLength(15));

    expect(encodeJson(jobs), encodeJson(_expectedOutput));
  });
}

final _config = r'''
dart:
 - dev
 - stable
 - 1.23.0

env:
 - FORCE_TEST_EXIT=true

# Content shell needs these fonts.
addons:
  something: also here for completeness

before_install:
  - ignored for now
  - just here for completeness

dart_task:
 - test: --platform dartium
   install_dartium: true
 - test: --preset travis --total-shards 5 --shard-index 0
   install_dartium: true
 - test: --preset travis --total-shards 5 --shard-index 1
 - test #no args
 - dartanalyzer

matrix:
  exclude:
    - dart: stable
      dart_task: dartanalyzer
  include:
    - dart: dev
      dart_task: dartfmt
''';

List get _expectedOutput => [
      {
        "sdk": "dev",
        "task": {
          "name": "test",
          "args": "--platform dartium",
          "config": {"install_dartium": true}
        }
      },
      {
        "sdk": "dev",
        "task": {
          "name": "test",
          "args": "--preset travis --total-shards 5 --shard-index 0",
          "config": {"install_dartium": true}
        }
      },
      {
        "sdk": "dev",
        "task": {
          "name": "test",
          "args": "--preset travis --total-shards 5 --shard-index 1"
        }
      },
      {
        "sdk": "dev",
        "task": {"name": "test"}
      },
      {
        "sdk": "dev",
        "task": {"name": "dartanalyzer"}
      },
      {
        "sdk": "stable",
        "task": {
          "name": "test",
          "args": "--platform dartium",
          "config": {"install_dartium": true}
        }
      },
      {
        "sdk": "stable",
        "task": {
          "name": "test",
          "args": "--preset travis --total-shards 5 --shard-index 0",
          "config": {"install_dartium": true}
        }
      },
      {
        "sdk": "stable",
        "task": {
          "name": "test",
          "args": "--preset travis --total-shards 5 --shard-index 1"
        }
      },
      {
        "sdk": "stable",
        "task": {"name": "test"}
      },
      {
        "sdk": "1.23.0",
        "task": {
          "name": "test",
          "args": "--platform dartium",
          "config": {"install_dartium": true}
        }
      },
      {
        "sdk": "1.23.0",
        "task": {
          "name": "test",
          "args": "--preset travis --total-shards 5 --shard-index 0",
          "config": {"install_dartium": true}
        }
      },
      {
        "sdk": "1.23.0",
        "task": {
          "name": "test",
          "args": "--preset travis --total-shards 5 --shard-index 1"
        }
      },
      {
        "sdk": "1.23.0",
        "task": {"name": "test"}
      },
      {
        "sdk": "1.23.0",
        "task": {"name": "dartanalyzer"}
      },
      {
        "sdk": "dev",
        "task": {"name": "dartfmt"}
      }
    ];
