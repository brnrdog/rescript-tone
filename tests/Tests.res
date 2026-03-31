open Zekr

let allSuites = Array.flat([
  CoreTests.suites,
  SourceTests.suites,
  EffectTests.suites,
  SignalTests.suites,
  SchedulingTests.suites,
])

runSuites(allSuites)
