const paddedNumber = (number, numberOfChars = 2) => {
    return `00${number}`.slice(-numberOfChars)
}

const formattedDate = (date = new Date()) => {
    const dateString = `${date.getFullYear()}${paddedNumber(date.getMonth())}${paddedNumber(date.getDate())}`
    const timeString = `${date.getHours()}${paddedNumber(date.getMinutes())}${paddedNumber(date.getSeconds())}_${paddedNumber(date.getMilliseconds(), 3)}`;
    const result = `${dateString}${timeString}`;
    
    return result;
}

function generateUniqueName(suffix = '') {
    return `${formattedDate()}_${suffix}`;
}

module.exports = generateUniqueName;
