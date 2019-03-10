require 'httparty'
require 'test_helper'
require 'webmock/minitest'

# verifies the fetching of the token
class AuthenticationTokenVerifierTest  < ActiveSupport::TestCase
  setup do
    @endpoint = AuthenticationTokenVerifier::AUTHENTICATION_ENDPOINT
    @path = '/users/self'
    @dummy_token = "dummy_token"
    @headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer #{@dummy_token}"
    }
  end

  # we are stubing the request since we should not access the endpoint during test
  test ".verify_request returns code 400 on a bad token" do
    bad_token = "badtoken"
    stub_request(:get, "#{@endpoint}#{@path}")
        .with(headers: @headers)
        .to_return(status: 401)

    
    response = AuthenticationTokenVerifier.verify_request(@dummy_token)
    assert_equal response.code, 401
  end

  test ".verify_request returns code 200 on a good token" do
    bad_token = "badtoken"
    stub_request(:get, "#{@endpoint}#{@path}")
        .with(headers: @headers)
        .to_return(status: 200)

    
    response = AuthenticationTokenVerifier.verify_request(@dummy_token)
    assert_equal response.code, 200
  end

end