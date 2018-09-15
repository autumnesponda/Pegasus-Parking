
class Garage {
  String garageName = "Garage ";
  int capacity;
  int availableSpots;
  int percentFull;
  int timeToPark;

  Garage(this.garageName, this.capacity, this.availableSpots,
      this.percentFull);

  Garage.initToEmpty() {
    this.garageName = null;
    this.capacity = -1;
    this.availableSpots = -1;
    this.percentFull = -1;
    this.timeToPark = -1;
  }

  // Checks if this garage is valid.
  bool isComplete() {
    if (garageName == null)
      return false;
    if (capacity == -1)
      return false;
    if (availableSpots == -1)
      return false;
    if (percentFull == -1)
      return false;
    if (timeToPark == -1)
      return false;

    return true;
  }

  @override
  String toString() {
    return("$garageName: $availableSpots/$capacity; $percentFull percent full. About $timeToPark minutes to park.");
  }
}