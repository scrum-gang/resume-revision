require 'test_helper'
require 'webmock/minitest'

# Look at fixtures for a sample resume
class ResumesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @endpoint = AuthenticationTokenVerifier::AUTHENTICATION_ENDPOINT
    @path = '/users/self'
    @dummy_token = "dummy_token"
    @headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer #{@dummy_token}"
    }
  end

  test "should get not found for a non defined user" do
    user_id = '99'
    stub_successful_auth_request(user_id)
    get user_resumes_url(user_id: user_id), headers: @headers
    assert_response :not_found
  end

  test "should get return success 200 for user 1" do
    user_id = '1'
    stub_successful_auth_request(user_id)
    get user_resumes_url(user_id: user_id), headers: @headers
    assert_response :ok
  end

  test "should get a single resumes for user 1" do
    user_id = '1'
    stub_successful_auth_request(user_id)
    get user_resumes_url(user_id: user_id), headers: @headers
    json = JSON.parse(response.body)
    assert_equal json, [resumes(:resume1)].as_json
  end

  test "should get a two resumes for user 2" do
    user_id = '2'
    stub_successful_auth_request(user_id)
    get user_resumes_url(user_id: user_id), headers: @headers
    json = JSON.parse(response.body)
    assert_equal json, [resumes(:resume2_1), resumes(:resume2_2)].as_json
  end

  # Specific resumes tests
  test "should get not found for specific resume" do
    user_id = '2'
    stub_successful_auth_request(user_id)
    get fetch_specific_resume_url(user_id: user_id, title: 'dummy', revision: '3'), headers: @headers
    assert_response :not_found
  end

  test "should get find exactly one resume for specific query" do
    user_id = '2'
    stub_successful_auth_request(user_id)
    get fetch_specific_resume_url(user_id: user_id, title: 'title', revision: '2'), headers: @headers
    json = JSON.parse(response.body)
    assert_response :ok
    assert_equal json, resumes(:resume2_1).as_json
  end

  # Post resumes test
  test "should fail when missing the revision parameter of a resume" do
    user_id = '44'
    params = {
      title: 'dummy',
      user_name: 'dummy',
      user_id: user_id,
      resume_data: '1'
    }
    stub_successful_auth_request(user_id)
    post resumes_url, params: params, as: :json, headers: @headers
    assert_response :bad_request
  end

  test "should succeed creating a resume when all the data is correct" do
    user_id = '44'
    params = {
      title: 'dummy',
      user_name: 'dummy',
      user_id: user_id,
      revision: '33',
      resume_data: sample_resume
    }

    stub_successful_auth_request(user_id)

    assert_difference 'Resume.count', 1 do
      post resumes_url, params: params, as: :json, headers: @headers
      json = JSON.parse(response.body).except("id").except("download_resume_url")
      assert_response :created
      assert_equal json, params.except(:resume_data).transform_keys { |key| key.to_s}
    end
  end

  # Delete resume
  test "should delete a resume successfully" do
    user_id = '2'

    params = {
      title: 'title',
      user_id: user_id,
      revision: '2'
    }

    stub_successful_auth_request(user_id)

    assert_difference 'Resume.count', -1 do
      delete delete_specific_resume_url(**params), as: :json, headers: @headers
      assert_response :ok
    end
  end

  test "should return not found on delete a resume that does not exists" do
    user_id = '2'
    params = {
      title: 'not there',
      user_id: user_id,
      revision: '2'
    }

    stub_successful_auth_request(user_id)

    assert_no_difference 'Resume.count' do
      delete delete_specific_resume_url(**params), as: :json, headers: @headers
      assert_response :not_found
    end
  end

  # Update a resume
  test "should update a resume successfully" do
    params = {
      title: 'new_title',
      revision: 'new_revision'
    }

    resume = Resume.find_by_id(2)
    stub_successful_auth_request(resume.user_id)

    assert_no_difference 'Resume.count' do
      patch update_specific_resume_url(2), params: params, as: :json, headers: @headers
      assert_response :ok
    end

    resume.reload
    assert_equal 'new_title', resume.title
    assert_equal 'new_revision', resume.revision
  end

  test "should return not found on update a resume that does not exists" do
    params = {
      title: 'new_title',
      revision: 'new_revision'
    }

    stub_successful_auth_request('1')

    assert_no_difference 'Resume.count' do
      patch update_specific_resume_url(33), params: params, as: :json, headers: @headers
      assert_response :not_found
    end
  end

  private

  def stub_successful_auth_request(user_id)
    expected_body = {
      _id: user_id,
      email: 'dummy@dummy.ca',
      type: 'dummy_type',
      verified: true
    }

    stub_request(:get, "#{@endpoint}#{@path}")
    .with(headers: @headers)
    .to_return(
      status: 200,
      body: expected_body.to_json,
      headers: {"Content-Type"=> "application/json"}
    )
  end
end
