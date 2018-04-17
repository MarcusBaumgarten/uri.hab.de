<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit78daec5e1761b48dba06a78068db3ccf
{
    public static $files = array (
        '5255c38a0faeba867671b61dfda6d864' => __DIR__ . '/..' . '/paragonie/random_compat/lib/random.php',
        '0e6d7bf4a5811bfa5cf40c5ccd6fae6a' => __DIR__ . '/..' . '/symfony/polyfill-mbstring/bootstrap.php',
        '023d27dca8066ef29e6739335ea73bad' => __DIR__ . '/..' . '/symfony/polyfill-php70/bootstrap.php',
    );

    public static $prefixLengthsPsr4 = array (
        'S' => 
        array (
            'Symfony\\Polyfill\\Php70\\' => 23,
            'Symfony\\Polyfill\\Mbstring\\' => 26,
            'Symfony\\Component\\HttpFoundation\\' => 33,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Symfony\\Polyfill\\Php70\\' => 
        array (
            0 => __DIR__ . '/..' . '/symfony/polyfill-php70',
        ),
        'Symfony\\Polyfill\\Mbstring\\' => 
        array (
            0 => __DIR__ . '/..' . '/symfony/polyfill-mbstring',
        ),
        'Symfony\\Component\\HttpFoundation\\' => 
        array (
            0 => __DIR__ . '/..' . '/symfony/http-foundation',
        ),
    );

    public static $prefixesPsr0 = array (
        'H' => 
        array (
            'HAB\\Pica' => 
            array (
                0 => __DIR__ . '/..' . '/hab/picareader/src',
                1 => __DIR__ . '/..' . '/hab/picarecord/src',
                2 => __DIR__ . '/..' . '/hab/picawriter/src',
            ),
        ),
    );

    public static $classMap = array (
        'ArithmeticError' => __DIR__ . '/..' . '/symfony/polyfill-php70/Resources/stubs/ArithmeticError.php',
        'AssertionError' => __DIR__ . '/..' . '/symfony/polyfill-php70/Resources/stubs/AssertionError.php',
        'DivisionByZeroError' => __DIR__ . '/..' . '/symfony/polyfill-php70/Resources/stubs/DivisionByZeroError.php',
        'Error' => __DIR__ . '/..' . '/symfony/polyfill-php70/Resources/stubs/Error.php',
        'ParseError' => __DIR__ . '/..' . '/symfony/polyfill-php70/Resources/stubs/ParseError.php',
        'SessionUpdateTimestampHandlerInterface' => __DIR__ . '/..' . '/symfony/polyfill-php70/Resources/stubs/SessionUpdateTimestampHandlerInterface.php',
        'TypeError' => __DIR__ . '/..' . '/symfony/polyfill-php70/Resources/stubs/TypeError.php',
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInit78daec5e1761b48dba06a78068db3ccf::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInit78daec5e1761b48dba06a78068db3ccf::$prefixDirsPsr4;
            $loader->prefixesPsr0 = ComposerStaticInit78daec5e1761b48dba06a78068db3ccf::$prefixesPsr0;
            $loader->classMap = ComposerStaticInit78daec5e1761b48dba06a78068db3ccf::$classMap;

        }, null, ClassLoader::class);
    }
}
