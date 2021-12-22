//
//  CGPoint+Extension.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}
