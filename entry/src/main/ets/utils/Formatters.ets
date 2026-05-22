let idCounter: number = 0;

export function nextRecordId(): string {
  idCounter = idCounter + 1;
  return `${Date.now()}-${idCounter}`;
}

function pad2(value: number): string {
  if (value < 10) {
    return `0${value}`;
  }
  return `${value}`;
}

export function formatHHmmss(epochMs: number): string {
  const date: Date = new Date(epochMs);
  const hh: string = pad2(date.getHours());
  const mm: string = pad2(date.getMinutes());
  const ss: string = pad2(date.getSeconds());
  return `${hh}:${mm}:${ss}`;
}
