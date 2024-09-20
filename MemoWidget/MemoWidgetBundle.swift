//
//  MemoWidgetBundle.swift
//  MemoWidget
//
//  Created by 김동현 on 9/20/24.
//

import WidgetKit
import SwiftUI

@main
struct MemoWidgetBundle: WidgetBundle {
    var body: some Widget {
        MemoWidget()
        MemoWidgetLiveActivity()
    }
}
