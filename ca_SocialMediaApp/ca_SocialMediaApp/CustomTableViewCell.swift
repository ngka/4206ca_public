import UIKit

class CustomTableViewCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(customImageView)
        addSubview(locationLabel)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            customImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            customImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            customImageView.heightAnchor.constraint(equalToConstant: 240),
            
            locationLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        print("titleLabel: \(titleLabel.frame)")
        print("customImageView: \(customImageView.frame)")
        print("locationLabel: \(locationLabel.frame)")
        print("dateLabel: \(dateLabel.frame)")
    }
}
