<?php

/**
 * @file
 * Platform.sh settings shared between environments.
 */

// Configure the database.
if (isset($_ENV['PLATFORM_RELATIONSHIPS'])) {
  $relationships = json_decode(base64_decode($_ENV['PLATFORM_RELATIONSHIPS']), TRUE);

  if (empty($databases['default']['default']) && !empty($relationships['database'])) {
    foreach ($relationships['database'] as $endpoint) {
      $database = [
        'driver' => $endpoint['scheme'],
        'database' => $endpoint['path'],
        'username' => $endpoint['username'],
        'password' => $endpoint['password'],
        'host' => $endpoint['host'],
        'port' => $endpoint['port'],
      ];

      if (!empty($endpoint['query']['compression'])) {
        $database['pdo'][PDO::MYSQL_ATTR_COMPRESS] = TRUE;
      }

      if (!empty($endpoint['query']['is_master'])) {
        $databases['default']['default'] = $database;
      }
      else {
        $databases['default']['slave'][] = $database;
      }
    }
  }
}

// Configure private and temporary file paths.
if (isset($_ENV['PLATFORM_APP_DIR'])) {
  if (!isset($settings['file_private_path'])) {
    $settings['file_private_path'] = $_ENV['PLATFORM_APP_DIR'] . '/private';
  }
  if (!isset($settings['file_temp_path'])) {
    $settings['file_temp_path'] = $_ENV['PLATFORM_APP_DIR'] . '/tmp';
  }
}

// Set trusted hosts based on Platform.sh routes.
if (isset($_ENV['PLATFORM_ROUTES']) && !isset($settings['trusted_host_patterns'])) {
  $routes = json_decode(base64_decode($_ENV['PLATFORM_ROUTES']), TRUE);
  $settings['trusted_host_patterns'] = [];
  foreach ($routes as $url => $route) {
    $host = parse_url($url, PHP_URL_HOST);
    if ($host !== FALSE && $route['type'] == 'upstream' && $route['upstream'] == $_ENV['PLATFORM_APPLICATION_NAME']) {
      $settings['trusted_host_patterns'][] = '^' . preg_quote($host) . '$';
    }
  }
  $settings['trusted_host_patterns'] = array_unique($settings['trusted_host_patterns']);
}

// Set config directory.
$settings['config_sync_directory'] = $_ENV['PLATFORM_APP_DIR'] . '/configuration/sync';

// Set hash salt, used for transient hashes (eg. the reset-user token).
$settings['hash_salt'] = '';
