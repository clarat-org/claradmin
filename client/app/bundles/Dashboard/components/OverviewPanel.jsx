import React, { PropTypes, Component } from 'react'
import ControlledTabView from '../../ControlledTabView/containers/ControlledTabView'
import AssignmentsContainer from '../containers/AssignmentsContainer'

export default class OverviewPanel extends Component {
  render() {
    return (
      <ControlledTabView
        identifier="assignments" startIndex={1}
        tabNames={['Meine Aufgaben', 'Team Aufgaben',
                   'Von mir abgeschickte Aufgaben', 'Abgeschlossene Aufgaben'
        ]}
      >
        <AssignmentsContainer scope={'receiver'} />
        <AssignmentsContainer scope={'receiver_team'} />
        <AssignmentsContainer scope={'creator_open'} />
        <AssignmentsContainer scope={'receiver_closed'} />
      </ControlledTabView>
    )
  }
}
