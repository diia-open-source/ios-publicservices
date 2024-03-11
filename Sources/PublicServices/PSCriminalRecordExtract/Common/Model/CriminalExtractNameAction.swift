import Foundation

enum CriminalExtractNameAction {
    case add
    case editing(oldValue: String, newValue: String)
    case finishedEditing(oldValue: String, newValue: String)
    case remove(value: String)
}
