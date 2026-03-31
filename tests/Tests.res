open Zekr

let allSuites = Array.flat([CoreTests.suites, SourceTests.suites])

runSuites(allSuites)
