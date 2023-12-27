//
//  DeviceView.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import Components
import Design
import Localizations
import SwiftUI

struct DeviceView: View {
    @StateObject private var viewModel = DeviceViewModel()
    
    var body: some View {
        if viewModel.devices.isEmpty {
            Text("empty_devices_title".localized)
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.devices) { device in
                        
                        Tile(
                            variant: .device(
                                text: device.deviceName,
                                binding:
                                    Binding(
                                        get: { device.state },
                                        set: {
                                            viewModel.updateDeviceStatus(device: device, state: $0, messageOn: device.turnDeviceOnMessage, messageOff: device.turnDeviceOffMessage) }
                                    ),
                                symbol: device.symbol
                            )
                        )
                    }
                }
                .padding(15)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                Colors.safeAreaInset.ignoresSafeArea()
                    .frame(height: 0)
            }
            .safeAreaInset(edge: .bottom) {
                Colors.safeAreaInset.ignoresSafeArea()
                    .frame(maxHeight: 60)
            }
            .onAppear {
                viewModel.connectMqtt()
                viewModel.startTimer()
            }
            .onDisappear {
                viewModel.stopTimer()
            }
        }
    }
}

#Preview {
    DeviceView()
}
