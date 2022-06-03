module.exports = (label) => {
  return {
    type: 'item',
    labels: {
      en: label,
      fr: label,
    },
    descriptions: {
      en: 'politician in ${meta.jurisdiction.name}',
    },
    claims: {
      P31: { value: 'Q5' }, // human
      P106: { value: 'Q82955' }, // politician
    }
  }
}
