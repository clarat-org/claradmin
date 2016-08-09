import React, { PropTypes } from 'react'

export default class Form extends React.Component {
  render() {
    const {
      teams, target_models, target_field_names, target_field_values, t,
      onInputChange, starts_at, ends_at, target_count
    } = this.props

    return (
      <form action="/productivity_goals/" method="POST">
        für
        <select
          name="productivity_goal[user_team_id]"
          data-field="user_team_id"
          onChange={onInputChange}
        >
          {teams.map( (team) =>
            <option key={team.id} value={team.id}>{team.name}</option>
          )}
        </select>
        <br />
        Titel
        <input
          type="text" name="productivity_goal[title]" placeholder="Titel" />
        <br />
        vom
        <input
          type="date" name="productivity_goal[starts_at]"
          data-field="starts_at"
          value={starts_at}
          onChange={onInputChange}
        />
        <br />
        bis zum
        <input
          type="date" name="productivity_goal[ends_at]"
          data-field="ends_at"
          value={ends_at}
          onChange={onInputChange}
        />
        <br />
        sollen
        <input
          type="number" name="productivity_goal[target_count]"
          placeholder="Anzahl"
          data-field="target_count"
          value={target_count}
          onChange={onInputChange}
        />
        <select
          name="productivity_goal[target_model]"
          data-field="target_model"
          onChange={onInputChange}
        >
          {target_models.map( (target_model) =>
            <option key={target_model} value={target_model}>
              {t(target_model)}
            </option>
          )}
        </select>
        <br />
        auf
        <select
          name="productivity_goal[target_field_name]"
          data-field="target_field_name"
          onChange={onInputChange}
        >
          {target_field_names.map( (name) =>
            <option key={name} value={name}>{t(name)}</option>
          )}
        </select>
        <select
          name="productivity_goal[target_field_value]"
          data-field="target_field_value"
          onChange={onInputChange}
        >
          {target_field_values.map( (value) =>
            <option key={value} value={value}>{t(value)}</option>
          )}
        </select>
        gebracht werden.

        <br />
        <button type='submit'>Abschicken</button>
      </form>
    )
  }
}
