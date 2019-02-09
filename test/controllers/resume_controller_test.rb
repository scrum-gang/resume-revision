require 'test_helper'

#
# Look at fixtures
#
class ResumesControllerTest < ActionDispatch::IntegrationTest
  #resumes tests
  test "should get not found for a non defined user" do
    get user_resumes_url(user_id: 99)
    assert_response :not_found
  end

  test "should get return success 200 for user 1" do
    get user_resumes_url(user_id: 1)
    assert_response :ok
  end

  test "should get a single resumes for user 1" do
    get user_resumes_url(user_id: 1)
    json = JSON.parse(response.body)
    assert_equal json, [resumes(:resume1)].as_json
  end

  test "should get a two resumes for user 2" do
    get user_resumes_url(user_id: 2)
    json = JSON.parse(response.body)
    assert_equal json, [resumes(:resume2_1), resumes(:resume2_2)].as_json
  end


  #specific resumes tests
  test "should get not found for specific resume" do
    get fetch_specific_resume_url(user_id: 2, title: 'dummy', revision: '3')
    assert_response :not_found
  end

  test "should get find exactly one resume for specific query" do
    get fetch_specific_resume_url(user_id: 2, title: 'title', revision: '2')
    json = JSON.parse(response.body)
    assert_response :ok
    assert_equal json, resumes(:resume2_1).as_json
  end

  #post resumes test
  test "should fail when missing a parameter of a resume" do
    params = {
      title: 'dummy',
      user_name: 'dummy',
      user_id: '44',
      resume_data: sample_resume
    }
    post resumes_url, params: params
    assert_response :bad_request
  end

  test "should fail when missing the resume data" do
    params = {
      title: 'dummy',
      user_name: 'dummy',
      user_id: '44',
      revision: '33'
    }
    post resumes_url, params: params
    assert_response :bad_request
  end

  test "should succeed creating a resume when all the data is correct" do
    params = {
      title: 'dummy',
      user_name: 'dummy',
      user_id: 44,
      revision: '33',
      resume_data: sample_resume
    }
    post resumes_url, params: params
    json = JSON.parse(response.body).except("id").except("download_resume_url")
    assert_response :created
    assert_equal json, params.except(:resume_data).transform_keys { |key| key.to_s}
  end
end



