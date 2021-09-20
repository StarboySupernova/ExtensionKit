import Combine
import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
extension View {

    /// Self wrapped in an `UIHostingController`
    public var hosted: UIHostingController<Self> {
        return UIHostingController(rootView: self)
    }

    /// Fill frame height and width to the same length
    /// - Parameters:
    ///   - length: Length to set
    ///   - alignment: Aligment
    /// - Returns: View
    public func fillEqual(length: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: length, height: length, alignment: alignment)
    }

    /// Fill parent view
    /// - Parameter alignment: alignment
    /// - Returns: View with filled frame
    public func fillParent(alignment: Alignment = .center) -> some View {
        self
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: alignment
            )
    }

    /// Similar to distribuation fill on `UIStackView`, take up all availabe space of parent
    /// - Parameters:
    ///   - flexibleAxis: Axis to fill
    ///   - alignment: Alignment
    /// - Returns: View
    public func fillFlexible(
        _ flexibleAxis: Axis.Set = [.horizontal, .vertical],
        alignment: Alignment = .center
    ) -> some View {
        return frame(
            maxWidth: flexibleAxis.contains(.horizontal) ? .infinity : nil,
            maxHeight: flexibleAxis.contains(.vertical) ? .infinity : nil,
            alignment: alignment
        )
    }

    /// Embed Self in `NavigationView`
    /// - Returns: New view with `NavigationView` parent
    public func embedInNavigationView() -> some View {
        NavigationView { self }
    }

    /// Embed Self in `ScrollView`
    /// - Returns: New view with `ScrollView` parent
    public func embedInScrollView(
        _ axis: Axis.Set = .vertical,
        showsIndicators: Bool = false
    ) -> some View {
        ScrollView(axis, showsIndicators: showsIndicators) { self }
    }

    /**
    ```
     ForEach(0 ..< 5) { item in
         Rectangle()
             .foregroundColor(.random())
     }.embedInVerticalPagingTabView($selection)
    ```
     */
    /// Embed Self in vertically paging `TabView`
    /// - Parameters:
    ///   - selection: selection binding
    ///   - pageIndicators: show page indicators, default .always
    /// - Returns: View
    @available(iOS 14.0, *)
    public func embedInVerticalPagingTabView<Selection: Hashable>(
        _ selection: Binding<Selection>? = nil,
        pageIndicators: PageTabViewStyle.IndexDisplayMode = .never
    ) -> some View {
        GeometryReader { proxy in
            TabView(selection: selection) {
                self
                    .rotationEffect(.degrees(-90))  // Rotate content
                    .frame(
                        width: proxy.localWidth,
                        height: proxy.localHeight
                    )
            }
            .frame(
                width: proxy.localHeight,
                height: proxy.localWidth
            )
            .rotationEffect(.degrees(90), anchor: .topLeading)  // Rotate TabView
            .offset(x: proxy.localWidth)  // Offset back into screens bounds
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: pageIndicators)
            )
        }
    }

    /// Round view with specific corners
    /// - Parameters:
    ///   - radius: radius
    ///   - corners: corners to round
    /// - Returns: new rounded view
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    /// Center a view in parent local coor space
    /// - Parameter alignment: aligment of centered view
    /// - Returns: new view
    public func center(alignment: Alignment = .center) -> some View {
        GeometryReader { proxy in
            self
                .frame(width: proxy.localFrame.midX, height: proxy.localFrame.midY, alignment: alignment)
        }
    }

    /// Erase view to `AnyView`
    /// - Returns: new view
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }

    /// Hides the view conditionally
    /// - Parameter hidden: is hidden
    /// - Returns: hidden view but not drawn on screen
    @ViewBuilder
    public func hide(if hidden: Bool) -> some View {
        switch hidden {
        case true: self.hidden()
        case false: self
        }
    }

    /// Loading shimmer animation on view
    /// - Parameters:
    ///   - isActive: is shimmer animation active
    ///   - speed: speed, default: 0.15
    ///   - angle: angle of animation, default: 70º
    /// - Returns: View
    public func shimmer(
        isActive: Bool = true,
        speed: Double = 0.15,
        angle: Angle = .init(degrees: 70)
    ) -> some View {

        let view = ShimmerModifier(
            isActive: isActive,
            speed: speed,
            angle: angle
        )

        return self.modifier(view)
    }

    /// Add animating circles to view
    /// - Parameters:
    ///   - isActive: is animation active
    ///   - circleColor: circle foreground color
    /// - Returns: View
    public func circleMotion(
        isActive: Bool = true,
        circleColor: Color = .gray
    ) -> some View {

        let view = CircleMotionModifier(
            isActive: isActive,
            circleColor: circleColor
        )

        return self.modifier(view)
    }

    /// Overlay border on view
    /// - Parameters:
    ///   - content: ShapeStyle view
    ///   - width: border width
    ///   - cornerRadius: corner radius
    /// - Returns: view
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S: ShapeStyle {
        return overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(content, lineWidth: width)
        )
    }

    /// Addd a `LinearGradient` overlayed on View
    /// - Parameters:
    ///   - colors: Colors
    ///   - start: Start, default top
    ///   - end: End, default bottom
    /// - Returns: View
    public func gradientOverlay(
        colors: Color...,
        start: UnitPoint = .top,
        end: UnitPoint = .bottom
    ) -> some View {
        overlay(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: start,
                endPoint: end
            )
        )
    }

    /// Addd a `LinearGradient` background on View
    /// - Parameters:
    ///   - colors: Colors
    ///   - start: Start, default top
    ///   - end: End, default bottom
    /// - Returns: View
    public func gradientBackground(
        colors: Color...,
        start: UnitPoint = .top,
        end: UnitPoint = .bottom
    ) -> some View {
        background(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: start,
                endPoint: end
            )
        )
    }

    /// Expand safe area on the background of the view
    /// - Parameters:
    ///   - backgroundView: view to ignore safe area
    ///   - safeAreaRegions: safe area regions
    ///   - edges: edges
    /// - Returns: View
    @available(iOS 14.0, *)
    public func safeArea<Background: View>(
        withBackground backgroundView: Background,
        safeAreaRegions: SafeAreaRegions = .all,
        edges: Edge.Set = .all
    ) -> some View {
        self.background(
            backgroundView.ignoresSafeArea(
                safeAreaRegions,
                edges: edges
            )
        )
    }

    /// Set Navigation bar background color and text
    /// - Parameters:
    ///   - background: background color
    ///   - text: text color
    /// - Returns: View
    public func navigationBarColors(background: UIColor, text: UIColor) -> some View {
        self.modifier(
            NavigationBarModifier(backgroundColor: background, textColor: text)
        )
    }

    /// Container that doesn’t leak outside the safe area, only the elements in its background
    /// - Parameters:
    ///   - alignment: alignment
    ///   - content: content
    /// - Returns: View
    public func background<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) -> some View {
        self.background(ZStack(alignment: alignment) { content() }, alignment: alignment)
    }

    /// Hide keyboard
    public func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    /// Receive keyboard status updates
    /// - Parameter isVisible: is keyboard visible
    /// - Returns: View
    public func keyboardState(info: Binding<KeyboardInfo>) -> some View {
        self
            .onNotification(UIApplication.keyboardWillShowNotification) { notif in
                info.wrappedValue.update(with: notif.userInfo)
            }
            .onNotification(UIApplication.keyboardWillHideNotification) { notif in
                info.wrappedValue = .init()
            }
    }

    /// Debug print
    /// - Parameter vars: item to print
    /// - Returns: View
    public func debugPrint(_ vars: Any...) -> some View {
        for v in vars { dprint(v) }
        return self
    }

    /// Debug action
    /// - Parameter closure: action
    /// - Returns: View
    public func debugAction(_ closure: () -> Void) -> Self {
        #if DEBUG
            closure()
        #endif
        return self
    }

    /// Debug visual modifier
    /// - Parameter modifier: View modifier
    /// - Returns: View
    public func debugModifier<T: View>(_ modifier: (Self) -> T) -> some View {
        #if DEBUG
            return modifier(self)
        #else
            return self
        #endif
    }

    /// Debug only border
    /// - Parameters:
    ///   - color: color
    ///   - width: width
    /// - Returns: View
    public func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
        debugModifier {
            $0.border(color, width: width)
        }
    }

    /// Debug only background
    /// - Parameter color: color
    /// - Returns: View
    public func debugBackground(_ color: Color = .red) -> some View {
        debugModifier {
            $0.background(color)
        }
    }

    /// Debug print view representation
    /// - Returns: Self after printing
    public func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }

    /// Repeat View n times
    /// - Parameter value: repeat upto not including
    /// - Returns: View
    public func times(_ value: UInt) -> some View {
        ForEach(0..<Int(value)) { _ in self }
    }

    /// Overlay View on content size
    /// - Parameter content: content size
    /// - Returns: View
    public func useSize<Content: View>(of content: @autoclosure () -> Content) -> some View {
        return content().hidden().overlay(self)
    }

    /// Subscribe and blind ouput to View property
    /// - Parameters:
    ///   - publisher: publisher
    ///   - binding: binding
    /// - Returns: View
    public func onReceive<P: Publisher>(_ publisher: P, assignTo binding: Binding<P.Output>) -> some View where P.Failure == Never {
        onReceive(publisher) { binding.wrappedValue = $0 }
    }

    /// Subscribe and blind optional ouput to View property
    /// - Parameters:
    ///   - publisher: publisher
    ///   - binding: binding
    /// - Returns: View
    public func onReceive<P: Publisher>(_ publisher: P, assignTo binding: Binding<P.Output?>) -> some View where P.Failure == Never {
        onReceive(publisher) { binding.wrappedValue = $0 }
    }

    /// Get the scroll view content offset X
    /// - Parameter offsetX: Binding for offset
    /// - Returns: View
    public func scrollOffset(_ offset: Binding<CGPoint>) -> some View {
        ScrollViewOffSetReaderRepresentable(offset: offset, isOffsetX: true) { self }
    }

    /// Add  foreground, background, shadow, cornerRadius to `Button` content
    /// - Parameters:
    ///   - titleColor: foreground color
    ///   - background: background color
    ///   - padding: padding
    ///   - shadow: shadow
    ///   - cornerRadius: corner radius
    /// - Returns: View
    public func shadowButton(
        titleColor: Color = .white,
        background: Color = .blue,
        padding: (edges: Edge.Set, length: CGFloat) = (.all, 10),
        shadow: (radius: CGFloat, alpha: CGFloat, y: CGFloat) = (10, 0.15, 4),
        cornerRadius: CGFloat = 10
    ) -> some View {
        self
            .foregroundColor(titleColor)
            .padding(padding.edges, padding.length)
            .background(background)
            .shadow(
                color: Color(UIColor(white: 0, alpha: shadow.radius)),
                radius: shadow.radius,
                x: 0,
                y: shadow.y
            )
            .cornerRadius(cornerRadius)
    }

    /// Subscribe to the given notification
    /// - Parameters:
    ///   - name: Notification name
    ///   - object: Object posting the notification
    ///   - action: Action to run when received
    /// - Returns: View
    public func onNotification(
        _ name: Notification.Name,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(NotificationCenter.default.publisher(for: name, object: object)) {
            action($0)
        }
    }

    /// Adds a bottom sheet to View
    /// - Parameters:
    ///   - isPresented: Binding for presenting the View
    ///   - height: Height, default .mid
    ///   - animation: Animation
    ///   - content: modal content
    /// - Returns: View
    public func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: Height = .mid,
        animation: Animation = .easeInOut(duration: 0.3),
        thumbHidden: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        return ZStack {
            self
            BottomSheet(
                isPresented: isPresented,
                height: height,
                animation: animation,
                thumbHidden: thumbHidden,
                content: content
            )
        }
    }

    /// Get the views frame in the global coordinate space
    /// - Parameter binding: Rect binding
    /// - Returns: View
    public func getRect(binding: Binding<CGRect>) -> some View {
        self.background(RectGetter(rect: binding))
    }

}
