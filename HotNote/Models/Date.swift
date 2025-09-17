//
//  Date.swift
//  HotNote
//
//  Created by Игорь Ущин on 06.07.2022.
//

import Foundation

extension Date {
    func format() -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "dd/MM/yy (HH:mm) -"
        } else {
            formatter.dateFormat = "dd/MM/yy (HH:mm) -"
        }
        return formatter.string(from: self)
    }
}
