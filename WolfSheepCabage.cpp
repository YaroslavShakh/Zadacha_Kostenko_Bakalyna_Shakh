#include <iostream>
#include <vector>
#include <queue>
#include <map>
#include <set>
#include <algorithm>

using namespace std;


struct State {
    int f, w, g, c;

    bool operator<(const State& other) const {
        return vector<int>{f, w, g, c} < vector<int>{other.f, other.w, other.g, other.c};
    }
    
    bool operator==(const State& other) const {
        return f == other.f && w == other.w && g == other.g && c == other.c;
    }
};

bool isValid(const State& s) {
    if (s.w == s.g && s.w != s.f) return false;

    if (s.g == s.c && s.g != s.f) return false;
    return true;
}

void printStep(const State& s) {
    cout << "F:" << (s.f ? "R" : "L") << " ";
    cout << "W:" << (s.w ? "R" : "L") << " ";
    cout << "G:" << (s.g ? "R" : "L") << " ";
    cout << "C:" << (s.c ? "R" : "L") << endl;
}

int main() {
    State start = {0, 0, 0, 0}; 
    State goal = {1, 1, 1, 1}; 

    queue<State> q;
    q.push(start);

    map<State, State> parent; 
    set<State> visited;
    visited.insert(start);
    parent[start] = {-1, -1, -1, -1};

    State finalState = {-1, -1, -1, -1};

    while (!q.empty()) {
        State current = q.front();
        q.pop();

        if (current == goal) {
            finalState = current;
            break;
        }

        vector<State> nextStates;
        int newF = 1 - current.f; 

        nextStates.push_back({newF, current.w, current.g, current.c});
        
        if (current.f == current.w) nextStates.push_back({newF, newF, current.g, current.c});
        
        if (current.f == current.g) nextStates.push_back({newF, current.w, newF, current.c});

        if (current.f == current.c) nextStates.push_back({newF, current.w, current.g, newF});

        for (const auto& next : nextStates) {
            if (isValid(next) && visited.find(next) == visited.end()) {
                visited.insert(next);
                parent[next] = current;
                q.push(next);
            }
        }
    }

    if (finalState.f != -1) {
        vector<State> path;
        for (State at = finalState; at.f != -1; at = parent[at]) {
            path.push_back(at);
        }
        reverse(path.begin(), path.end());

        cout << "Solution found in " << path.size() - 1 << " moves:\n";
        for (const auto& s : path) {
            printStep(s);
        }
    } else {
        cout << "No solution found." << endl;
    }

    return 0;
}