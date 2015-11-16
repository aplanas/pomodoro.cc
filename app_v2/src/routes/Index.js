import Pomodoro from '../components/Pomodoro'
import TodoList from '../components/TodoList'
import SoundSettings from '../components/SoundSettings'
import Profile from '../components/Profile'
import * as actions from '../actions'
import React, {Component, PropTypes} from 'react'
import {bindActionCreators} from 'redux'
import {connect} from 'react-redux'

class Index extends Component {
  render () {
    const {timer, todos, settings, user, actions} = this.props
    return  <div>
              <Pomodoro timer={timer} actions={actions}/>
              <TodoList todos={todos} actions={actions}/>
              <SoundSettings settings={settings} actions={actions}/>
              <Profile user={user} actions={actions}/>
            </div>
  }
}

Index.propTypes = {
  actions: PropTypes.object.isRequired,
  todos: PropTypes.array.isRequired,
  settings: PropTypes.object.isRequired,
  timer: PropTypes.string.isRequired,
  user: PropTypes.string.isRequired,
}

function mapStateToProps(state){
  return {
    todos: state.todos,
    settings: state.settings,
    timer: state.timer,
    user: state.user,
  }
}

function mapDispatchToProps(dispatch){
  return {
    actions: bindActionCreators(actions, dispatch)
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Index)
