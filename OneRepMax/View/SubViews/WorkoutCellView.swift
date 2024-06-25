//
//  WorkoutCellView.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI



struct WorkoutCellView: View {
    let workoutHistorical: WorkoutHistorical
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
                Text(workoutHistorical.exercise)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("One Rep Max * lbs")
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .center) {
                Text("\(workoutHistorical.maxOneRM)")
                    .font(.title2)
                    .fontWeight(.bold)
                Image(systemName: workoutHistorical.favorite ? "star.fill" : "star")
                    .foregroundColor(workoutHistorical.favorite ? .yellow : .black)
                    .onTapGesture { workoutHistorical.favorite.toggle() }
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    LoadingPreviewProxy {
        ZStack {
            Color.gray
            VStack {
                WorkoutCellView(workoutHistorical: .init(exercise: "Brench", 
                                                         maxOneRM: 234))
                .padding()
                WorkoutCellView(workoutHistorical: .init(exercise: "Chest",
                                                         maxOneRM: 126,
                                                         favorite: true))
                .padding()
                .padding([.horizontal, .bottom])
            }
        }
        .ignoresSafeArea()
    }
    .previewDevice("iPhone 13 mini")
    .previewDisplayName("iPhone 13 mini")
}
