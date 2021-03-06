require 'test_helper'

describe TasksController do
    let (:task) {
      Task.create name: 'sample task', description: 'this is an example for a test',
      completed_at: Time.now + 5.days
    }

  # Tests for Wave 1
  describe 'index' do
    it 'can get the index path' do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it 'can get the root path' do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Tests for Wave 2
  describe 'show' do
    it 'can get a valid task' do
      # Act
      get task_path(task.id) # calling id on the return of the let method up top. 

      # Assert
      must_respond_with :success
    end

    it 'will redirect for an invalid task' do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe 'new' do
    it 'can get the new task page' do
      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe 'create' do
    it 'can create a new task' do
      # Arrange
      task_hash = {
        task: {
          name: 'new task',
          description: 'new task description',
          completed_at: nil
        }
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_differ 'Task.count', 1 # revert back to otherwise must_change

      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Tests for Wave 3
  describe 'edit' do
    it 'can get the edit page for an existing task' do
      get edit_task_path(task.id)
    end

    it 'will respond with redirect when attempting to edit a nonexistant task' do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
      must_redirect_to tasks_path

    end
  end

  describe 'update' do
    # Note:  If there was a way to fail to save the changes to a task, 
    # that would be a great thing to test.
    before do
      Task.create(name: "We're all wonders", description: " R.J. Palacio", completed_at: "11/1/2020")
    end
      let (:new_task_hash) {
        {
          task: {
            name: 'A Wrinkle in Time',
            description: 'A fabulous adventure',
            completed_at: '10/10/2020'
          }
        }
      }
      it 'can update an existing task' do
      # Arrange
      task = Task.first

      # Act-Assert
      expect {
        patch task_path(task.id), params: new_task_hash # the params method set the data structure 
        }.wont_change 'Task.count'

      task = Task.find_by(id: task.id)
      expect(task.name).must_equal new_task_hash[:task][:name]
      expect(task.description).must_equal new_task_hash[:task][:description]
      expect(task.completed_at).must_equal new_task_hash[:task][:completed_at]

      must_redirect_to tasks_path
    end

    it 'will redirect to the root page if given an invalid id' do
      # Act
      patch task_path(-1) # This will take to update 

      # Assert
      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end

  # Tests for Wave 4
  describe 'destroy' do

    it 'can destroy a model' do
      # Arrange
      test_task = Task.new name: 'Shopping', description: 'Holiday Shopping', completed_at: '11/1/2020'

      test_task.save
      id = test_task.id

      # Act
      expect {
        delete task_path(id)

      # Assert
      }.must_change 'Task.count', -1
    
      test_task = Task.find_by(name: 'Shopping')

      expect(test_task).must_be_nil

      must_respond_with :redirect
      must_redirect_to tasks_path

    end

    it 'will respond with redirect for invalid ids' do
      expect {
        delete task_path(-1)
      }.wont_change 'Task.count'

      must_respond_with :redirect
    end

  end

  describe "mark_complete" do

    it "complete at will return current date if mark complete " do
   
      test_task = Task.new name: 'Shopping', description: 'Holiday Shopping', completed_at: nil

      test_task.save
      id = test_task.id

      patch mark_complete_path(test_task.id)
      task = Task.find_by(id: test_task.id)
      expect(task.completed_at).must_equal "#{Time.now}"
  
      must_respond_with :redirect
      must_redirect_to tasks_path

    end 

    it "complete at will return nil if unmark complete" do
      test_task = Task.new name: 'Shopping', description: 'Holiday Shopping', completed_at: "11/1/2020"

      test_task.save
      id = test_task.id

      patch unmark_complete_path(test_task.id)
      task = Task.find_by(id: test_task.id)
      expect(task.completed_at).must_be_nil

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
 
  end

end
