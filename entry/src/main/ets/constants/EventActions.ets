import { commonEventManager } from '@kit.BasicServicesKit';

export const CUSTOM_PING_ACTION: string =
  'com.hmosdemos.wearable.event_monitor.CUSTOM_PING';

export const SUBSCRIBED_ACTIONS: string[] = [
  commonEventManager.Support.COMMON_EVENT_BATTERY_LOW,
  commonEventManager.Support.COMMON_EVENT_BATTERY_OKAY,
  commonEventManager.Support.COMMON_EVENT_POWER_CONNECTED,
  commonEventManager.Support.COMMON_EVENT_POWER_DISCONNECTED,
  commonEventManager.Support.COMMON_EVENT_SCREEN_ON,
  commonEventManager.Support.COMMON_EVENT_SCREEN_OFF,
  commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED,
  commonEventManager.Support.COMMON_EVENT_CONNECTIVITY_CHANGE,
  CUSTOM_PING_ACTION
];

export interface ActionLabel {
  label: string;
  severity: 'info' | 'warn' | 'critical';
}

export function describeAction(action: string): ActionLabel {
  if (action === commonEventManager.Support.COMMON_EVENT_BATTERY_LOW) {
    return { label: 'Battery low', severity: 'warn' };
  }
  if (action === commonEventManager.Support.COMMON_EVENT_BATTERY_OKAY) {
    return { label: 'Battery okay', severity: 'info' };
  }
  if (action === commonEventManager.Support.COMMON_EVENT_POWER_CONNECTED) {
    return { label: 'Power connected', severity: 'info' };
  }
  if (action === commonEventManager.Support.COMMON_EVENT_POWER_DISCONNECTED) {
    return { label: 'Power disconnected', severity: 'info' };
  }
  if (action === commonEventManager.Support.COMMON_EVENT_SCREEN_ON) {
    return { label: 'Screen on', severity: 'info' };
  }
  if (action === commonEventManager.Support.COMMON_EVENT_SCREEN_OFF) {
    return { label: 'Screen off', severity: 'info' };
  }
  if (action === commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED) {
    return { label: 'Timezone changed', severity: 'info' };
  }
  if (action === commonEventManager.Support.COMMON_EVENT_CONNECTIVITY_CHANGE) {
    return { label: 'Connectivity', severity: 'info' };
  }
  if (action === CUSTOM_PING_ACTION) {
    return { label: 'Custom ping', severity: 'info' };
  }
  return { label: action, severity: 'info' };
}
