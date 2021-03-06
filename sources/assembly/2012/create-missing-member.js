const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label,gender,party) => {
  qualifier = {
    P2937: meta.term.id,
  }
  if(party)  qualifier['P4100'] = party

  mem = {
    value: meta.position,
    qualifiers: qualifier,
    references: {
      P854: meta.source,
      P813: new Date().toISOString().split('T')[0],
      P1810: label,
    }
  }

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }
  if(gender == 'male')   claims['P21'] = 'Q6581097';
  if(gender == 'female') claims['P21'] = 'Q6581072';

  return {
    type: 'item',
    labels: { en: label, fr: label },
    descriptions: { en: 'politician in DRC', fr: 'personnalit√© politique congolais' },
    claims: claims,
  }
}
