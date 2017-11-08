import { connect } from 'react-redux'
import uniq from 'lodash/uniq'
import { singularize } from '../../../lib/inflection'
import { denormalizeStateEntity } from '../../../lib/denormalizeUtils'
import changeViewing from '../actions/changeViewing'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import addFlashMessage from '../../../Backend/actions/addFlashMessage'
import { setUiLoaded } from '../../../Backend/actions/setUi'
import setupSubscription from '../../../Backend/actions/setupSubscription'
import removeSubscription from '../../../Backend/actions/removeSubscription'
import channelPerform from '../../../Backend/actions/channelPerform'
import ShowItems from '../../Show/containers/ShowItems'
import Delete from '../../Delete/containers/Delete'
import Duplicate from '../../Duplicate/containers/Duplicate'
import LoadingForm from '../../GenericForm/containers/LoadingForm'
import MemberAction from '../components/MemberAction'

const mapStateToProps = (state, ownProps) => {
  let [_, model, id, view] = ownProps.location.pathname.split('/')
  view = view || 'show'
  const heading = headingFor(model, id, view)

  const viewingUserIDs =
    state.cable.live.viewing[model] &&
    state.cable.live.viewing[model][id] &&
    state.cable.live.viewing[model][id][view] || []

  const viewingUsers = uniq(viewingUserIDs).map(userID =>
    denormalizeStateEntity(state.entities, 'users', userID)
  ).map(user => {
    user.color = intToHSL(user.id)
    user.shorthand = user.name.split(' ').map(s => s[0]).join('')
    user.tabcount = viewingUserIDs.filter(e => e == user.id).length
    user.title = `${user.name} sieht diese Seite gerade an`
    if (user.tabcount > 1) user.title += ` (in ${user.tabcount} Tabs)`
    return user
  })

  return {
    model,
    id,
    view,
    heading,
    viewingUsers,
    ChildComponent: componentForView(view)
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { model, id, view } = stateProps
  const { dispatch } = dispatchProps

  return {
    ...stateProps, ...dispatchProps, ...ownProps,

    loadData(nextModel = model, nextID = id, nextView = view) {
      // load data of current model_instance
      dispatch(
        loadAjaxData(
          `${nextModel}/${nextID}`, '', nextModel, {
            onSuccess: () => {
              dispatch(setUiLoaded(true, 'GenericForm', nextModel, nextID)) //!
            },
            onError: () => {
              browserHistory.replace(`/${nextModel}`)
              dispatch(
                addFlashMessage('failure', 'Das Objekt gibt es nicht (mehr)!')
              )
            }
          }
        )
      )

      const singularModel = singularize(nextModel)

      // load field_set (all fields and associations of current model)
      dispatch(
        loadAjaxData(
          'field_set/' + singularModel, {}, 'field-set', {
            nextModel, transformer: (apiResponse, nextModel) => {
              let object = { 'field-sets': {} }
              object['field-sets'][nextModel] = apiResponse
              return object
            }
          }
        )
      )

      // load possible events for current model
      dispatch(
        loadAjaxData(
          `possible_events/${singularModel}/${nextID}`, {}, 'possible-events',
          {
            nextModel,
            transformer: (apiResponse, nextModel) => {
              let object = { 'possible-events': {} }
              object['possible-events'][nextModel] = {}
              object['possible-events'][nextModel][apiResponse.id] =
                apiResponse
              return object
            }
          }
        )
      )
    },

    // Subscribe to information about other people who are viewing
    // and potentially modifying the currently shown object
    setupViewingSubscription() {
      console.log('setting up', { model, id, view })
      dispatch(setupSubscription(
        { channel: 'ViewingChannel', model, id, view },
        {
          received(data) {
            console.log('received', data)
            dispatch(changeViewing(model, id, data.views))
          }
        }
      ))
    },

    // When the user changes between views, inform other subscribers
    changeView(nextProps) {
      console.log('changing')
      dispatch(channelPerform('ViewingChannel', 'change_view', {
        last: { model, id, view },
        next: { model: nextProps.model, id: nextProps.id, view: nextProps.view },
      }))
    },

    // Unsubscribe when leaving the member context
    removeViewingSubscription() {
      console.log('leaving', { model, id, view })
      dispatch(removeSubscription('ViewingChannel'))
    }
  }
}

function componentForView(view) {
  switch(view) {
    case 'show':
      return ShowItems
    case 'delete':
      return Delete
    case 'duplicate':
      return Duplicate
    case 'edit':
      return LoadingForm
    default:
      throw new Error(`No View "${view}" found.`)
  }
}


function headingFor(model, id, view) {
  let singularModelName = singularize(model)
  switch(view) {
  case 'edit':
    return `${singularModelName}#${id} bearbeiten`
  case 'delete':
    return  `${singularModelName}#${id} löschen`
  case 'duplicate':
    return  `${singularModelName}#${id} duplizieren`
  case 'new':
    return  `Neue ${singularModelName} anlegen`
  default:
    return `Details für ${singularModelName}#${id}`
  }
}

function intToHSL(int) {
  const shortened = Math.abs(Math.sin(int) * 100000) % 360
  return `hsl(${shortened},20%,57%)`
}

// // pastel variation
// function intToRGB(seed) {
//   const baseRed = 128
//   const baseGreen = 128
//   const baseBlue = 128
//
//   const rand_1 = Math.abs((Math.sin(seed++) * 10000)) % 256
//   const rand_2 = Math.abs((Math.sin(seed++) * 10000)) % 256
//   const rand_3 = Math.abs((Math.sin(seed++) * 10000)) % 256
//
//   const red = Math.round((rand_1 + baseRed) / 2)
//   const green = Math.round((rand_2 + baseGreen) / 2)
//   const blue = Math.round((rand_3 + baseBlue) / 2)
//
//   return `rgb(${red},${green},${blue})`
// }

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  MemberAction
)
