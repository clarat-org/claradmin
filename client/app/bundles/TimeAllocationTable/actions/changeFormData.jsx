export function changeYear(year) {
  return { type: 'CHANGE_YEAR', year }
}

export function changeWeekNumber(week_number) {
  return { type: 'CHANGE_WEEK_NUMBER', week_number }
}

export function changeFormData(name, value) {
  return { type: 'CHANGE_FORM_DATA', name, value }
}
