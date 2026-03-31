open Zekr

let allSuites = Array.flat([CoreTests.suites, SourceTests.suites, EffectTests.suites])

runSuites(allSuites)
