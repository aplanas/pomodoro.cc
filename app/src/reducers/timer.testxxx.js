import timer from './timer'
import { tickTimer } from '../actions'

const dummyAction = { type: 'DUMMY', payload: {} }

describe('timer reducer', () => {
  it('default state is "00:00"', () => {
    expect(
      timer(undefined, dummyAction)
    ).toEqual('00:00')
  })

  it('ticks timer', () => {
    expect(
      timer('25:00', tickTimer(25 * 60 - 1))
    ).toEqual('24:59')
  })
})
