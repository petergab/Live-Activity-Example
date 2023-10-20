import ActivityKit
import WidgetKit
import SwiftUI
import Models

struct RaceWidgetLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: RaceWidgetAttributes.self) { context in
      // Lock screen definition
      ZStack {
        VStack {
          RoomInformation()
        }
        .padding()
      }
      .background(Color("WidgetBackground"))
      .foregroundColor(.white)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          HStack (alignment: .top) {
            Image("room")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 56, height: 56, alignment: .center)
              .clipped()
              .cornerRadius(10)
            VStack(alignment: .leading) {
              Text("Pankhurst").font(.system(size: 10))
              Text("Ground Floor").font(.system(size: 10))
            }
          }
        }
        DynamicIslandExpandedRegion(.trailing) {
          Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, alignment: .leading)
        }
        DynamicIslandExpandedRegion(.bottom) {
          HStack (alignment: .center) {
            Text(
              "Your booking ends in \(timerInterval: Date()...Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()) + 1, minute: 0, second: 0, of: Date())!, countsDown: true) min"
            )
              .font(.system(size: 14))
              .monospacedDigit()
            
            Spacer()
            
            Button(action: {}) {
              Text("EXTEND")
                .bold()
                .font(.system(size: 14))
            }
            .foregroundColor(Color("WidgetBackground"))
            .background(Color("AccentColor"))
            .cornerRadius(20)
          }
          
          TimelineView()
        }
      } compactLeading: {
        HStack (alignment: .center) {
          Image("room")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 36, height: 36, alignment: .center)
            .clipped()
            .cornerRadius(10)
          Text("Pankhurst")
            .font(.callout)
            .foregroundColor(Color("AccentColor"))
            .accessibilityLabel("Room: Pankhurst")
        }
      } compactTrailing: {
        Spacer()
        Text("\(timerInterval: Date()...Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()) + 1, minute: 0, second: 0, of: Date())!, countsDown: true)")
          .monospacedDigit()
          .accessibilityLabel("Remaining time \(timerInterval: Date()...Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()) + 1, minute: 0, second: 0, of: Date())!, countsDown: true)")
      } minimal: {
        Text(
          "\(timerInterval: Date()...Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()) + 1, minute: 0, second: 0, of: Date())!, countsDown: true)"
        )
          .foregroundColor(Color("AccentColor"))
      }
    }
  }
}

struct RoomInformation: View {
  var body: some View {
    HStack (alignment: .top) {
      Image("room")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 64, height: 64, alignment: .center)
        .clipped()
        .cornerRadius(10)
      VStack(alignment: .leading) {
        Text("Room: Pankhurst").font(.system(size: 14))
        Text("Floor: Ground Floor").font(.system(size: 14))
      }
      
      Spacer()
      
      Image("logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 120, alignment: .top)
    }
    
    HStack (alignment: .center) {
      Text(
        "Your booking ends in \(timerInterval: Date()...Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: Date()) + 1, minute: 0, second: 0, of: Date())!, countsDown: true) min"
      )
        .font(.system(size: 14))
        .monospacedDigit()
      
      Spacer()
      
      Button(action: {}) {
        Text("EXTEND")
          .bold()
          .font(.system(size: 14))
      }
      .foregroundColor(Color("WidgetBackground"))
      .background(Color("AccentColor"))
      .cornerRadius(20)
    }
    
    TimelineView()
  }
}

struct TimelineView: View {
    @State private var currentTime = Date()
    private let calendar = Calendar.current
    
    private var startOfPreviousHour: Date {
        calendar.date(bySetting: .minute, value: 0, of: calendar.date(byAdding: .hour, value: -1, to: currentTime)!)!
    }
    
    private var startOfNextHour: Date {
        calendar.date(bySetting: .minute, value: 0, of: calendar.date(byAdding: .hour, value: 0, to: currentTime)!)!
    }
    
    private var timeline: ClosedRange<Date> {
        startOfPreviousHour...startOfNextHour
    }
    
    private var currentPointerPosition: CGFloat {
        let totalInterval = startOfNextHour.timeIntervalSince(startOfPreviousHour)
        let currentInterval = currentTime.timeIntervalSince(startOfPreviousHour)
        let progress = CGFloat(currentInterval / totalInterval)
        return progress
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 6)
                        .cornerRadius(3)
                        .foregroundColor(.white)
                    
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color("AccentColor"))
                        .position(x: geometry.size.width * currentPointerPosition, y: 5)
                }
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                currentTime = Date()
            }
        }
    }
}

struct RaceLiveActivity_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RaceWidgetAttributes(
        track: Track.albertPark,
        raceStartTime: Date(timeIntervalSinceNow: -(60 * 30))
      )
      .previewContext(
        RaceWidgetAttributes.ContentState(
          raceOrder: RaceOrder.mock,
          fastestLap: FastestLap.mock,
          currentLapCount: 24,
          raceIsRunning: true
        ),
        viewKind: .content
      )
      
      RaceWidgetAttributes(
        track: Track.albertPark,
        raceStartTime: Date(timeIntervalSinceNow: -(60 * 30))
      )
      .previewContext(
        RaceWidgetAttributes.ContentState(
          raceOrder: RaceOrder.mock,
          fastestLap: FastestLap.mock,
          currentLapCount: 24,
          raceIsRunning: true
        ),
        viewKind: .dynamicIsland(.expanded)
      )
    }
  }
}
