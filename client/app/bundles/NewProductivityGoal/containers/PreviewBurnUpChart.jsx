import { connect } from 'react-redux'
import BurnUpChart from '../../Statistics/components/BurnUpChart'

const mapStateToProps = (state, ownProps) => {
  const data = {
    actual: [],

    ideal: [{
      x: state.form.starts_at, y: 0,
    }, {
      x: state.form.ends_at, y: state.form.target_count,
    }],

    projection: [],

    scope: [{
      x: state.form.starts_at, y: state.form.target_count,
    }, {
      x: state.form.ends_at, y: state.form.target_count,
    }],
  }
  console.log(data)

  return {
    data
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChart)
