<?php
use craft\config\GeneralConfig;
use craft\helpers\App;

$isDev = App::env('CRAFT_ENVIRONMENT') === 'dev';
$isProd = App::env('CRAFT_ENVIRONMENT') === 'production';

return GeneralConfig::create()
    ->defaultWeekStartDay(1)
    ->omitScriptNameInUrls(true)
    ->defaultTokenDuration('P1W')
    ->maxRevisions(10)
    ->transformGifs(false)
    ->devMode($isDev)
    ->backupOnUpdate(!$isDev)
    ->allowAdminChanges($isDev)
    ->disallowRobots(!$isProd);
