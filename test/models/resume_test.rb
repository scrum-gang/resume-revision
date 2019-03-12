require 'test_helper'

class ResumeTest < ActiveSupport::TestCase
  test 'should return true' do
    assert true
  end

  test 'should not be able to create a resume without a title' do
    resume = Resume.new(revision: "33", user_name: "elias", user_id: "abcd")
    refute resume.valid?
    refute resume.save
  end

  test 'should not be able to create a resume without a revision' do
    resume = Resume.new(title: "33", user_name: "elias", user_id: "abcd")
    refute resume.valid?
    refute resume.save
  end

  test 'should not be able to create a resume without a user_id' do
    resume = Resume.new(revision: "33", user_name: "elias", title: "abcd")
    refute resume.valid?
    refute resume.save
  end

  test 'should be able to create a resume without a user_name' do
    resume = Resume.new(revision: "33", title: "elias", user_id: "abcd")
    assert resume.valid?
    assert resume.save
  end

  test 'should not be able to create two resumes with the same user_id, title, and revision' do
    assert_difference 'Resume.count', 1 do
      resume = Resume.new(revision: "33", title: "elias", user_id: "abcd")
      assert resume.save

      another_resume = Resume.new(revision: "33", title: "elias", user_id: "abcd")
      refute another_resume.valid?
      refute another_resume.save
    end
  end
end