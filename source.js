const { execSync } = require('child_process');
const { files } = require('./map.json');
const { existsSync, mkdirSync, rmSync } = require('fs');

if (existsSync('./files')) {
    rmSync('./files', { recursive: true });
}

mkdirSync('./files');
for (e of Object.entries(files)) {
    let [name, location] = e;

    try {
        const path = `./files/${name}`;
        mkdirSync(path);
        execSync(`cp -rT ${location} ${path}`);

        console.log(`Sourced ${name}! (${location} -> ${path})`);
    } catch (e) {
        console.error(`Failed to source ${name}! (${location})`);
    }
}