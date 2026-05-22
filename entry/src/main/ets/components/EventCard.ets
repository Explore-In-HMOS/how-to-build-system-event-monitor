import { EventSeverity } from '../model/EventRecord';

function dotColor(severity: EventSeverity): string {
  if (severity === 'warn') {
    return '#F5B547';
  }
  if (severity === 'critical') {
    return '#F08585';
  }
  return '#7CE2A2';
}

@Component
export struct EventCard {
  @Prop label: string;
  @Prop timestamp: string;
  @Prop detail: string;
  @Prop severity: EventSeverity;

  build() {
    Column() {
      Row() {
        Circle({ width: 6, height: 6 })
          .fill(dotColor(this.severity))
          .margin({ right: 6 })
        Text(this.label)
          .fontSize(13)
          .fontColor('#EAEAEA')
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.timestamp)
          .fontSize(10)
          .fontColor('#8A8A8A')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      if (this.detail.length > 0) {
        Text(this.detail)
          .fontSize(10)
          .fontColor('#8A8A8A')
          .margin({ top: 2 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
      }
    }
    .width('100%')
    .padding({ left: 8, right: 8, top: 6, bottom: 6 })
    .backgroundColor('#161616')
    .borderRadius(10)
    .margin({ bottom: 4 })
  }
}
