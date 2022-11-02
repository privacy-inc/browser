import UIKit

final class Field: UIView, UIKeyInput, UITextFieldDelegate {
    private weak var field: UITextField!
    private var editable = true
    private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 52), inputViewStyle: .keyboard)
    
    required init?(coder: NSCoder) { nil }
    @MainActor init() {
        super.init(frame: .zero)
        let background = UIView()
        background.backgroundColor = .init(named: "Input")
        background.translatesAutoresizingMaskIntoConstraints = false
        background.isUserInteractionEnabled = false
        background.layer.cornerRadius = 12
        background.layer.borderColor = UIColor.label.withAlphaComponent(0.05).cgColor
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
        field.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .regular)
        field.allowsEditingTextAttributes = false
        field.delegate = self
        input.addSubview(field)
        self.field = field
        
        background.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        background.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        background.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.centerYAnchor.constraint(equalTo: input.centerYAnchor, constant: 3).isActive = true
        field.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 12).isActive = true
        field.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -6).isActive = true
    }
    
    func cancel(clear: Bool) {
        field.resignFirstResponder()
        
//        guard clear else { return }
//
//        if session.items[index].web == nil {
//            field.text = ""
//            filter.send("")
//        } else {
//            withAnimation(.easeInOut(duration: 0.4)) {
//                session.items[index].flow = session.items[index].info == nil ? .web : .message
//                session.objectWillChange.send()
//            }
//        }
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        Task {
//            await session.search(string: field.text!, index: index)
        }
        field.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_: UITextField) {
//        filter.send(field.text!)
    }
    
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
    
    func textFieldShouldEndEditing(_: UITextField) -> Bool {
        editable = false
        return true
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        editable = true
//        if session.items[index].web == nil {
//            typing = false
//        }
    }
    
    func insertText(_: String) {
        
    }
    
    func deleteBackward() {
        
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        DispatchQueue.main.async { [weak self] in
//            self?.typing = true
            self?.field.becomeFirstResponder()
        }
        return super.becomeFirstResponder()
    }
}
