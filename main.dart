import 'dart:io';

void main() {
  // Create a dummy graph.
  Map<String, List<MapEntry<String, int>>> graph = {
    'Addis Ababa': [MapEntry('Bahir Dar', 5), MapEntry('Dire Dawa', 16)],
    'Bahir Dar': [MapEntry('Gondar', 6), MapEntry('Addis Ababa', 5)],
    'Gondar': [MapEntry('Axum', 7)],
    'Axum': [MapEntry('Mekelle', 4)],
    'Mekelle': [MapEntry('Dire Dawa', 15)],
    'Dire Dawa': [MapEntry('Addis Ababa', 16), MapEntry('Mekelle', 15)]
  };

  // Create a dummy heuristic map.
  Map<String, int> heuristic = {
    'Addis Ababa': 10,
    'Bahir Dar': 7,
    'Gondar': 3,
    'Axum': 1,
    'Mekelle': 4
  };

  // Initialize the TravelingEthiopia class with the graph and heuristic
  TravelingEthiopia ethiopia = TravelingEthiopia(graph, heuristic);

  while (true) {
    print('Available cities: ${graph.keys.join(", ")}');
    stdout.write('Enter start city or type "exit" to quit: ');
    String? startInput = stdin.readLineSync(); // `readLineSync` can return null
    if (startInput == null || startInput.toLowerCase() == 'exit') break;

    stdout.write('Enter goal city: ');
    String? goalInput = stdin.readLineSync();
    if (goalInput == null) continue; // Continue if input is null

    stdout.write('Choose strategy (UniformCost, GreedyBFS, A*): ');
    String? strategyInput = stdin.readLineSync();
    if (strategyInput == null) continue; // Continue if input is null

    try {
      List<dynamic>? result =
          ethiopia.search(startInput, goalInput, strategyInput);
      if (result == null) {
        print('No path found or error occurred\n');
      } else {
        print('Result using $strategyInput: $result\n');
      }
    } catch (e) {
      print('Error: ${e.toString()}\n');
    }
  }

  print('Exiting travel planner...');
}

// Define the `TravelingEthiopia` class
class TravelingEthiopia {
  final Map<String, List<MapEntry<String, int>>> graph;
  final Map<String, int> heuristic;

  TravelingEthiopia(this.graph, this.heuristic);

  List<dynamic>? search(String start, String goal, String strategy) {
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

  // Dummy implementations: these should be replaced with actual algorithms
  List<dynamic>? uniformCostSearch(String start, String goal) => [start, goal];
  List<dynamic>? greedyBfs(String start, String goal) => [start, goal];
  List<dynamic>? aStarSearch(String start, String goal) => [start, goal];
}
