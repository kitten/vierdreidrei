child_process = require 'child_process'
path = require 'path'
events = require 'events'

module.exports.emitter = new events.EventEmitter()

senderReady = false
senderQueue = []
receiverQueue = []

queueReceive = (data, time) ->
  valid = true
  iterator = 0
  while valid and iterator < senderQueue.length
    obj = senderQueue[iterator]
    if obj.data is data
      if time - obj.timestamp < 1200
        valid = false
        break
    iterator++
  if valid
    iterator = 0
    while valid and iterator < receiverQueue.length
      obj = receiverQueue[iterator]
      if obj.data is data
        if time - obj.timestamp < 1200
          valid = false
          break
      iterator++
  receiverQueue.push
    data: data
    timestamp: time
  if valid
    module.exports.emitter.emit 'data', data

queueSend = (data, time) ->
  senderQueue.push
    data: data
    timestamp: time
  senderChild.stdin.write data + '\n'

receiverPath = path.join __dirname, 'rcswitch', 'receive'
receiverChild = child_process.spawn receiverPath

receiverChild.on 'exit', (code, signal) ->
  receiverChild = child_process.spawn receiverPath

senderPath = path.join __dirname, 'rcswitch', 'send'
senderChild = child_process.spawn senderPath

senderChild.on 'exit', (code, signal) ->
  senderChild = child_process.spawn senderPath

receiverChild.stdout.on 'data', (chunk) ->
  data = parseInt(chunk.toString())
  queueReceive data, (new Date()).getTime()

senderChild.stdout.on 'data', (chunk) ->
  data = chunk.toString()
  if data.indexOf 'EAD' > -1
    senderReady = true
    module.exports.emitter.emit 'ready'

send = (int, cb) ->
  if senderReady
    queueSend parseInt(int), (new Date()).getTime()
    cb null
  else
    cb "Sender isn't ready yet!"

module.exports.send = send
