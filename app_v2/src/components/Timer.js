import React, {Component} from 'react'
export default class Timer extends Component {
  render () {
    const {timer, actions} = this.props
    return  <div>
              <pre>{timer}</pre>
              <pre onClick={() => actions.startTimer(25*60)}>25min</pre>
              <pre onClick={() => actions.startTimer(5*60)}>5min</pre>
              <pre onClick={() => actions.startTimer(15*60)}>15min</pre>
              <pre onClick={() => actions.stopTimer()}>stopTimer</pre>
            </div>
  }
}
