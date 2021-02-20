#!/bin/bash

sudo yum -y update
sudo yum install -y httpd
sudo service httpd start

cd /home/ec2-user
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz

cd wordpress
sudo touch wp-config.php
sudo chmod 644 wp-config.php


cat >> wp-config.php <<'EOF'
<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', '${db_username}' );

/** MySQL database password */
define( 'DB_PASSWORD', '${db_password}' );

/** MySQL hostname */
define( 'DB_HOST', '${db_hostname}' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '$L~xKGmXX9d{/WM[I:4+R/t:]o=l*ZK$O|$/*LWw+Y | .9.+ylzcgOCk8k4IH<1' );
define( 'SECURE_AUTH_KEY',  'cCj}@}fR~8l c<A+@u!T>eh.,: 5GTpsh)dZV>l,lb.n[D`qv}gH03KZi8zo)Yiz' );
define( 'LOGGED_IN_KEY',    '~I6nPY28ZaHA-s+G)KeC{U/rQ)fXv4x.qy;+Qjo|{{FR7&uBq`-.~|$`|&DGkKdW' );
define( 'NONCE_KEY',        'aLz= m6Z+pF_US)Hd|>g_/F}?YWJ3LOY(LqJ7Pp>eL!=u:|SxB^1+]ZG*#V8;E.g' );
define( 'AUTH_SALT',        '{6P4Crnf>2R[x~2|L+OWZ/SvH|Q|5AO4svG?n^Oc5`N{rvb]Dg-]sgK#07WB.N1O' );
define( 'SECURE_AUTH_SALT', '{$!5S~u9P_8F{sYV9_0{U4*Qse,p6 /0XRUU@+*(&9yP0GoefI~Y(<w&=uT2gi{P' );
define( 'LOGGED_IN_SALT',   'E8ng}pgNTI6VddM<)-YbATz!#z}@JJkS+?+ q-r1gn/A|6b/bIW;-xD$(n*zKAga' );
define( 'NONCE_SALT',       '`nuj.,z$!~:oba;j&1M*%fjJ1BC,>i du[4C^G&^fZa!IU7b>3>L]+M)uD^|D0AL' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
EOF

sudo amazon-linux-extras install -y php7.2

cd /home/ec2-user
sudo cp -r wordpress/* /var/www/html/
sudo service httpd restart
