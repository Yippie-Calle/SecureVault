//
//  DatabaseManager.swift
//  SecureVault
//
//  Created by Bryan Calle on 5/9/25.
//
import Foundation

import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?

    private init() {
        do {
            // Open or create the database
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("UserCredentials.sqlite")

            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("Error opening database: \(String(cString: sqlite3_errmsg(db)))")
                db = nil
            } else {
                createTable()
            }
        } catch {
            print("Error getting file URL: \(error.localizedDescription)")
        }
    }

    private func createTable() {
        guard db != nil else {
            print("Database connection is nil.")
            return
        }

        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT
        );
        """
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(db)))")
        }
    }

    func addUser(username: String, password: String) -> Bool {
        guard db != nil else {
            print("Database connection is nil.")
            return false
        }

        let insertQuery = "INSERT INTO Users (username, password) VALUES (?, ?);"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, username, -1, nil)
            sqlite3_bind_text(statement, 2, password, -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                sqlite3_finalize(statement)
                return true
            } else {
                print("Error inserting user: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("Error preparing insert statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(statement)
        return false
    }

    func validateUser(username: String, password: String) -> Bool {
        guard db != nil else {
            print("Database connection is nil.")
            return false
        }

        let query = "SELECT * FROM Users WHERE username = ? AND password = ?;"
        var statement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, username, -1, nil)
            sqlite3_bind_text(statement, 2, password, -1, nil)

            if sqlite3_step(statement) == SQLITE_ROW {
                sqlite3_finalize(statement)
                return true
            }
        } else {
            print("Error preparing validation statement: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(statement)
        return false
    }

    func closeDatabase() {
        if db != nil {
            if sqlite3_close(db) != SQLITE_OK {
                print("Error closing database: \(String(cString: sqlite3_errmsg(db)))")
            }
            db = nil
        }
    }
}
