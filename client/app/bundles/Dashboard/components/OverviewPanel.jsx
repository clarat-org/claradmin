import React, { PropTypes, Component } from 'react'
import { Form, InputSet } from 'rform'
import UpdateCurrentTeam from '../forms/UpdateCurrentTeam'
import AssignmentsContainer from '../containers/AssignmentsContainer'
import ControlledTabView from '../../ControlledTabView/containers/ControlledTabView'

export default class OverviewPanel extends Component {
  render() {
    const {
      user, selectableTeams, seedData, handleResponse
    } = this.props

    return (
      <div>
        <Form ajax
          action={`/api/v1/users/${user.id}`}
          method='PATCH'
          formObjectClass={UpdateCurrentTeam}
          seedData={seedData}
          className='form-inline'
          ref={element => this._form = element}
          handleResponse={handleResponse}
        >
          <InputSet submitOnChange
            attribute='current_team_id' type='select'
            options={selectableTeams}
            label='Ich arbeite gerade für das Team'
            className='form-group' inputClassName='form-control input-sm'
          />
        </Form>

        <ControlledTabView
          identifier="assignments" startIndex={1} // <== TODO: make it work!
          tabNames={['Meine Aufgaben', 'Team Aufgaben',
                     'Von mir abgeschickte Aufgaben', 'Abgeschlossene Aufgaben'
          ]}
        >
          <AssignmentsContainer scope={'receiver'} item_id={user.id} />
          <AssignmentsContainer
            scope={'receiver_team'} item_id={user.current_team_id}
          />
          <AssignmentsContainer scope={'creator_open'} item_id={user.id} />
          <AssignmentsContainer scope={'receiver_closed'} item_id={user.id} />
        </ControlledTabView>
      </div>
    )
  }
}
