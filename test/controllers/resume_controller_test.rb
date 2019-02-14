require 'test_helper'

# Look at fixtures
class ResumesControllerTest < ActionDispatch::IntegrationTest
  # Resumes tests
  test "should get not found for a non defined user" do
    get user_resumes_url(user_id: '99')
    assert_response :not_found
  end

  test "should get return success 200 for user 1" do
    get user_resumes_url(user_id: '1')
    assert_response :ok
  end

  test "should get a single resumes for user 1" do
    get user_resumes_url(user_id: '1')
    json = JSON.parse(response.body)
    assert_equal json, [resumes(:resume1)].as_json
  end

  test "should get a two resumes for user 2" do
    get user_resumes_url(user_id: '2')
    json = JSON.parse(response.body)
    assert_equal json, [resumes(:resume2_1), resumes(:resume2_2)].as_json
  end

  # Specific resumes tests
  test "should get not found for specific resume" do
    get fetch_specific_resume_url(user_id: '2', title: 'dummy', revision: '3')
    assert_response :not_found
  end

  test "should get find exactly one resume for specific query" do
    get fetch_specific_resume_url(user_id: '2', title: 'title', revision: '2')
    json = JSON.parse(response.body)
    assert_response :ok
    assert_equal json, resumes(:resume2_1).as_json
  end

  # Post resumes test
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

  test "should succeed creating a resume when all the data is correct" do
    params = {
      title: 'dummy',
      user_name: 'dummy',
      user_id: '44',
      revision: '33',
      resume_data: sample_resume
    }

    count = Resume.all.count
    post resumes_url, params: params
    json = JSON.parse(response.body).except("id").except("download_resume_url")
    assert_response :created
    assert_equal json, params.except(:resume_data).transform_keys { |key| key.to_s}
    assert_equal Resume.all.count , count+1

  end

  # Delete resume
  test "should delete a resume successfully" do
    params = {
        title: 'title',
        user_id: '2',
        revision: '2'
    }

    count = Resume.all.count
    delete delete_specific_resume_url(**params)
    assert_response :ok
    assert_equal Resume.all.count , count-1
  end

  test "should return not found on delete a resume that does not exists" do
    params = {
        title: 'not there',
        user_id: '2',
        revision: '2'
    }

    count = Resume.all.count
    delete delete_specific_resume_url(**params)
    assert_response :not_found
    assert_equal Resume.all.count , count
  end

  # Update a resume
  test "should update a resume successfully" do
    params = {
        title: 'new_title',
        revision: 'new_revision'
    }

    count = Resume.all.count
    patch update_specific_resume_url(2), params: params
    assert_response :ok
    assert_equal Resume.all.count , count

    resume = Resume.find_by_id(2)
    assert_equal 'new_title', resume.title
    assert_equal 'new_revision', resume.revision
  end

  test "should return not found on update a resume that does not exists" do
    params = {
        title: 'new_title',
        revision: 'new_revision'
    }

    count = Resume.all.count
    patch update_specific_resume_url(33), params: params
    assert_response :not_found
    assert_equal Resume.all.count , count
  end
end
