import { EventCard } from '../components/EventCard';
import { EmptyFeed } from '../components/EmptyFeed';
import { PrimaryActionButton } from '../components/PrimaryActionButton';
import { StatusChip } from '../components/StatusChip';
import { EventRecord } from '../model/EventRecord';
import { MonitorState } from '../model/MonitorState';
import { commonEventService } from '../services/CommonEventService';
import {
  ACTION_LABEL_PING,
  ACTION_LABEL_RETRY,
  ACTION_LABEL_START,
  ACTION_LABEL_STOP,
  COPY_PUBLISH_FAIL,
  COPY_PUBLISH_OK,
  COPY_TITLE,
  FEEDBACK_AUTO_HIDE_MS,
  MAX_FEED_LENGTH,
  WATCH_CONTENT_WIDTH,
  WATCH_PADDING_BOTTOM,
  WATCH_PADDING_HORIZONTAL,
  WATCH_PADDING_TOP
} from '../constants/UiConstants';

@Component
export struct MainPage {
  @State private events: EventRecord[] = [];
  @State private monitorState: MonitorState = MonitorState.IDLE;
  @State private lastError: string = '';
  @State private publishFeedback: string = '';
  @State private inFlight: boolean = false;
  private feedbackTimer: number = -1;

  private primaryLabel(): string {
    if (this.monitorState === MonitorState.LISTENING) {
      return ACTION_LABEL_STOP;
    }
    if (this.monitorState === MonitorState.ERROR) {
      return ACTION_LABEL_RETRY;
    }
    return ACTION_LABEL_START;
  }

  private pushRecord(record: EventRecord): void {
    const next: EventRecord[] = [record, ...this.events];
    if (next.length > MAX_FEED_LENGTH) {
      next.length = MAX_FEED_LENGTH;
    }
    this.events = next;
  }

  private clearFeedbackLater(): void {
    if (this.feedbackTimer !== -1) {
      clearTimeout(this.feedbackTimer);
    }
    this.feedbackTimer = setTimeout(() => {
      this.publishFeedback = '';
      this.feedbackTimer = -1;
    }, FEEDBACK_AUTO_HIDE_MS);
  }

  private onPrimaryTap(): void {
    if (this.inFlight) {
      return;
    }
    if (this.monitorState === MonitorState.LISTENING) {
      this.inFlight = true;
      commonEventService.stop();
      this.monitorState = MonitorState.IDLE;
      this.lastError = '';
      this.inFlight = false;
      return;
    }
    this.inFlight = true;
    this.lastError = '';
    commonEventService.start(
      (record: EventRecord): void => {
        this.pushRecord(record);
      },
      (message: string): void => {
        this.monitorState = MonitorState.ERROR;
        this.lastError = message;
        this.inFlight = false;
      }
    );
    this.monitorState = MonitorState.LISTENING;
    this.inFlight = false;
  }

  private onPingTap(): void {
    if (this.monitorState !== MonitorState.LISTENING) {
      return;
    }
    commonEventService.publishCustom((ok: boolean, message: string): void => {
      if (ok) {
        this.publishFeedback = COPY_PUBLISH_OK;
      } else {
        this.publishFeedback = COPY_PUBLISH_FAIL;
        this.lastError = message;
      }
      this.clearFeedbackLater();
    });
  }

  aboutToDisappear(): void {
    if (this.feedbackTimer !== -1) {
      clearTimeout(this.feedbackTimer);
      this.feedbackTimer = -1;
    }
  }

  build() {
    Column() {
      Column({ space: 3 }) {
        Text(COPY_TITLE)
          .fontSize(13)
          .fontColor('#EAEAEA')
          .textAlign(TextAlign.Center)
          .maxLines(1)
        StatusChip({ state: this.monitorState })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .margin({ bottom: 4 })

      if (this.events.length === 0) {
        EmptyFeed()
          .layoutWeight(1)
      } else {
        List({ space: 0 }) {
          ForEach(this.events, (item: EventRecord) => {
            ListItem() {
              EventCard({
                label: item.label,
                timestamp: item.timestamp,
                detail: item.detail,
                severity: item.severity
              })
            }
          }, (item: EventRecord) => item.id)
        }
        .layoutWeight(1)
        .width('100%')
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }

      if (this.lastError.length > 0) {
        Text(this.lastError)
          .fontSize(11)
          .fontColor('#F08585')
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .margin({ top: 4 })
          .width('100%')
      } else if (this.publishFeedback.length > 0) {
        Text(this.publishFeedback)
          .fontSize(11)
          .fontColor('#7CE2A2')
          .textAlign(TextAlign.Center)
          .margin({ top: 4 })
          .width('100%')
      }

      Column({ space: 4 }) {
        PrimaryActionButton({
          label: this.primaryLabel(),
          disabled: this.inFlight,
          emphasis: 'primary',
          onTap: (): void => {
            this.onPrimaryTap();
          }
        })
        PrimaryActionButton({
          label: ACTION_LABEL_PING,
          disabled: this.monitorState !== MonitorState.LISTENING,
          emphasis: 'secondary',
          onTap: (): void => {
            this.onPingTap();
          }
        })
      }
      .width(WATCH_CONTENT_WIDTH)
      .margin({ top: 4 })
    }
    .width('100%')
    .height('100%')
    .padding({
      left: WATCH_PADDING_HORIZONTAL,
      right: WATCH_PADDING_HORIZONTAL,
      top: WATCH_PADDING_TOP,
      bottom: WATCH_PADDING_BOTTOM
    })
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#000000')
  }
}
