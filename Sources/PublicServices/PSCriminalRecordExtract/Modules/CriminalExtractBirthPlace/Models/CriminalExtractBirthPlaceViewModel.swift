import Foundation

public class CriminalExtractBirthPlaceViewModel {
    
    public enum TextFieldState {
        case editing(String?)
        case finishedEdit(String?)
    }
    
    public let title: String
    public let placeholder: String
    public let description: String?
    public let text: String?
    public let state: Bool
    public let isValidAppearance: Bool
    public let isEditable: Bool
    public let toggleAction: ((Bool) -> Void)?
    public let updateTextAction: ((TextFieldState) -> Void)?
    
    init(
        title: String,
        placeholder: String,
        text: String?,
        description: String?,
        toggleState: Bool,
        isValidAppearance: Bool,
        isEditable: Bool,
        toggleAction: ((Bool) -> Void)?,
        updateTextAction: ((TextFieldState) -> Void)?
    ) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.description = description
        self.state = toggleState
        self.isValidAppearance = isValidAppearance
        self.isEditable = isEditable
        self.toggleAction = toggleAction
        self.updateTextAction = updateTextAction
    }
}
