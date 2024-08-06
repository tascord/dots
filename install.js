const { existsSync } = require('fs');
const { files, post_install } = require('./map.json');
const { spawnSync } = require('child_process');

for (e of Object.entries(files)) {
    let [name, location] = e;

    try {
        const path = `./files/${name}`;
        spawnSync(`mkdir -p ${location}`, { shell: true });
        spawnSync(`cp ${path}/* ${location}`, { shell: true });
        console.log(`Installed ${name}! (${path} -> ${location})`);
    } catch (e) {
        console.error(`Failed to install ${name}! (${location})`);
        console.log(e);
    }
}

for (c of post_install) {
    try {
        spawnSync(c, { shell: true });
    } catch (e) {
        console.error(`Failed to run post-install command: ${c}`);
    }
}
