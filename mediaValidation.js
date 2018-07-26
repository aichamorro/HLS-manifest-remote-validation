const childProcess = require('child_process');

const mediaValidatorPath = '/usr/local/bin/mediastreamvalidator';
const manifestsDir = `${__dirname}/manifests`;
const manifestLocation = (filename) => `${manifestsDir}/${filename}`;

const mediaStreamValidationCommand = (filename) => `${mediaValidatorPath} ${manifestLocation(filename)}`;
function mediaValidation(manifestName, callback) {
    childProcess.exec(mediaStreamValidationCommand(manifestName), (error, stdout, stderr) => {
        if (error) {
            console.log(error.message);

            return;
        }

        callback(`${stdout}${stderr}`);
    });
}

module.exports = mediaValidation;