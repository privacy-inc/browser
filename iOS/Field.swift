import UIKit

final class Field: UIView, UIKeyInput, UITextFieldDelegate {
    var hasText: Bool {
        get {
            field.text?.isEmpty == false
        }
        set {
            
        }
    }
    
    override var inputAccessoryView: UIView? {
        input
    }
    
    override var canBecomeFirstResponder: Bool {
        editable
    }
    
    weak var session: Session!
    private weak var field: UITextField!
    private var editable = true
    private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 56), inputViewStyle: .keyboard)
    
    required init?(coder: NSCoder) { nil }
    @MainActor init() {
        super.init(frame: .zero)
        let background = UIView()
        background.backgroundColor = .tertiarySystemBackground
        background.translatesAutoresizingMaskIntoConstraints = false
        background.isUserInteractionEnabled = false
        background.layer.cornerRadius = 12
        background.layer.borderColor = UIColor.label.withAlphaComponent(0.2).cgColor
        background.layer.borderWidth = 1
        background.layer.cornerCurve = .continuous
        input.addSubview(background)
        
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .webSearch
        field.textContentType = .URL
        field.clearButtonMode = .always
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.spellCheckingType = .no
        field.tintColor = .label
        field.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 4, weight: .regular)
        field.allowsEditingTextAttributes = false
        field.delegate = self
        input.addSubview(field)
        self.field = field
        
        background.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 22).isActive = true
        background.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor, constant: -22).isActive = true
        background.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        field.centerYAnchor.constraint(equalTo: input.centerYAnchor, constant: 3).isActive = true
        field.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 14).isActive = true
        field.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -8).isActive = true
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        DispatchQueue.main.async { [weak self] in
            self?.field.becomeFirstResponder()
        }
        return super.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_: UITextField) {
        field.selectAll(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.field.becomeFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        done()
        return true
    }
    
    func textFieldShouldEndEditing(_: UITextField) -> Bool {
        editable = false
        return true
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        editable = true
        field.text = ""
    }
    
    func insertText(_ text: String) {
        field.text = text
    }
    
    func deleteBackward() {
        
    }
    
    private func done() {
        session.search(string: field.text!)
        field.resignFirstResponder()
    }
}
