require 'test_helper'
require 'webmock/minitest'

# This class will handle authentication failures
class ResumesControllerAuthTest < ActionDispatch::IntegrationTest
  setup do
    @endpoint = AuthenticationTokenVerifier::AUTHENTICATION_ENDPOINT
    @path = '/users/self'
    @dummy_token = "dummy_token"
    @headers = {
        "Content-type": "application/json",
        "Authorization": "Bearer #{@dummy_token}"
    }
    @expected_body = {
      "code": "InvalidCredentials",
      "message": "caused by JsonWebTokenError: invalid signature"
    }
  end

  test "should fail with unauthorized with an invalid token" do
    user_id = '99'
    stub_failed_auth_request(user_id)
    
    get user_resumes_url(user_id: user_id), headers: @headers
    assert_response 401, @expected_body
  end

  test "should fail with unauthorized when trying to access a different user data" do
    user_id = '99'
    stub_failed_auth_request(user_id)
    
    get user_resumes_url(user_id: '100'), headers: @headers
    assert_response 401, @expected_body
  end

  private

  def stub_failed_auth_request(user_id)
    stub_request(:get, "#{@endpoint}#{@path}")
    .with(headers: @headers)
    .to_return(
      status: 401,
      body: @expected_body.to_json,
      headers: {"Content-Type"=> "application/json"}
    )
  end
end
