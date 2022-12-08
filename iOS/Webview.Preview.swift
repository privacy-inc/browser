import UIKit

extension Webview {
    final class Preview: UIViewController {
        required init?(coder: NSCoder) { nil }
        init(url: URL) {
            super.init(nibName: nil, bundle: nil)
            view.backgroundColor = .tertiarySystemBackground
            preferredContentSize.height = 90
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = url.absoluteString
            label.numberOfLines = 0
            label.adjustsFontForContentSizeCategory = true
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            label.textColor = .label
            label.font = .preferredFont(forTextStyle: .title3)
            label.lineBreakMode = .byTruncatingTail
            view.addSubview(label)
            
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
            label.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20).isActive = true
            label.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20).isActive = true
        }
    }
}
