import React, { PropTypes, Component } from 'react'
import ShowItems from '../containers/ShowItems'

export default class Export extends Component {
  componentWillReceiveProps(nextProps) {
    if (nextProps.location.query != this.props.location.query) {
      // this.props.loadData(nextProps.location.query, nextProps.model)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      location, model, model_instance
    } = this.props

    return (
      <div className='content Show'>
        <h2>{`Show: ${model}`}</h2>
        <hr />
        <ShowItems model={model} model_instance={model_instance} params={location.query} />
      </div>
    )
  }
}
