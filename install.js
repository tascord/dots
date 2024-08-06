const { mkdirSync } = require('fs');
const { files, post_install } = require('./map.json');
const { spawnSync } = require('child_process');

for (e of Object.entries(files)) {
    let [name, location] = e;

    try {
        const path = `./files/${name}`;
        mkdirSync(location).catch(() => { });
        spawnSync('cp', ['-rT', path, location]);

        console.log(`Installed ${name}! (${path} -> ${location})`);
    } catch (e) {
        console.error(`Failed to install ${name}! (${location})`);
    }
}

for (c of post_install) {
    try {
        spawnSync(c, { shell: true });
    } catch (e) {
        console.error(`Failed to run post-install command: ${c}`);
    }
}