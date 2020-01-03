<?php

/**
 * @file
 * Settings-file for Docker development environments.
 */

use Drupal\Component\Assertion\Handle;

$databases['default']['default'] = array(
  'driver' => 'mysql',
  'database' => 'db',
  'username' => 'db',
  'password' => 'db',
  'host' => 'db',
  'prefix' => '',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);

$settings['hash_salt'] = 'hardcodedsaltshouldneverbeusedoutsidedocker';
$settings['update_free_access'] = FALSE;
$settings['container_yamls'][] = __DIR__ . '/docker.services.yml';

// Private files.
$settings['file_private_path'] = '/var/www/private';

$settings['config_sync_directory'] = __DIR__ . '/../../../configuration/sync';

// Allow *.docker and *.ngrok.io domains.
$settings['trusted_host_patterns'] = [
  '^.*\.docker$',
  '.*\.ngrok\.io$',
  'localhost',
];

// Assertions.
assert_options(ASSERT_ACTIVE, TRUE);
Handle::register();

// Show all error messages, with backtrace information.
$config['system.logging']['error_level'] = 'verbose';

// Disable CSS and JS aggregation.
$config['system.performance']['css']['preprocess'] = FALSE;
$config['system.performance']['js']['preprocess'] = FALSE;

// Allow test modules and themes to be installed.
$settings['extension_discovery_scan_tests'] = TRUE;

// Enable access to rebuild.php.
$settings['rebuild_access'] = TRUE;

// Set up stage file proxy.
$config['stage_file_proxy.settings']['origin'] = '';
