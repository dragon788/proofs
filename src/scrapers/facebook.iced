{BaseScraper} = require './base'
{constants} = require '../constants'
{v_codes} = constants

#================================================================================

exports.FacebookScraper = class FacebookScraper extends BaseScraper

  # We don't actually hunt for Facebook proofs. The hunt2 method is a no-op.
  # Instead, after the user posts a proof, Facebook gives them a redirect back
  # to our servers, and we learn the proof ID that way. The check_status method
  # does actually check the status though.

  constructor: (opts) ->
    @auth = opts.auth
    super opts

  # ---------------------------------------------------------------------------

  _check_args : (args) ->
    if not(args.username?)
      new Error "Bad args to Facebook proof: no username given"
    else if not (args.name?) or (args.name isnt 'facebook')
      new Error "Bad args to Facebook proof: type is #{args.name}"
    else
      null

  # ---------------------------------------------------------------------------

  hunt2 : ({username, proof_text_check, name}, cb) ->
    err = new Error "hunt2 is a no-op for Facebook"
    cb err, null

  # ---------------------------------------------------------------------------

  _check_api_url : ({api_url,username}) ->
    rxx = new RegExp("^https://facebook.com/#{username}/posts/", "i")
    return (api_url? and api_url.match(rxx));

  # ---------------------------------------------------------------------------

  check_status: ({username, api_url, proof_text_check, remote_id}, cb) ->

    cb null, v_codes.NOT_FOUND

    # # calls back with a v_code or null if it was ok
    # await @_get_body api_url, false, defer err, rc, raw

    # ptc_buf = new Buffer proof_text_check, "base64"
    # rc = if rc isnt v_codes.OK                       then rc
    # else if @_find_sig_in_raw(proof_text_check, raw) then v_codes.OK
    # else                                                  v_codes.NOT_FOUND
    # cb err, rc

  # ---------------------------------------------------------------------------

  _get_body : (url, json, cb) ->
    @log "| HTTP request for URL '#{url}'"
    args =
      url : url
      auth : @auth
    args.json = 1 if json
    @_get_url_body args, cb

#================================================================================

