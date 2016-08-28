import React, { PropTypes, Component } from 'react'
import { Navbar, Nav, NavItem } from 'react-bootstrap'
import IndexHeaderFilter from '../containers/IndexHeaderFilter'

export default class IndexHeader extends Component {
  render() {
    const {
      onQueryChange, query, onPlusClick, filters, model, params,
      plusButtonDisabled
    } = this.props

    return (
      <Navbar inverse fluid>
        <Nav>
          <NavItem href='/offer_translations' active>
            Liste
          </NavItem>
          <NavItem href='/exports/offer_translation/new'>
            Export
          </NavItem>
        </Nav>
        <Navbar.Form pullRight inline>
          <div className='input-group'>
            <input
              className='form-control' name='query' type='search'
              placeholder='Search…'
              onChange={onQueryChange}
              value={query}
            />
            <span className='input-group-btn'>
              <button
                className='btn' onClick={onPlusClick}
                disabled={plusButtonDisabled}
              >
                <span className='fui-plus' />
              </button>
            </span>
          </div>
          {filters.map(filter => {
            return(
              <IndexHeaderFilter
                model={model} params={params} key={filter[0]} filter={filter}
              />
            )
          })}
        </Navbar.Form>
      </Navbar>
    )
  }
}
