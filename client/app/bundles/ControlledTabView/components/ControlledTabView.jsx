import React, { PropTypes, Component } from 'react'
import { Tabs, Tab } from 'react-bootstrap'
import PersonalStatisticCharts from '../../Dashboard/containers/PersonalStatisticCharts'
import TeamStatisticCharts from '../../Dashboard/containers/TeamStatisticCharts'

export default class ControlledTabView extends Component {

  render() {
    return (
      <Tabs
        activeKey={this.props.selectedTab} onSelect={this.props.handleSelect}
        id={this.props.uniqIdentifier}
      >
       {this.props.children.map( (child, index) => {
         return(
           <Tab eventKey={index} title={this.props.tabNames[index]} key={this.props.uniqIdentifier + index}>
             {index == this.props.selectedTab ? child : null}
           </Tab>
         )
       })}
      </Tabs>
    )
  }
}
