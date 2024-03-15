//
//  BottomSheetView.swift
//  HardSwiftUIMap
//
//  Created by Артём Черныш on 15.03.24.
//

import SwiftUI

struct BottomSheet: View {
    
    @State
    private var bottomSheetShown = false
    
    @Binding
    var annotation: Annotation?
    
    var body: some View {
        if let annotation {
            GeometryReader { geometry in
                BottomSheetView(
                    activeAnnotation: $annotation,
                    maxHeight: geometry.size.height
                ) {
                    ZStack {
                        //Color.blue
                        Text(annotation.id.uuidString)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let indicatorHeight: CGFloat = 6
    static let indicatorWidth: CGFloat = 60
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0.5
}

private struct BottomSheetView<Content: View>: View {
    
    @State
    private var bottomSheetShown = false
    
    @Binding
    var activeAnnotation: Annotation?

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState
    private var translation: CGFloat = 0

    private var offset: CGFloat {
        bottomSheetShown ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.radius)
                .fill(Color.secondary)
                .frame(
                    width: Constants.indicatorWidth,
                    height: Constants.indicatorHeight
                ).onTapGesture {
                    self.bottomSheetShown.toggle()
                }
            if !bottomSheetShown {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            activeAnnotation = nil
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.secondary)
                    })
                    .padding(.horizontal, 6)
                }
            }
        }
    }

    init(activeAnnotation: Binding<Annotation?>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._activeAnnotation = activeAnnotation
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator
                    .padding(Constants.indicatorHeight)
                self.content
                    .frame(height: (maxHeight - (Constants.indicatorHeight * 3)) - (self.offset + self.translation))
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(.ultraThinMaterial)
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.bottomSheetShown = value.translation.height < 0
                }
            )
        }
    }
}
