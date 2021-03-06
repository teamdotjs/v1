class CourseEmailsController < ApplicationController
  before_action :set_course_email, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /course_emails
  # GET /course_emails.json
  def index
    @course = Course.find(params[:course_id])
    @course_emails = CourseEmail.all
  end

  # GET /course_emails/1
  # GET /course_emails/1.json
  def show
  end

  # GET /course_emails/new
  def new
    @course_email = CourseEmail.new
    @course = Course.find(params[:course_id])
  end

  # GET /course_emails/1/edit
  def edit
  end

  # POST /course_emails
  # POST /course_emails.json
  def create
    @course_email = CourseEmail.new(course_email_params)
    respond_to do |format|
      if @course_email.save
        send_email
        format.html { redirect_to course_path(@course_email.course), notice: 'Course email was successfully created.' }

        format.json { render :show, status: :created, location: @course_email }
      else
        format.html { render :new }
        format.json { render json: @course_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_emails/1
  # PATCH/PUT /course_emails/1.json
  def update
    respond_to do |format|
      if @course_email.update(course_email_params)
        format.html { redirect_to course_course_email_path(@course_email, course_id: @course_email.course.id), notice: 'Course email was successfully updated.' }
        format.json { render :show, status: :ok, location: @course_email }
      else
        format.html { render :edit }
        format.json { render json: @course_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_emails/1
  # DELETE /course_emails/1.json
  def destroy
    @course_email.destroy
    respond_to do |format|
      format.html { redirect_to course_course_emails_path(course_id: @course_email.course.id), notice: 'Course email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_email
      @course_email = CourseEmail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_email_params
      params.require(:course_email).permit(:course_id, :title, :content, :user_id)
    end

    def send_email
      recipients = []
      params[:course_email][:user_id].each do |id|
        @student = User.find_by_id(id)
        if @student
          recipients.push(@student.email)
        end
      end
      UserMailer.custom_email(recipients, @course_email.title, @course_email.content, User.with_role(:teacher, @course_email.course).pluck(:email)).deliver_later
    end

end
