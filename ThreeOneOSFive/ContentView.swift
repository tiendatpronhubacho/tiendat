import SwiftUI

// Khai báo hàm từ file C/Obj-C để check quyền và load patch
@_silgen_name("MCMBridgeAvailable")
func checkSandboxStatus() -> Bool

@_silgen_name("load_patch_dylib")
func load_patch_dylib(_ patchName: NSString) -> Bool

struct ContentView: View {
    @State private var aimDragActive = false
    @State private var aimBodyActive = false
    
    // Gọi hàm kiểm tra thực tế từ nhân C
    @State private var isSandboxAvailable: Bool = checkSandboxStatus()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Red Grid Background
            GridBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HeaderView()
                    
                    // Device Status Card
                    DeviceStatusCard(
                        iosVersion: UIDevice.current.systemVersion,
                        deviceModel: getDeviceModel(),
                        isSupported: isSandboxAvailable
                    )
                    
                    // Patch Options Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("⚡ PATCH OPTIONS")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                            Text(isSandboxAvailable ? "SELECT TO ENABLE" : "ACCESS UNAVAILABLE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            PatchCard(
                                title: "Aim Drag",
                                subtitle: "FREE FIRE • NORMAL",
                                isActive: $aimDragActive,
                                isEnabled: isSandboxAvailable,
                                onToggle: { isOn in
                                    if isOn {
                                        let success = load_patch_dylib("Aim Drag" as NSString)
                                        print("Nạp Aim Drag: \(success)")
                                    }
                                }
                            )
                            PatchCard(
                                title: "Aim Body",
                                subtitle: "FREE FIRE • NORMAL",
                                isActive: $aimBodyActive,
                                isEnabled: isSandboxAvailable,
                                onToggle: { isOn in
                                    if isOn {
                                        let success = load_patch_dylib("Aim Body" as NSString)
                                        print("Nạp Aim Body: \(success)")
                                    }
                                }
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Status Footer
                    HStack(spacing: 8) {
                        Circle()
                            .fill(isSandboxAvailable ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(isSandboxAvailable ? "READY -- SELECT A PATCH" : "BLOCKED -- iOS SANDBOX ACCESS IS NOT AVAILABLE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(isSandboxAvailable ? .white : .gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Update Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.up.right.square.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                            Text("FREE FIRE VN MỚI UPDATE")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.red)
                        }
                        
                        Link(destination: URL(string: "freefirevn://")!) {
                            HStack {
                                Image(systemName: "arrow.up.right.square.fill")
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(Color.red)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("FREE FIRE VN MỚI UPDATE")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("Free Fire Việt Nam")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(white: 0.1))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.red.opacity(0.5), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
                .padding(.top, 20)
            }
        }
        .preferredColorScheme(.dark)
        // Cập nhật lại trạng thái khi view xuất hiện
        .onAppear {
            isSandboxAvailable = checkSandboxStatus()
        }
    }
    
    // Hàm lấy tên thiết bị (iPhone13,4)
    func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

// MARK: - Components
struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("TienDat")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                Text("PATCH CONTROL CENTER")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(2)
                    .foregroundColor(.red)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.red)
                    .padding(12)
                    .background(Color(white: 0.1))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.red, lineWidth: 1))
            }
        }
        .padding(.horizontal)
    }
}

struct DeviceStatusCard: View {
    let iosVersion: String
    let deviceModel: String
    let isSupported: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "shield.fill")
                    .foregroundColor(.red)
                Text("DEVICE STATUS")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "applelogo")
                        .foregroundColor(.white)
                        .frame(width: 24)
                    Text("iOS")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(iosVersion)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                HStack {
                    Image(systemName: "iphone")
                        .foregroundColor(.white)
                        .frame(width: 24)
                    Text("Device")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(deviceModel)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                
                HStack {
                    Image(systemName: isSupported ? "checkmark.shield.fill" : "exclamationmark.triangle.fill")
                        .foregroundColor(isSupported ? .green : .yellow)
                        .frame(width: 24)
                    Text(isSupported ? "Support" : "Patch access")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(isSupported ? "SUPPORTED" : "LIMITED -- SANDBOX ACCESS DISABLED")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(isSupported ? .green : .white)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding(20)
        .background(Color(white: 0.08))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red.opacity(0.6), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct PatchCard: View {
    let title: String
    let subtitle: String
    @Binding var isActive: Bool
    let isEnabled: Bool
    var onToggle: (Bool) -> Void // Thêm closure này để bắt sự kiện bật/tắt
    
    var body: some View {
        Button(action: {
            if isEnabled { 
                isActive.toggle() 
                onToggle(isActive) // Gọi hàm khi toggle
            }
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(isActive ? .red : .gray)
                    Spacer()
                    Text(isActive ? "ON" : "OFF")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isActive ? .green : .gray)
                }
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(isEnabled ? .white : .gray)
                
                Text(subtitle)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.red.opacity(0.8))
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(isActive ? Color.green : Color.gray)
                        .frame(width: 6, height: 6)
                    Text(isActive ? "ACTIVE" : "ACTIVATE PATCH")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isEnabled ? .white : .gray)
                }
                .padding(.top, 4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(white: 0.08))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isActive ? Color.red : Color.red.opacity(0.3), lineWidth: 1)
            )
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.6)
    }
}

struct GridBackground: View {
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let spacing: CGFloat = 40
                // Vertical lines
                for x in stride(from: 0, to: geo.size.width, by: spacing) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                }
                // Horizontal lines
                for y in stride(from: 0, to: geo.size.height, by: spacing) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                }
            }
            .stroke(Color.red.opacity(0.1), lineWidth: 1)
        }
    }
}