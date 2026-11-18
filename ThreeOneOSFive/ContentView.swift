import SwiftUI

// Khai báo các hàm từ nhân C của 3105
@_silgen_name("MCMContainerPathForIdentifier")
func MCMContainerPathForIdentifier(_ cls: UInt64, _ identifier: NSString, _ group: Bool, _ error: UnsafeMutablePointer<NSString?>?) -> NSString?

@_silgen_name("sandbox_escape")
func sandbox_escape(_ self_proc: UInt64) -> Int32

struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    @State private var aimDragActive = false
    @State private var aimBodyActive = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            GridBackground().ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HeaderView()
                    
                    DeviceStatusCard(
                        iosVersion: UIDevice.current.systemVersion,
                        deviceModel: getDeviceModel(),
                        isSupported: appState.isSupported
                    )
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("⚡ PATCH OPTIONS")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                            Text(appState.isSupported ? "SELECT TO ENABLE" : "ACCESS UNAVAILABLE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            PatchCard(
                                title: "Aim Drag",
                                subtitle: "FREE FIRE • NORMAL",
                                isActive: $aimDragActive,
                                isEnabled: appState.isSupported,
                                onToggle: { isOn in
                                    if isOn { applyPatch(named: "Aim Drag") }
                                }
                            )
                            PatchCard(
                                title: "Aim Body",
                                subtitle: "FREE FIRE • NORMAL",
                                isActive: $aimBodyActive,
                                isEnabled: appState.isSupported,
                                onToggle: { isOn in
                                    if isOn { applyPatch(named: "Aim Body") }
                                }
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack(spacing: 8) {
                        Circle()
                            .fill(appState.isSupported ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(appState.isSupported ? "READY -- SELECT A PATCH" : "BLOCKED -- iOS SANDBOX ACCESS IS NOT AVAILABLE")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(appState.isSupported ? .white : .gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
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
                        
                        HStack(spacing: 6) {
                            Image(systemName: "message.fill")
                                .foregroundColor(.blue)
                                .font(.system(size: 14))
                            Text("LIÊN HỆ HỖ TRỢ")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 8)
                        
                        Link(destination: URL(string: "https://zalo.me/0986321175")!) {
                            HStack {
                                Image(systemName: "message.fill")
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("ZALO HỖ TRỢ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("0986321175")
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
                                    .stroke(Color.blue.opacity(0.5), lineWidth: 1)
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
        .onAppear {
            appState.detectSupport()
        }
    }
    
    // HÀM APPLY PATCH: DÙNG DLOPEN + SANDBOX ESCAPE
    func applyPatch(named patchName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            print("[Patch] Bắt đầu nạp: \(patchName)")
            
            // 1. Kích hoạt Sandbox Escape để lấy quyền ghi vào game
            if sandbox_escape(0) != 0 {
                print("[Patch] Lỗi: Không thể vượt Sandbox!")
                return
            }
            
            // 2. Lấy đường dẫn file patch từ Bundle
            guard let patchPath = Bundle.main.path(forResource: "\(patchName).3105", ofType: nil, inDirectory: "Patches") else {
                print("[Patch] Lỗi: Không tìm thấy file \(patchName).3105 trong thư mục Patches!")
                return
            }
            
            // 3. Tiến hành Inject thẳng vào game bằng dlopen
            // Thay 'inject_dylib' bằng hàm inject có sẵn trong nhân C của 3105 (nếu có)
            // Hoặc dùng cách nạp file dylib thủ công nếu 3105 hỗ trợ
            
            print("[Patch] Đang tiến hành inject: \(patchPath)")
            
            let handle = dlopen(patchPath, RTLD_NOW)
            if let handle = handle {
                print("[Patch] Nạp thành công file \(patchName)!")
                dlclose(handle)
            } else {
                let error = String(cString: dlerror())
                print("[Patch] Lỗi khi dlopen: \(error)")
            }
        }
    }
    
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
    var onToggle: (Bool) -> Void
    
    var body: some View {
        Button(action: {
            if isEnabled { 
                isActive.toggle() 
                onToggle(isActive) 
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
                for x in stride(from: 0, to: geo.size.width, by: spacing) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                }
                for y in stride(from: 0, to: geo.size.height, by: spacing) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                }
            }
            .stroke(Color.red.opacity(0.1), lineWidth: 1)
        }
    }
}