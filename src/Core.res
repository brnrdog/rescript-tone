// Top-level Tone.js module functions
open Types

@module("tone") external start: unit => promise<unit> = "start"
@module("tone") external now: unit => seconds = "now"
@module("tone") external immediate: unit => seconds = "immediate"
@module("tone") external getContext: unit => Context.t = "getContext"
@module("tone") external getTransport: unit => Transport.t = "getTransport"
@module("tone") external getDestination: unit => Destination.t = "getDestination"
@module("tone") external loaded: unit => promise<unit> = "loaded"
@module("tone") external supported: unit => bool = "supported"
@module("tone") external version: string = "version"
