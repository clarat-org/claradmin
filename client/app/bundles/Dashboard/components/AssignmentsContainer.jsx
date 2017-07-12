import React, { PropTypes, Component } from 'react'
import Index from '../../Index/containers/Index'
import ControlledSelectView from '../../ControlledSelectView/containers/ControlledSelectView'

export default class AssignmentsContainer extends Component {

  componentDidMount() {
    this.props.setParams()
  }

  render() {
    const {
      heading, model, lockedParams, optionalParams, scope, params
    } = this.props
    
    return (
      <div className="panel-group">
        {this.teamSelectOrNull(this.props.selectableData, params)}
        <b>{heading}</b>
        <Index
          model={model} identifierAddition={scope} params={params}
          lockedParams={lockedParams} optionalParams={optionalParams}
        />
      </div>
    )
  }

  teamSelectOrNull(team_data, params) {
    if (team_data && team_data.length != 0) {
      return (
        <div className="select-set">
          <span className="select-set__label">Zeige Zuweisungen für:</span>
          <ControlledSelectView identifier={'team-assignments'} params={params}>
            {team_data}
          </ControlledSelectView>
        </div>
      )
    } else { return null }
  }
}
