open Zekr

let allSuites = Array.flat([CoreTests.suites])

runSuites(allSuites)
