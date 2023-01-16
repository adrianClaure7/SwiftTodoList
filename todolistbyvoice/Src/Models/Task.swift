//
//  Task.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/14/23.
//

import Foundation

struct TaskTable {
    var id: Int?
    var title: String
    var description: String?
    var status: Int?
    var audio_path: String?
}

struct Task {
    var id: Int?
    var title: String
    var description: String?
    var status: Int?
    var audioPath: String?

    // Initializer
    init(id: Int?, title: String, description: String?, status: Int?, audioPath: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.status = status
        self.audioPath = audioPath
    }

    func toMap() -> [String: Any] {
        return [
            "id": id as Any,
            "title": title as Any,
            "description": description as Any,
            "status": status as Any,
            "audio_path": audioPath as Any
        ]
      }

    static func convertToTasks(_ dictionaries: [[String: Any]]) -> [Task] {
        var tasks = [Task]()
        for dictionary in dictionaries {
            
            let task = Task(
                id: dictionary["id"] as? Int ?? 0,
                title: dictionary["title"] as? String ?? "",
                description: dictionary["description"] as? String ?? "",
                status: dictionary["status"] as? Int ?? 0,
                audioPath: dictionary["audio_path"] as? String ?? "")
            tasks.append(task)
        }
        return tasks
    }

    func fromMap(map: TaskTable)->Task {
        return Task(
            id: map.id,
            title: map.title,
            description: map.description,
            status: map.status,
            audioPath: map.audio_path
        )
    }
    
    static var tableName: String = "Task"

    static var createTableQuery: String = """
          CREATE TABLE IF NOT EXISTS \(tableName) (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            status INTEGER,
            audio_path TEXT
          )
          """;
}
