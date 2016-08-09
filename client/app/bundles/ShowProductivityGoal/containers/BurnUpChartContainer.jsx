import { connect } from 'react-redux'
import BurnUpChart from '../../Statistics/components/BurnUpChart'
import moment from 'moment'

const mapStateToProps = (state, ownProps) => {
  const goal = state.productivity_goal

  const data = {
    actual: aggregateActualPoints(state.statistics, goal),

    ideal: [{
      x: goal.starts_at, y: 0,
    }, {
      x: goal.ends_at, y: goal.target_count,
    }],

    projection: [],

    scope: [{
      x: goal.starts_at, y: goal.target_count,
    }, {
      x: goal.ends_at, y: goal.target_count,
    }],
  }

  return {
    data,
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

function aggregateActualPoints(statistics, goal) {
  const start = moment(goal.starts_at)
  const end = moment()
  let points = []
  let runningTotal = 0

  for (let day of getDaysBetween(start, end)) {
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

function getDaysBetween(start, end) {
	let now = start.startOf('day')
  let dates = []

  while (now.isBefore(end)) {
    dates.push(now.clone())
    now.add(1, 'day')
  }
  return dates
}

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChart)
