# Description
#   DoCoMo FAQ
#
# Command
#   el faq $question
#
# License
#   MIT

module.exports = (robot) ->
  base_url = 'https://api.apigw.smt.docomo.ne.jp/knowledgeQA/v1/ask'
  api_key = process.env.DOCOMO_API_KEY

  robot.respond /faq (.*)/, (res) ->
    text = res.match[1].trim()
    return unless text

    return res.send 'NO DOCOMO_API_KEY' unless api_key

    api_url = base_url + '?APIKEY=' + api_key + '&q=' + encodeURIComponent(text)

    request = require('request')
    request.get
      url: api_url
    , (err, response, body) ->
      if err
        console.log "Encountered an err #{err}"
      else
        ans = JSON.parse(body)
        res.send ans.message.textForDisplay

