import Foundation

class TaskViewModel: ObservableObject {
    @Published var task: Task
    private var taskDAO: TaskDAO
    
    init(task: Task, taskDAO: TaskDAO) {
        self.task = task
        self.taskDAO = taskDAO
    }
    
    func completeTask() {
        task.status = 1
        taskDAO.update(task)
    }
    
    func deleteTask(id: Int) {
        taskDAO.delete(id)
    }
    
    func getTasks() -> [Task]  {
        let tasks = Task.convertToTasks(taskDAO.selectAll())
        return tasks
    }
}
