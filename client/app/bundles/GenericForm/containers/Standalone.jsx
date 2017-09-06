import { connect } from 'react-redux'
import parseLocation from '../lib/parseLocation'
import Standalone from '../components/Standalone'

const mapStateToProps = (state, ownProps) => {
  const [ model, idOrNew, edit ] = parseLocation(ownProps)
  const editId = edit ? idOrNew : null
  const heading = headingFor(model, editId)

  return {
    heading,
    model,
    editId,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

function headingFor(model, id) {
  let heading
  switch(model) {
  case 'user-teams':
    heading = 'Team'
    break
  case 'divisions':
    heading = 'Division'
    break
  case 'organizations':
    heading = 'Organisation'
    break
  case 'locations':
    heading = 'Standort'
    break
  case 'cities':
    heading = 'Stadt'
    break
  case 'openings':
    heading = 'Öffnungszeiten'
    break
  case 'definitions':
    heading = 'Definitions'
    break
  case 'tags':
    heading = 'Tags'
    break
  case 'federal-states':
    heading = 'Bundesland'
    break
  case 'contact-people':
    heading = 'Kontaktperson'
    break
  case 'emails':
    heading = 'Email'
    break
  case 'offers':
    heading = 'Angebote'
    break
  default:
    throw new Error(`Please provide a GenericForm heading for ${model}`)
  }
  return heading + ( id ? ` #${id} bearbeiten` : ' anlegen' )
}

export default connect(mapStateToProps, mapDispatchToProps)(Standalone)
