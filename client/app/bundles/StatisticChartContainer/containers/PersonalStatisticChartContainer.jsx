import { connect } from 'react-redux'
import moment from 'moment'
import valuesIn from 'lodash/valuesIn'
import { getTimePointsBetween } from '../../../lib/timeUtils'
import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import PersonalStatisticChartContainer from '../components/PersonalStatisticChartContainer'

const mapStateToProps = (state, ownProps) => {
  const chart = ownProps.statisticChart
  const relevantTransitions =
    collectRelevantData(state.entities, 'statistic_transitions', chart)
  const relevantGoals =
    collectRelevantData(state.entities, 'statistic_goals', chart)
  const relevantStatistics =
    collectRelevantData(state.entities, 'statistics', chart, relevantTransitions)

  const sortedGoals = relevantGoals.sort(
    (a, b) => +(a.starts_at > b.starts_at) || +(a.starts_at === b.starts_at)-1
  )
  const lastGoal = sortedGoals[sortedGoals.length - 1]

  const actualData = aggregateActualPoints(relevantStatistics, chart)
  const scopeData = aggregateScopePoints(sortedGoals, chart)

  const data = {
    actual: actualData,
    scope: scopeData,
    ideal: [{
      x: chart.starts_at, y: 0,
    }, {
      x: chart.ends_at, y: lastGoal.amount,
    }],
    //
    // projection: aggregateProjectionPoints(
    //   chart, lastActualPoint, allTimeAllocations, allUsers, allStatistics
    // ),
  }

  return {
    data,
    chartId: chart.id,
    lastGoalAmount: lastGoal.amount
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

function aggregateActualPoints(statistics, chart) {
  const start = moment(chart.starts_at)
  const end = moment()
  let points = []
  let runningTotal = 0

  for (let day of getTimePointsBetween(start, end)) {
    const statisticsForCurrentDay = statistics.filter((statistic) =>
      day.isSame(statistic.date)
    )

    for (let statistic of statisticsForCurrentDay) {
      runningTotal += statistic.count
    }

    points.push({ x: day.format('YYYY-MM-DD'), y: runningTotal })
  }

  return points
}

function aggregateScopePoints(goals, chart) {
  let points = []

  let previousGoal
  for (let goal of goals) {
    if (previousGoal) points.push({ x: goal.starts_at, y: previousGoal.amount })
    points.push({ x: goal.starts_at, y: goal.amount })
    previousGoal = goal
  }

  const lastPoint = points[points.length - 1]
  points.push({ x: chart.ends_at, y: lastPoint.y })

  return points
}

// function aggregateProjectionPoints(
//   chart, lastActualPoint, time_allocations, users, statistics
// ) {
//   const usersCurrentlyInTeam = users.filter(user =>
//     user.user_team_ids.includes(chart.user_team_id)
//   )
//   const expectedHourlyGoalReachCount = usersCurrentlyInTeam.map(user =>
//     averageWeeklyGoalsReachedForUser(user.id, statistics)
//   ).reduce((pv, cv) => { return pv + cv }, 0)
//
//   let projectionData = [lastActualPoint]
//   let lastCount = lastActualPoint.y
//   let week = moment().startOf('week')
//   let goalReachedInProjection = false
//   let iterationCounter = 0
//
//   while (!goalReachedInProjection) {
//     // prepare point from given data
//     let endOfWeek = week.day(5).format('YYYY-MM-DD') // next Friday
//     let hoursAvailableForTeamInWeek =
//       availableHoursForUsersInWeek(week, usersCurrentlyInTeam, time_allocations)
//     let expectedCountForWeek =
//       expectedHourlyGoalReachCount * hoursAvailableForTeamInWeek
//     let expectedEndOfWeekCount = lastCount + expectedCountForWeek
//
//     // limit point to chart max
//     if (expectedEndOfWeekCount >= chart.target_count) {
//       expectedEndOfWeekCount = chart.target_count
//       goalReachedInProjection = true
//     }
//
//     // commit point
//     projectionData.push({
//       x: endOfWeek, y: expectedEndOfWeekCount
//     })
//
//     // continue or abort iteration
//     lastCount = expectedEndOfWeekCount
//     week.add(1, 'week')
//     if (iterationCounter >= 20) {
//       break // Endless recursion protection
//     } else {
//       iterationCounter += 1
//     }
//   }
//
//   return projectionData
// }
//
// function averageWeeklyGoalsReachedForUser(user_id, statistics) {
//   const pastWeeklyUserStatistics = statistics.filter((statistic) =>
//     statistic.user_id == user_id && statistic.time_frame == 'weekly'
//   )
//
//   const allHourlyGoalsReached = pastWeeklyUserStatistics.reduce((cv, pv) => {
//     return cv + pv.count
//   }, 0)
//
//   return allHourlyGoalsReached / pastWeeklyUserStatistics.length
// }
//
// function availableHoursForUsersInWeek(
//   week, usersCurrentlyInTeam, time_allocations
// ) {
//   return usersCurrentlyInTeam.map(user => {
//     const [_e, _h, allocation] = getAllocationForWeekAndUser(
//       time_allocations, week.week(), week.year(), user.id
//     )
//     return allocation.desired_wa_hours
//   }).reduce((cv, pv) => { return cv + pv }, 0)
// }

function collectRelevantData(entities, type, ...additionalArgs) {
  const allEntities = valuesIn(entities[type])
  if (!allEntities) return []
  let filter
  switch(type) {
    case 'statistics': filter = filterStatistics; break;
    case 'statistic_transitions': filter = filterStatisticTransitions; break;
    case 'statistic_goals': filter = filterStatisticGoals; break;
  }

  return allEntities.filter(filter(...additionalArgs))
}

function filterStatistics(chart, transitions) {
  return function(stat) {
    const matchingTransitions = transitions.filter(transition => {
      return stat.model == transition.klass_name &&
        stat.field_name == transition.field_name &&
        stat.field_start_value == transition.start_value &&
        stat.field_end_value == transition.end_value
    })
    return(
      stat.time_frame == 'daily' &&
        stat.user_id == chart.user_id &&
        matchingTransitions.length
    )
  }
}

function filterStatisticTransitions(chart) {
  return function(transition) {
    return chart.statistic_transition_ids.includes(transition.id)
  }
}

function filterStatisticGoals(chart) {
  return function(goal) {
    return chart.statistic_goal_ids.includes(goal.id)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(PersonalStatisticChartContainer)