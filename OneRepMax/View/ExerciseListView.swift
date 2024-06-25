//
//  WorkoutListView.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI
import SwiftData

struct ExerciseListView: View {
    @Query private var workoutHistoricalList: [WorkoutHistorical]
    @State var emptyList: String
    init(emptyList: String,
         sortSelection: SortSelection, filter: String) {
        self.emptyList = emptyList
        let predicate = #Predicate<WorkoutHistorical> {
            $0.exercise.localizedStandardContains(filter)
            || filter.isEmpty
        }
        let predicateFavorities = #Predicate<WorkoutHistorical> {
            $0.favorite == true
            && (
                $0.exercise.localizedStandardContains(filter)
                || filter.isEmpty
                )
        }
        switch sortSelection {
        case .NoOrder:
            _workoutHistoricalList = Query(filter: predicate,
                                 animation: .bouncy)
        case .Name:
            _workoutHistoricalList = Query(filter: predicate,
                                 sort: [SortDescriptor(\WorkoutHistorical.exercise)],
                                 animation: .bouncy)
        case .Load:
            _workoutHistoricalList = Query(filter: predicate,
                                 sort: [SortDescriptor(\WorkoutHistorical.maxOneRM)],
                                 animation: .bouncy)
        case .LoadRevert:
            _workoutHistoricalList = Query(filter: predicate,
                                 sort: [SortDescriptor(\WorkoutHistorical.maxOneRM)],
                                 animation: .bouncy)
        case .Favorities:
            _workoutHistoricalList = Query(filter: predicateFavorities,
                                 animation: .bouncy)
        }
    }
    var body: some View {
        Group {
            if workoutHistoricalList.isEmpty {
                VStack {
                    Text(emptyList)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.blue)
                        .padding()
                    Spacer()
                }
                
            } else {
                List {
                    ForEach(workoutHistoricalList) { workoutHistorical in
                        NavigationLink {
                            WorkoutDetailView(workoutHistorical: workoutHistorical)
                                .padding()
                                
                        } label: {
                            WorkoutCellView(workoutHistorical: workoutHistorical)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .padding(.vertical)
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    @State var sortSelection: SortSelection = .NoOrder
    @State var filterBy: String = .init()
    return LoadingPreviewProxy {
        ExerciseListView(
            emptyList:"There are not exercises listed at the moment",
            sortSelection: sortSelection,
            filter: filterBy)
    }
}
