
class Garage {
  String garageName = "Garage ";
  int capacity;
  int availableSpots;
  int percentFull;

  Garage(this.garageName, this.capacity, this.availableSpots,
      this.percentFull);

  Garage.initToEmpty() {
    this.garageName = null;
    this.capacity = -1;
    this.availableSpots = -1;
    this.percentFull = -1;
  }

  bool isComplete() {
    if (garageName == null)
      return false;
    if (capacity == -1)
      return false;
    if (availableSpots == -1)
      return false;
    if (percentFull == -1)
      return false;
    return true;

  }

  @override
  String toString() {
    return("$garageName: $availableSpots/$capacity; $percentFull percent full");
  }
}