module.exports = (robot) ->
  robot.hear /hi$|hai$/i, (msg) ->
    msg.send "hello!"
