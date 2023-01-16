//
//  TaskDAO.swift
//  todolistbyvoice
//
//  Created by Adrian Claure on 1/14/23.
//

import Foundation

class TaskDAO {
    private let sqliteHelper: SQLiteHelper
    
    init() {
        sqliteHelper = SQLiteHelper()
    }
    
    
    func insert(_ task: Task) {
        sqliteHelper.create(table: Task.tableName, values: task.toMap())
    }
    
    func update(_ task: Task) {
        sqliteHelper.update(table: Task.tableName, id: task.id ?? -1, values: task.toMap())
    }
    
    func delete(_ id: Int) {
        if id != -1 {
            sqliteHelper.delete(table: Task.tableName, id: id)
        }
    }
    
    func selectAll() -> [[String: Any]] {
        let result = sqliteHelper.select(table: Task.tableName)
        return result
    }
}
