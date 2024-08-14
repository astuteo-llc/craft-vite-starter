<?php

use craft\helpers\Console;
use craft\helpers\StringHelper;

require_once 'ScriptHelpers.php';
require_once 'vendor/autoload.php';

$cwd = getcwd();

/**
 * Prompt the user for input
 */
$projectName = Console::prompt('What is the name of your project (Example: My Client Name)? ', [
    'required' => true,
]);

Console::output("Great! We'll use the name: $projectName");

$suggestedProjectSlug = StringHelper::toKebabCase($projectName);

$projectSlugPrompt = Console::prompt("Customize the project slug? This controls the DDEV URL, etc.", [
    'default' => $suggestedProjectSlug,
]);
$projectSlug = !empty(trim($projectSlugPrompt)) ? StringHelper::toKebabCase($projectSlugPrompt) : $suggestedProjectSlug;

Console::output("Great! We'll use $projectSlug");

/*
 * Ask scripts
 */
Console::output("Next up we're going to ask about the scripts. You can leave these blank if you don't want to use them and adjust later in the scripts/config.sh file.");
$prodIp = Console::prompt('What is the ip address for production? ', [
    'required' => false,
]);
$prodUsername = Console::prompt('What is the ssh username for production? ', [
    'required' => false,
]);
$prodPath = Console::prompt('What is the full path the root? Include trailing / ', [
    'required' => false,
]);

$stagingIp = Console::prompt('What is the ip address for production? ', [
    'required' => false,
]);
$stagingUsername = Console::prompt('What is the ssh username for production? ', [
    'required' => false,
]);
$stagingPath = Console::prompt('What is the full path the root? Include trailing / ', [
    'required' => false,
]);

/**
 * Update DDEV config
 */

ScriptHelpers::replaceFileText(
    filePath: "$cwd/.ddev/config.yaml",
    pattern: "/name:\s+astuteo-craft-starter/",
    replacement: "name: $projectSlug",
);

/**
 * Update package.json
 */

ScriptHelpers::replaceFileText(
    filePath: "$cwd/package.json",
    pattern: "/\"name\": \"astuteo-craft-starter\"/",
    replacement: "\"name\": \"$projectSlug\"",
);

ScriptHelpers::replaceFileText(
    filePath: "$cwd/package-lock.json",
    pattern: "/\"name\": \"astuteo-craft-starter\"/",
    replacement: "\"name\": \"$projectSlug\"",
);

/**
 * Update scripts
 */

ScriptHelpers::replaceFileText(
    filePath: "$cwd/scripts/config.sh",
    pattern: "[prodSshUsername]",
    replacement: "$prodUsername",
);
ScriptHelpers::replaceFileText(
    filePath: "$cwd/scripts/config.sh",
    pattern: "[prodIp]",
    replacement: "$prodIp"
);
ScriptHelpers::replaceFileText(
    filePath: "$cwd/scripts/config.sh",
    pattern: "[prodPath]",
    replacement: "$prodPath"
);

ScriptHelpers::replaceFileText(
    filePath: "$cwd/scripts/config.sh",
    pattern: "[prodSshUsername]",
    replacement: "$prodUsername",
);
ScriptHelpers::replaceFileText(
    filePath: "$cwd/scripts/config.sh",
    pattern: "[stagingSshUsername]",
    replacement: "$stagingUsername"
);
ScriptHelpers::replaceFileText(
    filePath: "$cwd/scripts/config.sh",
    pattern: "[stagingIp]",
    replacement: "$stagingIp"
);
ScriptHelpers::replaceFileText(
    filePath: "$cwd/scripts/config.sh",
    pattern: "[stagingPath]",
    replacement: "$stagingPath"
);

ScriptHelpers::replaceFileText(
    filePath: "$cwd/scripts/config.staging.sh",
    pattern: "[stagingPath]",
    replacement: "$stagingPath"
);


/**
 * Update project config
 */

ScriptHelpers::replaceFileText(
    filePath: "$cwd/config/project/project.yaml",
    pattern: "/Astuteo Craft Starter/",
    replacement: "$projectName",
);

// Replace plugin license keys.
// These are regenerated when viewing the Control Panel
ScriptHelpers::replaceFileText(
    filePath: "$cwd/config/project/project.yaml",
    pattern: "/    licenseKey: REPLACE[\r\n|\r|\n]/", // Make sure to remove new line too
    replacement: "",
);

ScriptHelpers::replaceFileText(
    filePath: "$cwd/config/project/siteGroups/805d8826-faed-4186-9b88-f509eb9b07e6.yaml",
    pattern: "/Astuteo Craft Starter/",
    replacement: "$projectName",
);

ScriptHelpers::replaceFileText(
    filePath: "$cwd/config/project/sites/default--35b563a0-4662-40b9-b885-a8450a2868d9.yaml",
    pattern: "/Astuteo Craft Starter/",
    replacement: "$projectName",
);

/**
 * .gitignore
 */

ScriptHelpers::replaceFileText(
    filePath: "$cwd/.gitignore",
    pattern: "/# BEGIN-STARTER-ONLY\X*# END-STARTER-ONLY/m",
    replacement: '',
);
