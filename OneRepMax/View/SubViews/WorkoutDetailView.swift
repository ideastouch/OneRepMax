//
//  CompanyDetailView.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//

import SwiftUI

struct WorkoutDetaillView: View {
    var workout: WorkoutHistorical
    var body: some View {
        VStack {
//            Image(systemName:"building")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(maxWidth: 100, maxHeight: 100)
//                .padding(.trailing, 20)
            VStack {
                HStack {
                    Text(Workout.exercise)
                    Spacer()
                    Image(systemName: workout.favorite ? "star.fill" : "star")
                        .foregroundColor(workout.favorite ? .yellow : .black)
                        .onTapGesture {
                            workout.favorite.toggle()
                        }
                }
                .padding(.bottom)
                HStack {
                    Text("Company Symbol:")
                    Spacer()
                    Text(company.symbol)
                }
                .padding(.bottom)
                HStack {
                    Text("Market Cap FMT:")
                    Spacer()
                    Text(company.marketCap.fmt)
                }
                .padding(.bottom)
            }
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    CompanyDetailView(
        company: .init(symbol: "MSFT",
                       name: "Microsoft Corporation",
                       favorite: false,
                       marketCap: .init(fmt: "2.572T",
                                        longFmt: "2,571,783,372,800",
                                        raw: 2571783372800))
    )
}
