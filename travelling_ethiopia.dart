import 'package:collection/collection.dart';

class TravelingEthiopia {
  final Map<dynamic, List<MapEntry<dynamic, int>>> graph;
  final Map<dynamic, int> heuristic;

  TravelingEthiopia(this.graph, this.heuristic);

  List<dynamic>? search(dynamic start, dynamic goal, String strategy) {
    switch (strategy) {
      case 'UniformCost':
        return uniformCostSearch(start, goal);
      case 'GreedyBFS':
        return greedyBfs(start, goal);
      case 'A*':
        return aStarSearch(start, goal);
      default:
        throw ArgumentError(
            "Unsupported strategy. Choose from 'UniformCost', 'GreedyBFS', or 'A*'.");
    }
  }

  List<dynamic>? uniformCostSearch(dynamic start, dynamic goal) {
    var openList = PriorityQueue<MapEntry<int, dynamic>>(
      (a, b) => a.key.compareTo(b.key),
    );
    openList.add(MapEntry(0, start));

    var cameFrom = <dynamic, dynamic>{};
    var costSoFar = {start: 0};

    while (openList.isNotEmpty) {
      var currentEntry = openList.removeFirst();
      var current = currentEntry.value;

      if (current == goal) {
        return reconstructPath(cameFrom, current, costSoFar[current]!);
      }

      (graph[current] ?? []).forEach((neighborEntry) {
        var newCost = currentEntry.key + neighborEntry.value;
        if (!costSoFar.containsKey(neighborEntry.key) ||
            newCost < costSoFar[neighborEntry.key]!) {
          costSoFar[neighborEntry.key] = newCost;
          openList.add(MapEntry(newCost, neighborEntry.key));
          cameFrom[neighborEntry.key] = current;
        }
      });
    }

    return null;
  }

  List<dynamic>? greedyBfs(dynamic start, dynamic goal) {
    var openList = PriorityQueue<MapEntry<int, dynamic>>(
      (a, b) => a.key.compareTo(b.key),
    );
    openList.add(MapEntry(heuristic[start]!, start));

    var cameFrom = <dynamic, dynamic>{};
    var costSoFar = {start: 0};

    while (openList.isNotEmpty) {
      var current = openList.removeFirst().value;

      if (current == goal) {
        return reconstructPath(cameFrom, current, costSoFar[current]!);
      }

      (graph[current] ?? []).forEach((neighborEntry) {
        var newCost = costSoFar[current]! + neighborEntry.value;
        if (!costSoFar.containsKey(neighborEntry.key) ||
            newCost < costSoFar[neighborEntry.key]!) {
          costSoFar[neighborEntry.key] = newCost;
          openList
              .add(MapEntry(heuristic[neighborEntry.key]!, neighborEntry.key));
          cameFrom[neighborEntry.key] = current;
        }
      });
    }

    return null;
  }

  List<dynamic>? aStarSearch(dynamic start, dynamic goal) {
    var openList = PriorityQueue<MapEntry<int, dynamic>>(
      (a, b) => a.key.compareTo(b.key),
    );
    openList.add(MapEntry(heuristic[start]!, start));

    var cameFrom = <dynamic, dynamic>{};
    var gScore = {start: 0};

    while (openList.isNotEmpty) {
      var current = openList.removeFirst().value;

      if (current == goal) {
        return reconstructPath(cameFrom, current, gScore[current]!);
      }

      (graph[current] ?? []).forEach((neighborEntry) {
        var tentativeGScore = gScore[current]! + neighborEntry.value;
        if (!gScore.containsKey(neighborEntry.key) ||
            tentativeGScore < gScore[neighborEntry.key]!) {
          gScore[neighborEntry.key] = tentativeGScore;
          int fScore = tentativeGScore + heuristic[neighborEntry.key]!;
          openList.add(MapEntry(fScore, neighborEntry.key));
          cameFrom[neighborEntry.key] = current;
        }
      });
    }

    return null;
  }

  List<dynamic> reconstructPath(
      Map<dynamic, dynamic> cameFrom, dynamic current, int cost) {
    var totalPath = <dynamic>[current];
    while (cameFrom.containsKey(current)) {
      current = cameFrom[current];
      totalPath.insert(0, current);
    }
    return [totalPath, cost];
  }
}
