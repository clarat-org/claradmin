import { connect } from 'react-redux'
import omit from 'lodash/omit'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import filter from 'lodash/filter'
import { encode } from 'querystring'
import { browserHistory } from 'react-router'
import settings from '../../../lib/settings'
import setUiAction from '../../../Backend/actions/setUi'
import { analyzeFields } from '../../../lib/settingUtils'
import IndexHeaderFilter from '../components/IndexHeaderFilter'


const mapStateToProps = (state, ownProps) => {
  const model = ownProps.model
  const filterName =
    ownProps.filter[0].split('][first]').join('').split('][second]').join('').
      substring(8, ownProps.filter[0].length -1)
  const filterType = setFilterType(filterName)
  const filterValue = getValue(ownProps.filter[1], 0)
  console.log(filterValue)
  const secondFilterValue = getValue(ownProps.filter[1], 1)
  const nilChecked = ownProps.filter[1] == 'nil'
  // only show filters that are not locked (currently InlineIndex only)
  const fields =
    analyzeFields(settings.index[model].fields, model).filter(value =>
      !ownProps.lockedParams ||
        !ownProps.lockedParams.hasOwnProperty(`filters[${value.field}]`)
    )
  const operatorName = ownProps.params[`operators[${filterName}]`] || '='
  const range =
    (operatorName == "..." && filterType != 'text') ? 'visible' : 'hidden'
  const operators = settings.OPERATORS.filter(operator =>
    operator != '...' || filterType != 'text'
  ).map(operator => {
    return {
      value: operator,
      displayName: textForOperator(operator)
    }
  })

  return {
    filterName,
    nilChecked,
    filterType,
    fields,
    operators,
    operatorName,
    range,
    filterValue,
    secondFilterValue
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onTrashClick(event) {
    let filterId = ownProps.filter[0].split('[')
    const params = omit(clone(ownProps.params),
                  [ownProps.filter[0], 'operators[' + filterId[1]])
    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
  },

  onFilterNameChange(event) {
    let params = omit(clone(ownProps.params), ownProps.filter[0])
    let newParam = {}
    newParam[`filters[${event.target.value}]`] = ''
    params = merge(params, newParam)

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
  },

  onFilterOperatorChange(event) {
    let params = clone(ownProps.params)
    let newParam = {}
    let operator = event.target.value
    let filterName =
        ownProps.filter[0].substring(8, ownProps.filter[0].length - 1)
    newParam[`operators[${filterName}]`] = operator
    params = merge(params, newParam)

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
  },

  onCheckboxChange(event) {
    let params = clone(ownProps.params)
    if (event.target.checked) {
      params[ownProps.filter[0]] = 'nil'
    } else {
      params[ownProps.filter[0]] = ''
    }

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
  },

  onFilterValueChange(event) {
    let params = clone(ownProps.params)

    if(params[ownProps.filter[0]]['second'] != undefined) {
      if(params[ownProps.filter[0]]['second'].valueOf() < event.target.value) {
        alert('Wert muss unter dem Zweitwert liegen');
      } else {
        params[ownProps.filter[0]]['first'] = event.target.value
      }
    } else {
      params[ownProps.filter[0]] = { 'first': event.target.value }
    }

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
  },

  onSecondFilterValueChange(event) {
    let params = clone(ownProps.params)

    if(params[ownProps.filter[0]]['first'] != undefined) {
      if (params[ownProps.filter[0]]['first'].valueOf() > event.target.value) {
        alert('Wert muss über dem Anfangswert liegen');
      } else {
        params[ownProps.filter[0]]['second'] = event.target.value
      }
    } else {
      alert('Bitte gib einen Anfangswert ein');
    }

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
  },
})

function setFilterType (filterName) {
  let splitArray = filterName.split('-')
  switch(splitArray[splitArray.length - 1]) {
    case 'at':
      return 'date'
    case 'id':
    case 'count':
      return 'number'
    default:
      return 'text'
  }
}

function getValue(props, index) {
  if(props == Object(props)) {
    return Object.values(props)[index]
  } else {
    if(props == 'nil') {
      return ''
    } else {
      return [props]
    }
  }
}


function textForOperator(operator) {
  switch(operator) {
    case '<':
      return 'kleiner als'
    case '>':
      return 'größer als'
    case '=':
      return 'genau gleich'
    case '!=':
      return 'nicht gleich'
    case '...':
      return 'zwischen'
    default:
      return '???'
  }
}

function searchString(model, params) {
  if(window.location.href.includes(model)) {
    return `${model}?${jQuery.param(params)}`
  } else {
    return `?${jQuery.param(params)}`
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeaderFilter)
