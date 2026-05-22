import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { CUSTOM_PING_ACTION, describeAction, ActionLabel, SUBSCRIBED_ACTIONS }
  from '../constants/EventActions';
import { EventRecord } from '../model/EventRecord';
import { formatHHmmss, nextRecordId } from '../utils/Formatters';

const LOG_DOMAIN: number = 0xA001;
const LOG_TAG: string = 'CommonEventService';

export type EventCallback = (record: EventRecord) => void;
export type ErrorCallback = (message: string) => void;
export type PublishResultCallback = (ok: boolean, message: string) => void;

function detailFromData(data: commonEventManager.CommonEventData): string {
  const parts: string[] = [];
  if (data.code !== undefined && data.code !== 0) {
    parts.push(`code=${data.code}`);
  }
  if (data.data !== undefined && data.data.length > 0) {
    parts.push(data.data);
  }
  return parts.join(' • ');
}

function toRecord(data: commonEventManager.CommonEventData): EventRecord {
  const action: string = data.event;
  const meta: ActionLabel = describeAction(action);
  return {
    id: nextRecordId(),
    action: action,
    label: meta.label,
    timestamp: formatHHmmss(Date.now()),
    detail: detailFromData(data),
    severity: meta.severity
  };
}

export class CommonEventService {
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;

  public start(onEvent: EventCallback, onError: ErrorCallback): void {
    if (this.subscriber !== null) {
      return;
    }
    const info: commonEventManager.CommonEventSubscribeInfo = {
      events: SUBSCRIBED_ACTIONS
    };
    try {
      commonEventManager.createSubscriber(info,
        (createErr: BusinessError, sub: commonEventManager.CommonEventSubscriber) => {
          if (createErr) {
            hilog.error(LOG_DOMAIN, LOG_TAG,
              'createSubscriber failed: %{public}s', JSON.stringify(createErr));
            onError(`Subscribe init failed (${createErr.code})`);
            return;
          }
          this.subscriber = sub;
          try {
            commonEventManager.subscribe(sub,
              (subErr: BusinessError, data: commonEventManager.CommonEventData) => {
                if (subErr) {
                  hilog.error(LOG_DOMAIN, LOG_TAG,
                    'subscribe error: %{public}s', JSON.stringify(subErr));
                  onError(`Receive failed (${subErr.code})`);
                  return;
                }
                onEvent(toRecord(data));
              });
          } catch (err) {
            const e: BusinessError = err as BusinessError;
            hilog.error(LOG_DOMAIN, LOG_TAG,
              'subscribe threw: %{public}s', JSON.stringify(e));
            onError(`Subscribe failed (${e.code})`);
          }
        });
    } catch (err) {
      const e: BusinessError = err as BusinessError;
      hilog.error(LOG_DOMAIN, LOG_TAG,
        'createSubscriber threw: %{public}s', JSON.stringify(e));
      onError(`Subscribe failed (${e.code})`);
    }
  }

  public stop(): void {
    const current: commonEventManager.CommonEventSubscriber | null = this.subscriber;
    if (current === null) {
      return;
    }
    this.subscriber = null;
    try {
      commonEventManager.unsubscribe(current, (err: BusinessError) => {
        if (err) {
          hilog.warn(LOG_DOMAIN, LOG_TAG,
            'unsubscribe error: %{public}s', JSON.stringify(err));
        }
      });
    } catch (err) {
      const e: BusinessError = err as BusinessError;
      hilog.warn(LOG_DOMAIN, LOG_TAG,
        'unsubscribe threw: %{public}s', JSON.stringify(e));
    }
  }

  public publishCustom(onResult: PublishResultCallback): void {
    const payload: commonEventManager.CommonEventPublishData = {
      code: 0,
      data: 'ping'
    };
    try {
      commonEventManager.publish(CUSTOM_PING_ACTION, payload, (err: BusinessError) => {
        if (err) {
          hilog.error(LOG_DOMAIN, LOG_TAG,
            'publish error: %{public}s', JSON.stringify(err));
          onResult(false, `Publish failed (${err.code})`);
          return;
        }
        onResult(true, 'Sent');
      });
    } catch (err) {
      const e: BusinessError = err as BusinessError;
      hilog.error(LOG_DOMAIN, LOG_TAG,
        'publish threw: %{public}s', JSON.stringify(e));
      onResult(false, `Publish failed (${e.code})`);
    }
  }

  public dispose(): void {
    this.stop();
  }

  public isActive(): boolean {
    return this.subscriber !== null;
  }
}

export const commonEventService: CommonEventService = new CommonEventService();
