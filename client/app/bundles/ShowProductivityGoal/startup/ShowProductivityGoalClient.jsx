import React from 'react'
import { Provider } from 'react-redux'

import getStore from '../store/store'
import Root from '../components/Root'

// See documentation for https://github.com/rackt/react-redux.
// This is how you get props from the Rails view into the redux store.
// This code here binds your smart component to the redux store.
export default (props) => {
  const store = getStore(props)

  return (
    <Provider store={store}>
      <Root />
    </Provider>
  )
}
