class ResumesController < ApplicationController
  #
  # Creates a new resume
  #
  # POST REQUEST
  # params:
  # :title the resume title
  # :revision the resume revision number
  # :user_name the user name (useful to avoid looking into db)
  # :user_id the user primary key (references the user table in auth)
  # :resume_data base 64 of the resume pdf
  #
  def create
    resume = Resume.new(resume_params)
    save = resume.save
    if save and resume.data.attached?
      Rails.logger.info('worked well')
      render json: resume, status: :created
    else
      msg = ["save the resume into the database?=#{!!save}"]
      msg << "attach the document to the resume entity?=#{!!resume.data.attached?}"
      msg << resume.errors.messages.to_s unless resume.errors.messages.empty?
      Rails.logger.error(msg)
      render json: { error: msg }, status: :bad_request
    end
  end

  #
  # return the resumes for a given user
  #
  # GET REQUEST
  # param:
  # user_id the user_id we are using to search
  def user_resumes
    user_id = params[:user_id]
    resumes = Resume.where(user_id: user_id)
    if resumes.empty?
      render json: {}, status: :not_found
    else
      render json: resumes, status: :ok
    end
  end

  #
  # return a single resume given
  #
  # GET REQUEST
  # ASSUMPTION: the user_id, title and revision should be unique per resume.
  # that is the combination is a primary_key
  # params:
  #   - user_id: is the user id
  #   - title: is the new title for the resume
  #   - revision: is the new revision for the resume

  #
  def fetch_specific_resume
    user_id = params[:user_id]
    title = params[:title]
    revision = params[:revision]

    resume = Resume.find_by(user_id: user_id, title: title, revision: revision)
    if resume.nil?
      render json: {}, status: :not_found
    else
      render json: resume, status: :ok
    end
  end

  #
  # delete a single resume given
  #
  # DELETE REQUEST
  # ASSUMPTION: the user_id, title and revision should be unique per resume.
  # that is the combination is a primary_key
  # params:
  #   - user_id: is the user id
  #   - title: is the new title for the resume
  #   - revision: is the new revision for the resume
  #
  def delete_specific_resume
    user_id = params[:user_id]
    title = params[:title]
    revision = params[:revision]
    resume = Resume.find_by(user_id: user_id, title: title, revision: revision)

    if resume.nil?
      render json: {}, status: :not_found
    else
      resume.destroy
      render json: {}, status: :ok
    end
  end

  #
  # edit a single resume given
  #
  # Patch REQUEST
  # params:
  #   - id: is the resume id NOT THE USER ID
  #   - title: is the new title for the resume
  #   - revision: is the new revision for the resume
  #
  def update_specific_resume
    id = params[:id]
    title = params[:title]
    revision = params[:revision]

    resume = Resume.find_by_id(id)
    if resume.nil?
      render json: {}, status: :not_found
    else
      resume.title = title;
      resume.revision = revision;
      save = resume.save
      msg = ["save the resume into the database?=#{!!save}"]
      msg << resume.errors.messages.to_s if resume.errors.messages.empty?
      Rails.logger.error(msg)

      if not resume.errors.messages.empty?
        render json: { errors: msg }, status: :bad_request
      else
        render json: resume, status: :ok
      end
    end
  end


  private

  def resume_params
    params.permit(:title, :revision, :user_name, :user_id, :resume_data)
  end
end
