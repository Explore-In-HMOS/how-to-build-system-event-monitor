export type EventSeverity = 'info' | 'warn' | 'critical';

export interface EventRecord {
  id: string;
  action: string;
  label: string;
  timestamp: string;
  detail: string;
  severity: EventSeverity;
}
