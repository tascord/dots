const { readFileSync, writeFileSync } = require('fs');
const { join } = require('path');
const { homedir } = require('os');

const WAL_FILE = join(homedir(), '.cache/wal/colors');
const THEME_FILE = join(__dirname, 'config.ini');

const map = {
    "background": 0,
    "background-alt": 8,
    "foreground": 7,
    "foreground-alt": 7,
    "primary": 1,
    "secondary": 2,
    "alert": 3,
};

const colors = readFileSync(WAL_FILE).toString().split('\n');
let theme = readFileSync(THEME_FILE).toString();
for (let key in map) {
    theme = theme.replace(new RegExp(key + ' = .+'), key + ' = ' + colors[map[key]]);
}

writeFileSync(THEME_FILE, theme);