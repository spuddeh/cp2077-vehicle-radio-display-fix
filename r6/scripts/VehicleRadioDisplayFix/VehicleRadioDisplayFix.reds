// ======================================================================================
// Mod Name: Vehicle Radio Display Fix
// Author: Spuddeh
// Description: The car's radio display shows the station that is playing, and whether the
//              radio is on. The display reads two values on the vehicle's blackboard, and the
//              game writes them only when a station is picked or the radio key is pressed. When
//              the player gets in, the Radioport hands its station to the car by setting the
//              receiver directly and the car resumes its last station the same way, so the
//              display keeps whatever it showed last. This writes both values from the receiver
//              after each of those moments, whenever the engine reports the station changing,
//              and twice more on a timer so the order the mount handlers run in never matters.
// File Version: 1.0.0
// Credits: psiberx (Codeware), DigitalVixen (RedLogger)
// ======================================================================================

module VehicleRadioDisplayFix

@if(ModuleExists("RedLogger"))
import RedLogger.*

@if(ModuleExists("RedLogger"))
public func VRDFLog(msg: String) -> Void {
  RedLog.Append("VehicleRadioDisplayFix", msg);
}

@if(!ModuleExists("RedLogger"))
public func VRDFLog(msg: String) -> Void {}

// Writes the display's two values from the receiver: on or off, and the station name. The
// component's own flag is written too, because the radio key reads it to decide whether a press
// cycles or switches on.
public func VRDF_Sync(vehicle: wref<VehicleObject>, reason: String) -> Void {
  if !IsDefined(vehicle) { return; }
  let board = vehicle.GetBlackboard();
  if !IsDefined(board) { return; }
  let defs = GetAllBlackboardDefs().Vehicle;
  let active: Bool = vehicle.IsRadioReceiverActive();
  let component = vehicle.GetVehicleComponent();
  if IsDefined(component) {
    component.m_radioState = active;
  }
  board.SetBool(defs.VehRadioState, active);
  if active {
    let name: CName = vehicle.GetRadioReceiverStationName();
    board.SetName(defs.VehRadioStationName, name);
    VRDFLog(s"\(reason): radio on, display set to \(name)");
  } else {
    VRDFLog(s"\(reason): radio off");
  }
}

public class VRDFSyncTick extends DelayCallback {
  public let vehicle: wref<VehicleObject>;
  public let reason: String;

  public func Call() -> Void {
    VRDF_Sync(this.vehicle, this.reason);
  }
}

public func VRDF_SyncLater(vehicle: wref<VehicleObject>, seconds: Float, reason: String) -> Void {
  if !IsDefined(vehicle) { return; }
  let delay = GameInstance.GetDelaySystem(vehicle.GetGame());
  if !IsDefined(delay) { return; }
  let tick = new VRDFSyncTick();
  tick.vehicle = vehicle;
  tick.reason = reason;
  delay.DelayCallback(tick, seconds);
}

// The engine tells the player when the receiver's station changes, whoever changed it. A station
// memory mod that sets the receiver directly, a second or more after mounting, is caught here.
@wrapMethod(PlayerPuppet)
protected cb func OnVehicleRadioStationChanged(evt: ref<VehicleRadioStationChanged>) -> Bool {
  let result: Bool = wrappedMethod(evt);
  VRDF_Sync(this.GetMountedVehicle(), "station changed");
  return result;
}

// The Radioport hands its station to the car here, by setting the receiver directly.
@wrapMethod(PocketRadio)
public final func HandleVehicleMounted(vehicle: wref<VehicleObject>) -> Void {
  wrappedMethod(vehicle);
  VRDF_Sync(vehicle, "Radioport handoff");
}

// The car's own mount handler, after which the receiver may have resumed its last station. The
// delayed pass catches whichever of the two handlers ran second.
@wrapMethod(VehicleComponent)
protected cb func OnMountingEvent(evt: ref<MountingEvent>) -> Bool {
  let result: Bool = wrappedMethod(evt);
  let vehicle = this.GetVehicle();
  if IsDefined(this.m_mountedPlayer) && IsDefined(vehicle) && VehicleComponent.IsDriverSlot(evt.request.lowLevelMountingInfo.slotId.id) {
    VRDF_Sync(vehicle, "mounting");
    VRDF_SyncLater(vehicle, 0.3, "after mounting");
    VRDF_SyncLater(vehicle, 1.5, "after settling");
  }
  return result;
}
