class DurationState {
  final Duration progress;//Khởi tạo tiến trình
  final Duration buffered;//Vùng đệm load đến đâu
  final Duration? total;//Tổng thời gian

  const DurationState(
      {required this.progress, required this.buffered, this.total});
}
