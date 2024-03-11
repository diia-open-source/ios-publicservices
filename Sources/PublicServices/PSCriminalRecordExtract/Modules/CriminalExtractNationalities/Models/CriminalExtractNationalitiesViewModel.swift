import Foundation

final class CriminalExtractNationalitiesViewModel {
    typealias ActionType = CriminalExtractNationalitiesActionType
    
    let nationalities: [String?]
    let action: ((ActionType) -> Void)?
    let isExpandable: Bool
    
    init(
        nationalities: [String?],
        isExpandable: Bool,
        action: ((ActionType) -> Void)?
    ) {
        self.nationalities = nationalities
        self.isExpandable = isExpandable
        self.action = action
    }
}

enum CriminalExtractNationalitiesActionType {
    case add
    case edit(index: Int)
    case remove(index: Int)
}
