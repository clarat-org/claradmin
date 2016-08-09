import ReactOnRails from 'react-on-rails'
import StatisticsApp from '../../bundles/Statistics/startup/StatisticsAppClient'
import NewProductivityGoal from '../../bundles/NewProductivityGoal/startup/NewProductivityGoalClient'
import ShowProductivityGoal from '../../bundles/ShowProductivityGoal/startup/ShowProductivityGoalClient'
import TimeAllocationTable from '../../bundles/TimeAllocationTable/startup/TimeAllocationTableClient'

// This is how react_on_rails can see the StatisticsApp in the browser.
ReactOnRails.register({
  StatisticsApp, NewProductivityGoal, ShowProductivityGoal, TimeAllocationTable
})
