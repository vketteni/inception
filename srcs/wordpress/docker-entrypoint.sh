#!/bin/bash

set -e

# Define the target directory where the volume is mounted
TARGET_DIR="/var/www/html"

# Check if the volume is empty
if [ -z "$(ls -A $TARGET_DIR)" ]; then
  echo "Volume is empty. Initializing WordPress setup in $TARGET_DIR..."

  # Ensure the target directory is owned by the correct user
  chown -R 1000:1000 $TARGET_DIR

  # Copy initial WordPress files
  cp -R /usr/src/wordpress/* $TARGET_DIR

  # Create wp-config.php
  echo "Generating wp-config.php..."

  cat <<EOF > "$TARGET_DIR/wp-config.php"
<?php
define( 'WP_DEBUG', 'true' );
define( 'WP_DEBUG_LOG', 'true' );
define( 'WP_DEBUG_DISPLAY', 'false' );
define( 'DB_NAME', '$WORDPRESS_DB_NAME' );
define( 'DB_USER', '$WORDPRESS_DB_USER' );
define( 'DB_PASSWORD', '$WORDPRESS_DB_PASSWORD' );
define( 'DB_HOST', '$WORDPRESS_DB_HOST' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// Add the table prefix
\$table_prefix = 'wp_';

// Authentication Unique Keys and Salts
$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

// Define the absolute path to the WordPress directory
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}

// Include WordPress settings
require_once ABSPATH . 'wp-settings.php';
EOF

  # Set appropriate ownership and permissions for wp-config.php
  chmod 644 "$TARGET_DIR/wp-config.php"

else
  echo "Volume already contains data. Skipping initialization."
  echo "Existing files in $TARGET_DIR:"
  ls -A $TARGET_DIR
fi

# Execute the original entrypoint or command
exec "$@"

