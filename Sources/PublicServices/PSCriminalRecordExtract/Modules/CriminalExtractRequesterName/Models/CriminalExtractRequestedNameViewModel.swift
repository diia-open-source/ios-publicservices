import Foundation

class CriminalExtractRequestedNameViewModel {
    let values: [(value: String, isValid: Bool)]
    let isEnabledAdding: Bool
    let updateListAction: ((CriminalExtractNameAction) -> Void)?
    
    init(
        values: [(value: String, isValid: Bool)],
        isEnabledAdding: Bool,
        updateAction: ((CriminalExtractNameAction) -> Void)?
    ) {
        self.values = values
        self.isEnabledAdding = isEnabledAdding
        self.updateListAction = updateAction
    }
}
