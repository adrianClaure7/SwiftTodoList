import SQLite3
import Foundation

class SQLiteHelper {
    private var db: OpaquePointer? = nil

    init() {
        self.db = openDatabase()
        if self.db != nil {
            initDb()
        }
    }
    
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
               .appendingPathComponent("db.sqlite")
      
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(fileURL.path)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }

    func initDb() {
        if sqlite3_exec(db, Task.createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table \(Task.tableName): \(errmsg)")
        }
    }

    func create(table: String, values: [String: Any]) {
        var sql = "INSERT INTO \(table) ("
        var valuesString = "VALUES ("
        var first = true
        for (column, value) in values {
            if value as? String != nil {
               if first {
                   first = false
               } else {
                   sql += ", "
                   valuesString += ", "
               }
               sql += column
                valuesString += "'" + "\(value as! String)" + "'"
            }
        }
        sql += ") " + valuesString + ")"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\(table) table created.")
            } else {
                print("\(table) table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }

    func select(table: String, whereClause: String? = nil) -> [[String: Any]] {
        var rows = [[String: Any]]()
        guard db != nil else {
            print("error: database not open")
            return rows
        }

        var queryString = "SELECT * FROM \(table)"
        if let whereClause = whereClause {
            queryString += " WHERE \(whereClause)"
        }

        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString, -1, &selectStatement, nil) == SQLITE_OK {
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                var row = [String: Any]()
                let columnCount = sqlite3_column_count(selectStatement)
                for i in 0..<columnCount {
                    let columnName = String(cString: sqlite3_column_name(selectStatement, i))
                    switch sqlite3_column_type(selectStatement, i) {
                    case SQLITE_INTEGER:
                        row[columnName] = Int(sqlite3_column_int(selectStatement, i))
                    case SQLITE_FLOAT:
                        row[columnName] = Double(sqlite3_column_double(selectStatement, i))
                    case SQLITE_TEXT:
                        if let text = sqlite3_column_text(selectStatement, i) {
                            row[columnName] = String(cString: text)
                        }
                    case SQLITE_NULL:
                        row[columnName] = NSNull()
                    default:
                        break
                    }
                }
                rows.append(row)
            }
        } else {
            print("SELECT statement could not be prepared.")
        }
        sqlite3_finalize(selectStatement)
        return rows
    }

    func update(table: String, id: Int, values: [String: Any]) {
        var sql = "UPDATE \(table) SET "
        for (key, value) in values {
            if value as? String != nil {
                sql += "\(key) = '" + (value as! String) + "', "
            }
            if value as? Int != nil && key != "id"   {
                sql += "\(key) = \(value as! Int), "
            }
        }
        sql = String(sql.dropLast(2))
        sql += " WHERE id = \(id)"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &updateStatement, nil) == SQLITE_OK {
        if sqlite3_step(updateStatement) == SQLITE_DONE {
            print("\(table) table updated.")
        } else {
            print("\(table) table could not be created.")
        }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }

    func delete(table: String, id: Int) {
       guard db != nil else {
           print("error: database not open")
           return
       }

       let deleteString = "DELETE FROM \(table) WHERE id = ?"
       var deleteStatement: OpaquePointer? = nil
       if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
           sqlite3_bind_int(deleteStatement, 1, Int32(id))
           if sqlite3_step(deleteStatement) == SQLITE_DONE {
               print("Successfully deleted row with id: \(id) from table: \(table).")
           } else {
               print("Could not delete row with id: \(id) from table: \(table).")
           }
       } else {
           print("DELETE statement could not be prepared.")
       }
       sqlite3_finalize(deleteStatement)
    }

    deinit {
        sqlite3_close(db)
    }
}
