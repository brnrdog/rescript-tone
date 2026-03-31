// Bindings for ToneAudioNode - the base class for all audio nodes
// All audio nodes (instruments, effects, sources, etc.) extend this

type t

@send external connect: (t, t) => t = "connect"
@send external connectWithOutput: (t, t, ~outputNum: int) => t = "connect"
@send external connectWithOutputInput: (t, t, ~outputNum: int, ~inputNum: int) => t = "connect"
@send external disconnect: t => t = "disconnect"
@send external disconnectFrom: (t, t) => t = "disconnect"
@send external toDestination: t => t = "toDestination"
@send external dispose: t => t = "dispose"

@send @variadic external chain: (t, array<t>) => t = "chain"
@send @variadic external fan: (t, array<t>) => t = "fan"

@get external numberOfInputs: t => int = "numberOfInputs"
@get external numberOfOutputs: t => int = "numberOfOutputs"
@get external channelCount: t => int = "channelCount"
@set external setChannelCount: (t, int) => unit = "channelCount"
