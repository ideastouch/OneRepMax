//
//  WorkoutDetailView.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI
import SwiftUIExt
import SwiftData

struct WorkoutDetailView: View {
    let workoutHistorical: WorkoutHistorical
    @State private var yDomainRange: YDomainRange = .fullRange
    init(workoutHistorical: WorkoutHistorical) {
        self.workoutHistorical = workoutHistorical
    }
    var body: some View {
        VStack(alignment: .leading) {
            BackButton()
            
            WorkoutCellView(workoutHistorical: workoutHistorical)
                .padding(.vertical)
            
            axisYDomainPicker()
            
            WorkoutChart(exercise: workoutHistorical.exercise,
                         yDomainRange: yDomainRange)
            .animation(.easeIn, value: yDomainRange)
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }
}

extension WorkoutDetailView {
    private
    func axisYDomainPicker() -> some View {
        Picker("", selection: $yDomainRange) {
            ForEach(YDomainRange.allCases) { sortBy in
                Text(sortBy.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
}

fileprivate
struct Proxy: View {
    @Query private var workoutHistoricalList: [WorkoutHistorical]
    var body: some View {
        WorkoutDetailView(workoutHistorical: workoutHistoricalList.first ?? WorkoutHistorical(exercise: "Brench", maxOneRM: 245))
    }
}
#Preview("Detail View", traits: .sizeThatFitsLayout) {
    LoadingPreviewProxy {
        Proxy()
            .padding()
    }
}

