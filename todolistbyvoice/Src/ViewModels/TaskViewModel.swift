import Foundation
import AppKit

class TaskViewModel: ObservableObject {
    @Published var task: Task
    private var taskDAO: TaskDAO
    
    init(task: Task, taskDAO: TaskDAO) {
        self.task = task
        self.taskDAO = taskDAO
    }
    
    func downloadAudioPath() {
        if !self.task.audioPath!.isEmpty {
            let fileURL = URL(string: self.task.audioPath!.replacingOccurrences(of: "file://", with: ""))
            
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: fileURL?.path ?? "")
        }
    }
    
    func completeTask(status: Int) {
        task.status = status
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
