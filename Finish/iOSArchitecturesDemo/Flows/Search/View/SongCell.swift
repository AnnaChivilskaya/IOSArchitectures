//
//  SongCell.swift
//  iOSArchitecturesDemo
//
//  Created by Аня on 15.06.2022.
//  Copyright © 2022 ekireev. All rights reserved.
//

import UIKit

final class SongCell: UITableViewCell {

    
    private(set) lazy var trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private(set) lazy var albumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13.0)
        return label
    }()
    
    private(set) lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12.0)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    
    func configure(with cellModel: SongCellModel) {
        self.trackNameLabel.text = cellModel.trackName
        self.albumLabel.text = cellModel.album
        self.artistLabel.text = cellModel.artist
    }
    
    
    override func prepareForReuse() {
        [self.trackNameLabel, self.albumLabel, self.artistLabel].forEach { $0.text = nil }
    }
    
    private func configureUI() {
        self.addTrackNameLabel()
        self.addAlbumLabel()
        self.addArtistLabel()
    }
    
    private func addTrackNameLabel() {
        self.contentView.addSubview(self.trackNameLabel)
        NSLayoutConstraint.activate([
            self.trackNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            self.trackNameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
            self.trackNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
        ])
    }
    
    private func addAlbumLabel() {
        self.contentView.addSubview(self.albumLabel)
        NSLayoutConstraint.activate([
            self.albumLabel.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 4.0),
            self.albumLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
            self.albumLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
        ])
    }
    
    private func addArtistLabel() {
        self.contentView.addSubview(self.artistLabel)
        NSLayoutConstraint.activate([
            self.artistLabel.topAnchor.constraint(equalTo: self.albumLabel.bottomAnchor, constant: 4.0),
            self.artistLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
            self.artistLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
        ])
    }
}
