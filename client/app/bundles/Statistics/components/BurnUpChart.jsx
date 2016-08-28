import React, { PropTypes } from 'react'
import ReactFauxDOM from 'react-faux-dom'
import d3 from 'd3'
import merge from 'lodash/merge'
import cloneDeep from 'lodash/cloneDeep'

export default class BurnUpChart extends React.Component {
  // static propTypes = {
  //   data: PropTypes.arrayOf(
  //     PropTypes.shape({
  //       x: PropTypes.string.isRequired,
  //       y: PropTypes.number.isRequired,
  //       id: PropTypes.number.isRequired,
  //       topic: PropTypes.string.isRequired,
  //     })
  //   ).isRequired
  // }

  render() {
    const data = cloneDeep(this.props.data)

    const actualData = data.actual
    const idealData = data.ideal
    const projectionData = data.projection
    const scopeData = data.scope

		// Parse the date, normalize Y
    const parseDate = d3.time.format('%Y-%m-%d').parse
    for (let dataSegment of Object.keys(data)) {
      data[dataSegment].forEach(function (d) {
        d.x = parseDate(d.x)
        d.y = +d.y
      })
    }

    // Combine data for min/max evaluation
    const allData = merge([], actualData, projectionData, scopeData, idealData)

		// Set the dimensions of the graph
    const margin = {top: 20, right: 20, bottom: 30, left: 50}
    const width = 700 - margin.left - margin.right
    const height = 400 - margin.top - margin.bottom

		// Set the ranges
    const x = d3.time.scale()
      .range([0, width])

    const y = d3.scale.linear()
      .range([height, 0])

		// Define the axes
    const xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

    const yAxis = d3.svg.axis()
      .scale(y)
      .orient('left')

		// Create in-memory DOM to construct the graph in
    const node = ReactFauxDOM.createElement('svg')

		// Add the SVG canvas
    const svg = d3.select(node)
				.attr('width', width + margin.left + margin.right)
				.attr('height', height + margin.top + margin.bottom)
      .append('g')
				.attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

		// Scale the range of the data
    const xDomain = x.domain(d3.extent(allData, function (d) { return d.x }))
    const yDomain = y.domain([0, d3.max(scopeData, function (d) { return d.y })])

		// Add the axes
    svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + height + ')')
      .call(xAxis)

    svg.append('g')
				.attr('class', 'y axis')
				.call(yAxis)
      .append('text')
				.attr('transform', 'rotate(-90)')
				.attr('y', 6)
				.attr('dy', '.71em')
				.style('text-anchor', 'end')
				.text('Anzahl')

    // Add orientation line for the deadline
    const actualDeadline = svg.append('g')
      .attr('class', 'deadline-group')
    actualDeadline.append('line')
      .attr('x1', x(idealData[1].x))
      .attr('y1', y(0))
      .attr('x2', x(idealData[1].x))
      .attr('y2', y(d3.max(allData, (d) => d.y)))
      .attr('class', 'line deadline')

    actualDeadline.append('text')
				.attr('x', x(idealData[1].x) - 42)
				.attr('y', height - 9)
				.attr('dy', '.71em')
      .text('Deadline')

		// Add ideal line
    const idealLine = d3.svg.line()
      .x(function(d) { return x(d.x) })
      .y(function(d) { return y(d.y) })

    svg.append('path')
      .datum(idealData)
      .attr('class', 'line ideal')
      .attr('d', idealLine)

		// Add actual line
    const actualLine = d3.svg.line()
      .x(function(d) { return x(d.x) })
      .y(function(d) { return y(d.y) })

    svg.append('path')
      .datum(actualData)
      .attr('class', 'line actual')
      .attr('d', actualLine)

		// Add scope line
    const scopeLine = d3.svg.line()
      .x(function(d) { return x(d.x) })
      .y(function(d) { return y(d.y) })

    svg.append('path')
      .datum(scopeData)
      .attr('class', 'line scope')
      .attr('d', scopeLine)

		// Add projection line
    const projectionLine = d3.svg.line()
      .x(function(d) { return x(d.x) })
      .y(function(d) { return y(d.y) })

    svg.append('path')
      .datum(projectionData)
      .attr('class', 'line projection')
      .attr('d', projectionLine)

    return node.toReact()
  }
}
