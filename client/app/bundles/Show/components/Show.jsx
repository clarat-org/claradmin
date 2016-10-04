import React, { PropTypes, Component } from 'react'
import ShowItems from '../containers/ShowItems'

export default class Export extends Component {
  componentWillReceiveProps(nextProps) {
    // console.log('componentWillReceiveProps!')
    // console.log(this.props)
    // console.log(nextProps)
    if (nextProps.model != this.props.model || nextProps.id != this.props.id) {
      // console.log('CALL!')
      this.props.loadData(nextProps)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      location, id, model, heading
    } = this.props
    return (
      <div className='content Show'>
        <h3>{heading}</h3>
        <hr />
        <ShowItems model={model} id={id} params={location.query} />
      </div>
    )
  }
}
