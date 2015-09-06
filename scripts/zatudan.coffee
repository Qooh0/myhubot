# Description
#   DoCoMo 雑談API
#
# Command
#   el talk $message
#
# License
#   MIT
  

module.exports = (robot) ->
  base_url = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue'
  api_key = process.env.DOCOMO_API_KEY

  DOCOMO_TALK_CONTEXT = 'docomo_talk_context'
  DOCOMO_TALK_MODE = 'docomo_talk_mode'
  DOCOMO_TALK_LAST_TIME = 'docomo_talk_last_time'
  SPEND_MINUTES = 20

  robot.respond /talk (.*)/, (res) ->
    text = res.match[1].trim()
    return unless text

    return res.send 'NO DOCOMO_API_KEY' unless api_key

    # 前回会話してから一定時間が経っていたら、 context を破棄する
    get_context = () ->
      context = robot.brain.get DOCOMO_TALK_CONTEXT || ''
      last_time = new Date(robot.brain.get DOCOMO_TALK_LAST_TIME)
      now = new Date
      real_spend_minutes = (now - last_time) * 60 * 1000
      return context if real_spend_minuts < SPEND_MINUTES
      return ''

    set_context = (response_body) ->
      robot.brain.set DOCOMO_TALK_CONTEXT, response_body.context
      robot.brain.set DOCOMO_TALK_MODE, response_body.mode
      robot.brain.set DOCOMO_TALK_LAST_TIME, new Date

    get_mode = () ->
      return robot.brain.get DOCOMO_TALK_MODE

    api_url = base_url + '?APIKEY=' + api_key

    request = require('request')
    request.post
      url: api_url
      json:
        utt: text
        context: get_context
        mode: get_mode
        nickname: 'あなた'
        place: '東京'
    , (err, response, body) ->
      if err
        console.log "Encountered an error #{err}"
      else
        res.send body.utt
        set_context(body)
