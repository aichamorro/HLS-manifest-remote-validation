const express = require('express');
const fileUploader = require('express-fileupload');
const fs = require('fs');
const generateUniqueName = require('./generateUniqueName');
const mediaValidation = require('./mediaValidation');

const app = express();
app.use(fileUploader());

app.post('/manifest', (req, res) => {
    const destination = generateUniqueName('manifest.m3u8');
    req.files.manifest.mv(`./manifests/${destination}`);

    mediaValidation(destination, result => {
        console.log(`\n------------- ${new Date()} -------------\n`);
        console.log(result);
        fs.writeFileSync(`./manifests/${destination}_validation.txt`, result), 'utf8';
    });

    res.send('Ok');
})

app.listen(3000, () => console.log('Server listening on port 3000'));
