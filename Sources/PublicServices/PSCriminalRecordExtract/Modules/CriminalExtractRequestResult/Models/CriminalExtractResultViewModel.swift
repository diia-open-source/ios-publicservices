import Foundation

class CriminalExtractResultViewModel {
    var isChecked: Bool
    var requestModel: CriminalExtractRequestModel
    
    init(
        requestModel: CriminalExtractRequestModel,
        isChecked: Bool = false
    ) {
        self.isChecked = isChecked
        self.requestModel = requestModel
    }
}
