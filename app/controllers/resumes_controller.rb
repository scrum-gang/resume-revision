class ResumesController < ApplicationController

  before_action :authenticate, except: [ :index ]

  def index
    render plain: "RESUME REVISION RULES AUTHBOIS SUCK! 🖕🖕"
  end

  # Creates a new resume
  #
  # POST REQUEST
  # params:
  #   - title: the resume title
  #   - revision: the resume revision number
  #   - user_name: the user name (useful to avoid looking into db)
  #   - user_id: the user primary key (references the user table in auth)
  #   - resume_data: base 64 of the resume pdf
  def create
    resume = Resume.new(resume_params)
    save = resume.save
    if save && resume.data.attached?
      render json: resume, status: :created
    else
      msg = ["Save the resume into the database?=#{!!save}"]
      msg << "Attach the document to the resume entity?=#{!!resume.data.attached?}"
      msg << resume.errors.messages.to_s unless resume.errors.messages.empty?
      Rails.logger.error(msg)
      render json: { error: msg }, status: :bad_request
    end
  end

  # Gets the resumes of a given user
  #
  # GET REQUEST
  # params:
  #   - user_id: the id of the user we are using to search
  def user_resumes
    user_id = params[:user_id]
    resumes = Resume.where(user_id: user_id)
    if resumes.empty?
      render json: {}, status: :not_found
    else
      render json: resumes, status: :ok
    end
  end

  # Gets a single resume given
  #
  # GET REQUEST
  # ASSUMPTION: the user_id, title and revision should be unique per resume.
  # that is the combination is a primary_key
  # params:
  #   - user_id: is the user id
  #   - title: is the new title for the resume
  #   - revision: is the new revision for the resume
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

  # Delete a single resume given
  #
  # DELETE REQUEST
  # ASSUMPTION: the user_id, title and revision should be unique per resume.
  # that is the combination is a primary_key
  # params:
  #   - user_id: is the user id
  #   - title: is the new title for the resume
  #   - revision: is the new revision for the resume
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

  # Edit a single resume given
  #
  # Patch REQUEST
  # params:
  #   - id: is the resume id NOT THE USER ID
  #   - title: is the new title for the resume
  #   - revision: is the new revision for the resume
  def update_specific_resume
    id = params[:id]
    title = params[:title]
    revision = params[:revision]

    resume = Resume.find_by_id(id)
    if resume.nil?
      render json: {}, status: :not_found
    else
      resume.title = title
      resume.revision = revision
      save = resume.save
      if save
        render json: resume, status: :ok
      else
        msg = ["Save the resume into the database?=#{!!save}"]
        msg << resume.errors.messages.to_s unless resume.errors.messages.empty?
        Rails.logger.error(msg)
        render json: { errors: msg }, status: :bad_request
      end
    end
  end

  private

  def resume_params
    params.permit(:title, :revision, :user_name, :user_id, :resume_data)
  end

  def bearer_token
    pattern = /^Bearer /
    header  = request.headers['Authorization']
    header.gsub(pattern, '') if header && header.match(pattern)
  end

  def authenticate
    response = AuthenticationTokenVerifier.verify_request(bearer_token)
    Rails.logger.info(response)

    if response.code != 200
      msg = ["Caused by JsonWebTokenError: Invalid signature"]
      render json: { errors: msg }, status: :unauthorized
    else
      # setup session variables
      session[:user_id] = response['_id']
      session[:email] = response['email']
      session[:type] = response['type']
      session[:verified] = response['verified']
    end
  end

  # make sure the user can do stuff only on his account
  def authorize
    unless session[:user_id] == params[:user_id]
      msg = ["Access to other users data is not allowed!"]
      render json: { errors: msg }, status: :unauthorized
    end
  end

  def authorize_based_on_resume_id
    id = params[:id]
    resume = Resume.find_by_id(id)
    if resume.nil?
      render json: {}, status: :not_found
    elsif session[:user_id] != resume.user_id
      msg = ["Access to other users data is not allowed!"]
      render json: { errors: msg }, status: :unauthorized
    end
  end
end
