class ResumesController < ApplicationController
  def index
    render('layouts/application')
  end

  def create
    resume = Resume.new(resume_params)
    save = resume.save
    if save and resume.data.attached?
      Rails.logger.info('worked well')
      render inline: "#{url_for(resume.data)}"
    else
      Rails.logger.error('did not work well either the attachment is wrong or missing attrib')
      Rails.logger.info("attached? #{!!resume.data.attached?}")
      Rails.logger.info("saved? #{!!save}")
    end
  end

  private
  def resume_params
    params.permit(:title, :revision, :user_name, :user_id, :resume_data)
  end
end
