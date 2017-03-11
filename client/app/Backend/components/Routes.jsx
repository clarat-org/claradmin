import React, { PropTypes } from 'react'
import { Router, Route, browserHistory, IndexRoute } from 'react-router'

import Layout from './Layout'
import Index from '../../bundles/Index/containers/Index'
import Show from '../../bundles/Show/containers/Show'
import GenericForm from '../../bundles/GenericForm/containers/Standalone'
import Export from '../../bundles/Export/containers/Export'
import DashboardContainer
  from '../../bundles/Dashboard/containers/DashboardContainer'
import ShowStatisticChart
  from '../../bundles/ShowStatisticChart/containers/ShowStatisticChart'
import NewStatisticChart
  from '../../bundles/NewStatisticChart/components/NewStatisticChart'
import NewAssignment
  from '../../bundles/NewAssignment/containers/NewAssignmentForm'
// import NewOrganization
//   from '../../bundles/NewOrganization/containers/NewOrganizationForm'
import TimeAllocationTableContainer
  from '../../bundles/TimeAllocationTable/containers/TimeAllocationTableContainer'
import StatisticsLayout from '../../bundles/Statistics/components/StatisticsLayout'
import Overview from '../../bundles/Statistics/components/Overview'
import OfferOverviewPage from '../../bundles/Statistics/components/OfferOverviewPage'
import OrgaOverviewPage from '../../bundles/Statistics/components/OrgaOverviewPage'
import RatioOverviewPage from '../../bundles/Statistics/containers/RatioOverviewPage'
import OfferCreatedPage from '../../bundles/Statistics/components/OfferCreatedPage'
import OfferApprovedPage from '../../bundles/Statistics/components/OfferApprovedPage'
import OrgaCreatedPage from '../../bundles/Statistics/components/OrgaCreatedPage'
import OrgaApprovedPage from '../../bundles/Statistics/components/OrgaApprovedPage'
import StatisticChartPage from '../../bundles/Statistics/components/StatisticChartPage'
import EditTranslation from
  '../../bundles/EditTranslation/containers/EditTranslation'

export default class Routes extends React.Component {
  render() {
    return (
      <Router history={browserHistory}>
        <Route path='/' component={Layout}>
          <IndexRoute component={DashboardContainer}/>

          <Route path='organizations'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='divisions'>
            <IndexRoute component={Index}/>
            <Route path='new' component={GenericForm} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='offers'>
            <IndexRoute component={Index}/>
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='statistic_charts'>
            <IndexRoute component={Index}/>
            <Route path='new' component={NewStatisticChart} />
            <Route path=':id' component={ShowStatisticChart} />
          </Route>

          <Route path='time_allocations'>
            <IndexRoute component={TimeAllocationTableContainer}/>
            <Route
              path=':year/:week_number'
              component={TimeAllocationTableContainer}
            />
          </Route>

          <Route path='statistics' component={StatisticsLayout}>
            <IndexRoute component={Overview}/>
            <Route path='offer_overview' component={OfferOverviewPage} />
            <Route path='organization_overview' component={OrgaOverviewPage} />
            <Route path='ratio_overview' component={RatioOverviewPage} />
            {/*
            <Route path='offer_created' component={OfferCreatedPage} />
            <Route path='offer_approved' component={OfferApprovedPage} />
            <Route path='organization_created' component={OrgaCreatedPage} />
            <Route path='organization_approved' component={OrgaApprovedPage} />
            */}
          </Route>

          <Route path='offer_translations'>
            <IndexRoute component={Index} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={EditTranslation} model='offer' />
          </Route>

          <Route path='organization_translations'>
            <IndexRoute component={Index} />
            <Route path='export' component={Export} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={EditTranslation} model='organization' />
          </Route>

          <Route path='user_teams'>
            <IndexRoute component={Index} />
            <Route path='new' component={GenericForm} />
            <Route path=':id' component={Show} />
            <Route path=':id/edit' component={GenericForm} />
          </Route>

          <Route path='users'>
            <IndexRoute component={Index} />
            <Route path=':id' component={Show} />
          </Route>

          <Route path='assignments'>
            <IndexRoute component={Index} />
            <Route path='new' component={NewAssignment} />
            <Route path=':id' component={Show} />
          </Route>
        </Route>
      </Router>
    )
  }
}
