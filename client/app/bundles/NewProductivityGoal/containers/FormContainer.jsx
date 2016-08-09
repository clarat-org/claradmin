import { connect } from 'react-redux'
import changeFormData from '../actions/changeFormData'
import Form from '../components/Form'

const mapStateToProps = (state, ownProps) => {
  const current_target_model = state.form.target_model || state.target_models[0]
  const current_target_field_name =
    state.form.target_field_name ||
      state.target_field_names[current_target_model][0]

  const translations = {
    Offer: 'Offers',
    Organization: 'Organizations',
    SplitBase: 'SplitBases',
    aasm_state: 'Status',
    logic_version: 'Version',
    'id?': 'Existenz',
    true: 'vorhanden'
  }

  return {
    teams: Object.values(state.teams),
    target_models: state.target_models,
    target_field_names: state.target_field_names[current_target_model],
    target_field_values:
      state.target_field_values[current_target_model][current_target_field_name],
    starts_at: state.form.starts_at,
    ends_at: state.form.ends_at,
    target_count: state.form.target_count,
    t: (translation_key) => translations[translation_key] || translation_key,
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onInputChange: (e) => {
    dispatch(changeFormData(e.target.dataset.field, e.target.value))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Form)
