class GradeModifiersController < ApplicationController
  respond_to :html, :js

  def show
  end

  def index
    @grade = params[:grade]
    @course = Course.find(params[:course_id])
    if params[:user_id] && params[:lesson_id]
      @user = User.find(params[:user_id])
      @lesson = Lesson.find(params[:lesson_id])
      @grade_modifier = GradeModifer.find_by(user_id: @user.id, lesson_id: @lesson.id)
    elsif params[:user_id] && params[:course_id]
      @user = User.find(params[:user_id])
      @grade_modifier = GradeModifer.find_by(user_id: @user.id, course_id: @course.id)
    elsif params[:lesson_id]
      @lesson = Lesson.find(params[:lesson_id])
      @grade_modifier = GradeModifer.find_by(user_id: nil, lesson_id: @lesson.id)
    else
      @course = Course.find(params[:course_id])
      @grade_modifier = GradeModifer.find_by(user_id: nil, course_id: @course.id)
    end
    @grade_modifier = GradeModifer.new if @grade_modifier.nil?
  end

  def new
    GradeModifer.new
  end

  def create
    @course = Course.find(params[:course_id])
    @user_ids = User.with_role(:student, @course).pluck(:id)
    if params[:grade_modifer][:user_id]
      @grade_modifier = GradeModifer.new(grade_modfier_params)
      respond_to do |format|
        if @grade_modifier.save!
          format.js
        else
          format.html { render :new }
          format.json { render json: @grade_modifier.errors, status: :unprocessable_entity }
        end
      end
    elsif params[:grade_modifer][:lesson_id]
      params[:grade_modifer][:course_id] = nil
      lesson_id = params[:grade_modifer][:lesson_id]
      @grade_modifier = GradeModifer.create!(grade_modfier_params)
      grade_modified = Hash.new(0)
      @modified_grade = params[:grade_modifer][:modified_grade_value]
      modifiers = GradeModifer.where("user_id IN (?) AND lesson_id = (?)", @user_ids, params[:grade_modifer][:lesson_id])
      modifiers.each { |modifier| grade_modified[modifier.user_id] = modifier.modified_grade_value }
      GradeModifer.delay.create_lesson_grade_for_all(@user_ids, lesson_id, @modified_grade, grade_modified)
    else
      @grade_modifier = GradeModifer.create!(grade_modfier_params)
      grade_modified = Hash.new(0)
      @modified_grade = params[:grade_modifer][:modified_grade_value]
      modifiers = GradeModifer.where("user_id IN (?) AND course_id = (?)", @user_ids, params[:grade_modifer][:course_id])
      modifiers.each { |modifier| grade_modified[modifier.user_id] = modifier.modified_grade_value }
      GradeModifer.delay.create_course_grade_for_all(@user_ids, @course.id, @modified_grade, grade_modified)
    end
  end

  def edit
  end

  def update
    @course = Course.find(params[:course_id])
    @user_ids = User.with_role(:student, @course).pluck(:id)
    if params[:grade_modifer][:user_id]
      @grade_modifier = GradeModifer.find(params[:id])
      @old_grade = @grade_modifier.modified_grade_value

      respond_to do |format|
        if @grade_modifier.update(grade_modfier_params)
          format.js
        else
          format.html { render :edit }
          format.json { render json: @grade_modifier.errors, status: :unprocessable_entity }
        end
      end
    elsif params[:grade_modifer][:lesson_id]
      params[:grade_modifer][:course_id] = nil
      lesson_id = params[:grade_modifer][:lesson_id]
      @grade_modifier = GradeModifer.find(params[:id])
      @old_grade = @grade_modifier.modified_grade_value
      @grade_modifier.update(grade_modfier_params)
      @modified_grade = params[:grade_modifer][:modified_grade_value]
      GradeModifer.delay.update_course_grade_for_all(@user_ids, lesson_id, @modified_grade)
    else
      @grade_modifier = GradeModifer.find(params[:id])
      @old_grade = @grade_modifier.modified_grade_value
      @grade_modifier.update(grade_modfier_params)
      @modified_grade = params[:grade_modifer][:modified_grade_value]
      GradeModifer.delay.update_course_grade_for_all(@user_ids, @course.id, @modified_grade)
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def grade_modfier_params
    params.require(:grade_modifer).permit(:user_id, :lesson_id, :course_id, :lesson_module_id, :modified_grade_value)
  end

  def set_grade_modfier
    @definition = Definition.find(params[:id])
  end
end
