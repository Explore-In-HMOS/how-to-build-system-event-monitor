import { MonitorState } from '../model/MonitorState';

function dotColor(state: MonitorState): string {
  if (state === MonitorState.LISTENING) {
    return '#34C759';
  }
  return '#F04A4A';
}

@Component
export struct StatusChip {
  @Prop state: MonitorState;

  build() {
    Circle({ width: 8, height: 8 })
      .fill(dotColor(this.state))
  }
}
