//
//  WeatherDataSource.swift
//  weatherapp
//
//  Created by Denis Gavrilenko on 11/18/19.
//  Copyright © 2019 Denis. All rights reserved.
//

import UIKit

extension Weather {
    class WeatherDataSource<Item, Cell: UITableViewCell>: NSObject, UITableViewDataSource {
        private let items: [Item]
        private let cellID: String
        private let config: (Cell, Item) -> ()

        init(items: [Item], cellID: String, config: @escaping (Cell, Item) -> ()) {
            self.items = items
            self.cellID = cellID
            self.config = config
            super.init()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! Cell
            config(cell, items[indexPath.row])
            return cell
        }
    }
}
