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
        field.font = .systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 4, weight: .regular)
        field.allowsEditingTextAttributes = false
        field.delegate = self
        input.addSubview(field)
        self.field = field
        
        let cancel = UIButton(primaryAction: .init { [weak self] _ in
            self?.field.resignFirstResponder()
        })
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setImage(.init(systemName: "xmark")?
            .applyingSymbolConfiguration(.init(pointSize: 14, weight: .bold))?
            .applyingSymbolConfiguration(.init(hierarchicalColor: .secondaryLabel)), for: .normal)
        input.addSubview(cancel)
        
        let done = UIButton(primaryAction: .init { [weak self] _ in
            self?.done()
        })
        done.translatesAutoresizingMaskIntoConstraints = false
        done.setImage(.init(systemName: "arrow.forward")?
            .applyingSymbolConfiguration(.init(pointSize: 14, weight: .bold))?
            .applyingSymbolConfiguration(.init(hierarchicalColor: .secondaryLabel)), for: .normal)
        input.addSubview(done)
        
        background.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 55).isActive = true
        background.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor, constant: -55).isActive = true
        background.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
        background.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        field.centerYAnchor.constraint(equalTo: input.centerYAnchor, constant: 3).isActive = true
        field.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 12).isActive = true
        field.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -6).isActive = true
        
        cancel.centerYAnchor.constraint(equalTo: input.centerYAnchor, constant: 3).isActive = true
        cancel.rightAnchor.constraint(equalTo: background.leftAnchor).isActive = true
        cancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cancel.heightAnchor.constraint(equalTo: cancel.widthAnchor).isActive = true
        
        done.centerYAnchor.constraint(equalTo: input.centerYAnchor, constant: 3).isActive = true
        done.leftAnchor.constraint(equalTo: background.rightAnchor).isActive = true
        done.widthAnchor.constraint(equalToConstant: 50).isActive = true
        done.heightAnchor.constraint(equalTo: done.widthAnchor).isActive = true
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        DispatchQueue.main.async { [weak self] in
            self?.session.typing = true
            self?.field.becomeFirstResponder()
        }
        return super.becomeFirstResponder()
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
        session.typing = false
        field.text = ""
    }
    
    func insertText(_: String) {
        
    }
    
    func deleteBackward() {
        
    }
    
    private func done() {
        session.search(string: field.text!)
        field.resignFirstResponder()
    }
}
