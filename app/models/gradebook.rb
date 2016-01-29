class Gradebook
  def self.course_grades(answers, users, course)
    #Creates 2 hashes that will always start with an empty array oy 0,0
    #course_grades will become the size of students * lesson * lesson_modules and will figure out the points per lesson_module
    #final_grades will become the size of students + (users * lessons) and will return the total time for each student and lesson
    course_grades = Hash.new([0,0])
    final_grades = Hash.new([0,0])

    #This iterates over all of the answers queried and condenses them in the hash by inserting by the user.id,
    #  lesson.id and lesson_module.id to create a unqiue value for all of the answers belonging to those 3 unique values
    #There can be multiple answers for the above for the number of total course questions * lesson_module.attempt.
    #  That is why it adds for each iteration instead of inserting.
    answers.each do |answer|
      total_correct, total_time = course_grades["#{answer['user_id']}.#{answer['lesson_id']}.#{answer['lesson_module_id']}"]

      course_grades["#{answer['user_id']}.#{answer['lesson_id']}.#{answer['lesson_module_id']}"] = [(total_correct + answer['correct']), (total_time + answer['time_to_complete'])]
    end

    #After all of the answers have been sorted it will calculate the grade for each lesson_module
    course.lessons.each do |lesson|
      lesson.lesson_modules.each do |lesson_module|
        users.each do |user|
          total_correct, total_time = course_grades["#{user.id}.#{lesson.id}.#{lesson_module.id}"]

          course_grades["#{user.id}.#{lesson.id}.#{lesson_module.id}"] = calculate_lesson_grade(total_correct, total_time, lesson_module)
        end
      end
    end

    #After all of the lesson_module grades are calculated it calculates the lesson grade and time by iterating over
    #  all of the less_grades
    #It starts using the final_grades array to store the final grade and time for the user and their grade and time on
    #  each individual lesson
    #K is split into an array of 0 -> user.id, 1 -> lesson.id and 2 -> lesson_module.id
    #V is an array of 0 -> grade, 1 -> time
    course_grades.each do |k, v|
      key_split = k.split('.')
      total_grade, total_time = final_grades["#{key_split[0]}.#{key_split[1]}"]
      final_grade, final_time = final_grades["#{key_split[0]}"]

      final_grades["#{key_split[0]}.#{key_split[1]}"] = [total_grade+v[0],total_time+v[1]]
      final_grades["#{key_split[0]}"] = [final_grade+v[0], final_time+v[1]]
    end

    #This iteration helps calculate each lesson's average grade and the final average
    course.lessons.each do |lesson|
      users.each do |user|
        lesson_grade, lesson_time = final_grades["#{user.id}.#{lesson.id}"]
        average_grade_total, average_time_total = final_grades["Lesson #{lesson.id}"]

        final_grades["Lesson #{lesson.id}"] = [(lesson_grade+average_grade_total), (lesson_time+average_time_total)]
      end
      total_students_grade, total_students_time = final_grades["Lesson #{lesson.id}"]
      final_average_grade, final_average_time = final_grades["Course #{course.id}"]

      final_grades["Lesson #{lesson.id}"] = [('%.2f' % total_students_grade.fdiv(users.length)), ('%.0f' % total_students_time.fdiv(users.length))]
      final_grades["Course #{course.id}"] = [(final_average_grade+total_students_grade), (total_students_time+final_average_time)]
    end

    #After we have totaled all of the lesson values we will calculate it for the courses final grade average
    final_average_grade, final_average_time = final_grades["Course #{course.id}"]
    final_grades["Course #{course.id}"] = [('%.2f' % final_average_grade.fdiv(users.length*course.lessons.length)), ('%.0f' % final_average_time.fdiv(users.length))]

    #This calculates the users final grade for the course
    users.each do |user|
      final_grade, final_time = final_grades["#{user.id}"]
      final_grades["#{user.id}"] = [('%.2f' % final_grade.fdiv(course.lessons.length)).to_i, final_time]
    end

    #Returns hash with the user's final grade/time and grade/time for each lesson
    final_grades
  end

  def self.lesson_grades(answers, users, lesson)
    #Creates 1 hashes that will always start with an empty array oy 0,0
    #lesson_grades will become the size of students + students * lesson_modules and will figure out the points per lesson_module
    lesson_grades = Hash.new([0,0])
    answers.each do |answer|
      total_correct, total_time = lesson_grades["#{answer['user_id']}.#{answer['lesson_module_id']}"]
      lesson_grades["#{answer['user_id']}.#{answer['lesson_module_id']}"] = [(total_correct + answer['correct']), (total_time + answer['time_to_complete'])]
    end

    #sets the final grade and time for each lesson and lesson_module
    lesson.lesson_modules.each do |lesson_module|
      users.each do |user|
        #Gets the basic information for the lesson and lesson_modules for final grades
        total_correct, total_time = lesson_grades["#{user.id}.#{lesson_module.id}"]
        final_grade, final_time = lesson_grades["#{user.id}"]
        lesson_module_grade_total, lesson_module_time_total = lesson_grades["Lesson Module #{lesson_module.id}"]
        final_average_grade, final_average_time = lesson_grades["Lesson #{lesson.id}"]

        #Calculates the grades for the lesson total and the lesson_module totals
        lesson_module_grade, lesson_module_time = calculate_lesson_module_grade(total_correct, total_time, lesson_module)
        lesson_grade, lesson_time = calculate_lesson_grade(total_correct, total_time, lesson_module)

        #Sets the grade and time for each lesson_module and the final lesson grade overall
        lesson_grades["#{user.id}.#{lesson_module.id}"] = [lesson_module_grade, lesson_module_time]
        lesson_grades["#{user.id}"] = [(final_grade+lesson_grade),(final_time+lesson_time)]
        lesson_grades["Lesson Module #{lesson_module.id}"] = [(lesson_module_grade_total+lesson_module_grade), (lesson_module_time_total+lesson_module_time)]
        lesson_grades["Lesson #{lesson.id}"] = [(final_average_grade+lesson_grade),(final_average_time+lesson_time)]
      end
      lesson_module_grade_total, lesson_module_time_total = lesson_grades["Lesson Module #{lesson_module.id}"]

      lesson_grades["Lesson Module #{lesson_module.id}"] = [('%.2f' % lesson_module_grade_total.fdiv(users.length)), ('%.0f' % lesson_module_time_total.fdiv(users.length))]
    end
    final_students_grade, final_students_time = lesson_grades["Lesson #{lesson.id}"]
    lesson_grades["Lesson #{lesson.id}"] = [('%.2f' % final_students_grade.fdiv(users.length)), ('%.0f' % final_students_time.fdiv(users.length))]


    #Returns hash with the user's final lesson grade/time and grade/time for each lesson_module
    lesson_grades
  end

  def self.lesson_module_grades(answers, users, lesson_module)
    #Creates 1 hashes that will always start with an empty array oy 0,0
    #lesson_module_grades will become the size of students + students * question * lesson_module.attempts and will figure out the points per question
    lesson_module_grades = Hash.new([0,[],0,[]])

    #This iterates over all of the answers queried and condenses them in the hash by inserting by the user.id,
    #  question.id to create a unqiue value for all of the answers belonging to those 2 unique values.
    #There can be multiple answers for the above for the number of total course questions * lesson_module.attempt.
    #  That is why it adds for each iteration instead of inserting.
    answers.each do |answer|
      total_correct, total_time, number_of_attempts, choices = lesson_module_grades["#{answer['user_id']}.#{answer['question_id']}"]

      lesson_module_grades["#{answer['user_id']}.#{answer['question_id']}"] = [(total_correct + answer['correct']), (total_time.push(answer['time_to_complete'])), (number_of_attempts+1), choices.push('X')]
    end

    #TODO: needs work and has a clear bug
    lesson_module.questions.each do |question|
      users.each do |user|
        total_correct, total_time, number_of_attempts, choices = lesson_module_grades["#{user.id}.#{question.id}"]
        lesson_module_grades["#{user.id}.#{lesson_module.id}.#{question.id}"] = [calculate_question_grade(total_correct),(total_time.sum)]
      end
    end
    lesson_module_grades
  end

  def self.student_grades(answers, course)
    student_grades = Hash.new([0,0])
    answers.each do |answer|
      grade, time = student_grades["#{course.id}.#{answer['lesson_id']}.#{answer['lesson_module_id']}"]
      student_grades["#{course.id}.#{answer['lesson_id']}.#{answer['lesson_module_id']}"] = [(grade + answer['correct']), (time + answer['time_to_complete'])]
    end

    course.lessons.each do |lesson|
      lesson.lesson_modules.each do |lesson_module|
        lesson_grade, lesson_time = student_grades["#{course.id}.#{lesson.id}"]
        lesson_module_grade, lesson_module_time = student_grades["#{course.id}.#{lesson.id}.#{lesson_module.id}"]
        module_grade, module_time = calculate_lesson_module_grade(lesson_module_grade, lesson_module_time, lesson_module)
        calculated_lesson_grade, calculated_lesson_time = calculate_student_lesson_grade(module_grade, module_time, lesson_module)

        student_grades["#{course.id}.#{lesson.id}.#{lesson_module.id}"] = [module_grade, module_time]
        student_grades["#{course.id}.#{lesson.id}"] = [lesson_grade + calculated_lesson_grade, lesson_time + calculated_lesson_time ]
      end
      course_grade, course_time = student_grades["#{course.id}"]
      lesson_grade, lesson_time = student_grades["#{course.id}.#{lesson.id}"]
      student_grades["#{course.id}"] = [course_grade + lesson_grade, course_time + lesson_time]
    end
    course_grade, course_time = student_grades["#{course.id}"]
    student_grades["#{course.id}"] = [('%.2f' % course_grade.fdiv(course.lessons.length)).to_i, course_time]

    student_grades
  end


  #Calculates a lesson total grade with only 2 digits after the decimal place
  def self.calculate_lesson_grade(total_correct, total_time, lesson_module)
    [('%.2f' % ((total_correct.fdiv(lesson_module.questions.length))*lesson_module.value_percentage)).to_i, total_time]
  end

  def self.calculate_student_lesson_grade(total_correct, total_time, lesson_module)
    [('%.2f' % (total_correct*(lesson_module.value_percentage.fdiv(100)))).to_i, total_time]
  end

  #Calculates a lesson_module total grade with only 2 digits after the decimal place
  def self.calculate_lesson_module_grade(total_correct, total_time, lesson_module)
    [('%.2f' % ((total_correct.fdiv(lesson_module.questions.length))*100)).to_i, total_time]
  end

  #Determines if a user got the question correct
  #To be correct there should be 1 answer correct
  #If it is wrong then the incoming number should be a 0
  def self.calculate_question_grade(total_correct)
    (total_correct == 1) ? 100 : 0
  end
end