int xpForTask(String type) {
  switch (type) {
    case "habit":
      return 10;
    case "daily":
      return 15;
    case "todo":
      return 20;
    case "workout":
      return 25;
    default:
      return 5;
  }
}
