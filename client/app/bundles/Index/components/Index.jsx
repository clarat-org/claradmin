import React, { PropTypes, Component } from 'react'
import IndexHeader from '../containers/IndexHeader'
import IndexTable from '../containers/IndexTable'
import Pagination from '../containers/Pagination'
import isEqual from 'lodash/isEqual'

export default class Index extends Component {
  componentWillReceiveProps(nextProps) {
    if (isEqual(nextProps.query, this.props.query) == false ||
        nextProps.model != this.props.model
    ) {
      this.props.loadData(nextProps.query, nextProps.model)
    }
  }

  componentDidMount() {
    this.props.loadData()
  }

  render() {
    const {
      location, model, heading, query, lockedParams, optionalParams, identifier,
      uiKey, count
    } = this.props

    return (
      <div className='content Index table-header'>
        <p className="index-title">Gefundene Daten: {count}</p>
        <p className="page-title">{heading}</p>
        <IndexHeader model={model} params={query} lockedParams={lockedParams} />
        <IndexTable
          model={model} params={query} identifier={identifier} uiKey={uiKey}
        />
        <Pagination
          model={model} params={query} identifier={identifier} uiKey={uiKey}
        />
      </div>
    )
  }
}
