import React, { PropTypes, Component } from 'react'
import { Link } from 'react-router'
import PaginationCell from '../containers/PaginationCell'

export default class Pagination extends Component {
  render() {
    const {
      pages, previousPageHref, nextPageHref, model, params
    } = this.props

    return (
      <div className='pagination'>
        <ul>
          <li className='previous'>
            <Link className='fui-arrow-left' to={previousPageHref} />
          </li>
          {pages.map(page => {
            return(
              <PaginationCell
                key={page} page={page} model={model} params={params}
              />
            )
          })}
          <li className='next'>
            <Link className='fui-arrow-right' to={nextPageHref} />
          </li>
        </ul>
      </div>
    )
  }
}
