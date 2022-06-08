const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label,position) => {
  mem = {
    value: position,
    qualifiers: { P580: '2019-04-10' },
    references: {
      P4656: meta.source,
      P813:  new Date().toISOString().split('T')[0],
      P1810: label,
    }
  }

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }

  return {
    type: 'item',
    labels: { en: label, fr: label },
    descriptions: { en: 'politician in DRC', fr: 'personnalité politique congolais' },
    claims: claims,
  }
}
