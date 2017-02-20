require 'httparty'
# simple class that includes HTTParty and uses a specific SSL cipher to avoid
# OpenSSL::SSL::SSLError
class HttpWithCipher
  include HTTParty
  ciphers 'DES-CBC3-SHA'
  # ssl_version :SSLv3
  # default_options.update(verify: false, verify_peer: false)
  # default_options.update(verify: false)
end
